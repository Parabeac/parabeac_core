import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_constraint_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/stack_reduction_visual_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:path/path.dart';
import 'package:quick_log/quick_log.dart';
import 'package:tuple/tuple.dart';

/// PBLayoutGenerationService:
/// Inject PBLayoutIntermediateNode to a PBIntermediateNode Tree that signifies the grouping of PBItermediateNodes in a given direction. There should not be any PBAlignmentIntermediateNode in the input tree.
/// Input: PBVisualIntermediateNode Tree or PBLayoutIntermediate Tree
/// Output:PBIntermediateNode Tree
class PBLayoutGenerationService extends AITHandler {
  ///The available Layouts that could be injected.
  final List<PBLayoutIntermediateNode> _availableLayouts = [];

  ///[LayoutRule] that check post conditions.
  final List<PostConditionRule> _postLayoutRules = [
    StackReductionVisualRule(),
    // ContainerPostRule(),
    ContainerConstraintRule()
  ];

  ///Going to replace the [TempGroupLayoutNode]s by [PBLayoutIntermediateNode]s
  ///The default [PBLayoutIntermediateNode]
  PBLayoutIntermediateNode _defaultLayout;

  PBLayoutGenerationService() {
    var layoutHandlers = <String, PBLayoutIntermediateNode>{
      // 'column': PBIntermediateColumnLayout(
      //   '',
      //   currentContext: currentContext,
      //   UUID: Uuid().v4(),
      // ),
      // 'row': PBIntermediateRowLayout('', Uuid().v4(),
      //     currentContext: currentContext),
      'stack': PBIntermediateStackLayout(),
    };

    for (var layoutType
        in MainInfo().configuration.layoutPrecedence ?? ['column']) {
      layoutType = layoutType.toLowerCase();
      if (layoutHandlers.containsKey(layoutType)) {
        _availableLayouts.add(layoutHandlers[layoutType]);
      }
    }

    _defaultLayout = _availableLayouts[0];
  }

  Future<PBIntermediateTree> extractLayouts(
      PBIntermediateTree tree, PBContext context) {
    var rootNode = tree.rootNode;
    if (rootNode == null) {
      return Future.value(tree);
    }
    try {
      _removingMeaninglessGroup(tree);
      _transformGroup(tree);
      _layoutTransformation(tree, context);

      ///After all the layouts are generated, the [PostConditionRules] are going
      ///to be applyed to the layerss
      _applyPostConditionRules(rootNode, context);
      // return Future.value(tree);
    } catch (e) {
      MainInfo().captureException(
        e,
      );
      logger.error(e.toString());
    } finally {
      tree.rootNode = rootNode;
      return Future.value(tree);
    }
  }

  /// If this node is an unecessary [TempGroupLayoutNode], from the [tree]
  ///
  /// Ex: Designer put a group with one child that was a group
  /// and that group contained the visual nodes.
  void _removingMeaninglessGroup(PBIntermediateTree tree) {
    tree
        .where((node) =>
            node is TempGroupLayoutNode && tree.childrenOf(node).length <= 1)
        .cast<TempGroupLayoutNode>()
        .forEach((tempGroup) {
      var tempChildren = tree.childrenOf(tempGroup);
      tree.replaceNode(
          tempGroup,
          tempChildren.isNotEmpty
              ? _replaceNode(tempGroup, tempChildren.first)
              : _replaceNode(
                  tempGroup,
                  InjectedContainer(
                    tempGroup.UUID, tempGroup.frame,
                    name: tempGroup.name,
                    // constraints: tempGroup.constraints
                  )));
    });
  }

  /// Transforming the [TempGroupLayoutNode] into regular [PBLayoutIntermediateNode]
  void _transformGroup(PBIntermediateTree tree) {
    tree.whereType<TempGroupLayoutNode>().forEach((tempGroup) {
      //FIXME // tree.replaceNode(
      //     tempGroup,
      //     PBIntermediateStackLayout(
      //       name: tempGroup.name,
      //       constraints: tempGroup.constraints,
      //     )..frame = tempGroup.frame,
      //     acceptChildren: true);
    });
  }

  void _layoutTransformation(PBIntermediateTree tree, PBContext context) {
    for (var parent in tree) {
      var children = parent.children;
      children.sort((n0, n1) => n0.frame.topLeft.compareTo(n1.frame.topLeft));

      var childPointer = 0;
      var reCheck = false;
      while (childPointer < children.length - 1) {
        var currentNode = children[childPointer];
        var nextNode = children[childPointer + 1];

        for (var layout in _availableLayouts) {
          /// This conditional statement is to not mixup the elements that pertain to different [currentNode.attributeName].
          /// For example, if [currentNode.attributeName] is an `appBar` and [nextNode.attributeName] is a `stack`,
          /// then you would not generate a [PBLayoutIntermediateNode] to encapsulate them both.
          if (currentNode.attributeName != nextNode.attributeName) {
            break;
          }
          if (layout.satisfyRules(context, currentNode, nextNode) &&
              layout.runtimeType != parent.runtimeType) {
            ///If either `currentNode` or `nextNode` is of the same `runtimeType` as the satified [PBLayoutIntermediateNode],
            ///then its going to use either one instead of creating a new [PBLayoutIntermediateNode].
            if (layout.runtimeType == currentNode.runtimeType) {
              //FIXME   tree.replaceNode(nextNode, currentNode);
              currentNode.addChild(nextNode);
            } else if (layout.runtimeType == nextNode.runtimeType) {
              //FIXME      tree.replaceNode(currentNode, nextNode);
              nextNode.addChild(currentNode);
            } else {
              ///If neither of the current nodes are of the same `runtimeType` as the layout, we are going to use the actual
              ///satified [PBLayoutIntermediateNode] to generate the layout. We place both of the nodes inside
              ///of the generated layout.
              //FIXME      tree.removeNode(currentNode, eliminateSubTree: true);
              //FIXME      tree.removeNode(nextNode, eliminateSubTree: true);
              parent.addChild(layout.generateLayout(
                  [currentNode, nextNode],
                  context,
                  '${currentNode.name}${nextNode.name}${layout.runtimeType}'));
            }
            reCheck = true;
            break;
          }
        }
        childPointer = reCheck ? 0 : childPointer + 1;
        reCheck = false;
      }
    }
  }

  ///Makes sure all the necessary attributes are recovered before replacing a [PBIntermediateNode]
  PBIntermediateNode _replaceNode(
      PBIntermediateNode candidate, PBIntermediateNode replacement) {
    if (candidate is PBLayoutIntermediateNode &&
        replacement is PBLayoutIntermediateNode) {
      /// For supporting pinning & resizing information, we will merge constraints.
      print(replacement.constraints);
      replacement.constraints = PBIntermediateConstraints.mergeFromContraints(
          candidate.constraints ??
              PBIntermediateConstraints(
                  pinBottom: false,
                  pinLeft: false,
                  pinRight: false,
                  pinTop: false),
          replacement.constraints ??
              PBIntermediateConstraints(
                  pinBottom: false,
                  pinLeft: false,
                  pinRight: false,
                  pinTop: false));
      replacement.prototypeNode = candidate.prototypeNode;
    }
    return replacement;
  }

  ///Applying [PostConditionRule]s at the end of the [PBLayoutIntermediateNode]
  PBIntermediateNode _applyPostConditionRules(
      PBIntermediateNode node, PBContext context) {
    if (node == null) {
      return node;
    }
    var tree = context.tree;
    var nodeChildren = tree.childrenOf(node);
    if (node is PBLayoutIntermediateNode && nodeChildren.isNotEmpty) {
      tree.replaceChildrenOf(
          node, nodeChildren.map((e) => _applyPostConditionRules(e, context)));
    } else if (node is PBVisualIntermediateNode) {
      nodeChildren.map((e) => _applyPostConditionRules(e, context));
    }

    for (var postConditionRule in _postLayoutRules) {
      if (postConditionRule.testRule(context, node, null)) {
        var result = postConditionRule.executeAction(context, node, null);
        if (result != null) {
          return _replaceNode(node, result);
        }
      }
    }
    return node;
  }

  @override
  Future<PBIntermediateTree> handleTree(
      PBContext context, PBIntermediateTree tree) {
    return extractLayouts(tree, context);
  }
}
