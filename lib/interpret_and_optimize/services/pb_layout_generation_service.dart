import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_constraint_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/stack_reduction_visual_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

/// PBLayoutGenerationService:
/// Inject PBLayoutIntermediateNode to a PBIntermediateNode Tree that signifies the grouping of PBItermediateNodes in a given direction. There should not be any PBAlignmentIntermediateNode in the input tree.
/// Input: PBVisualIntermediateNode Tree or PBLayoutIntermediate Tree
/// Output:PBIntermediateNode Tree
class PBLayoutGenerationService implements PBGenerationService {
  ///The available Layouts that could be injected.
  final List<PBLayoutIntermediateNode> _availableLayouts = [];

  var log = Logger('Layout Generation Service');

  ///[LayoutRule] that check post conditions.
  final List<PostConditionRule> _postLayoutRules = [
    StackReductionVisualRule(),
    ContainerPostRule(),
    ContainerConstraintRule()
  ];

  @override
  PBContext currentContext;

  ///Going to replace the [TempGroupLayoutNode]s by [PBLayoutIntermediateNode]s
  ///The default [PBLayoutIntermediateNode]
  PBLayoutIntermediateNode _defaultLayout;

  PBLayoutGenerationService({this.currentContext}) {
    var layoutHandlers = <String, PBLayoutIntermediateNode>{
      'column': PBIntermediateColumnLayout(
        '',
        currentContext: currentContext,
        UUID: Uuid().v4(),
      ),
      'row': PBIntermediateRowLayout('', Uuid().v4(),
          currentContext: currentContext),
      'stack': PBIntermediateStackLayout('', Uuid().v4(),
          currentContext: currentContext),
    };

    for (var layoutType
        in currentContext.configuration.layoutPrecedence ?? ['column']) {
      layoutType = layoutType.toLowerCase();
      if (layoutHandlers.containsKey(layoutType)) {
        _availableLayouts.add(layoutHandlers[layoutType]);
      }
    }

    _defaultLayout = _availableLayouts[0];
  }

  PBIntermediateNode extractLayouts(
    PBIntermediateNode rootNode,
  ) {
    if (rootNode == null) {
      return rootNode;
    }
    try {
      rootNode = _traverseLayersUtil(rootNode, (layer) {
        return layer

            ///Remove the `TempGroupLayout` nodes that only contain one node
            .map(_removingMeaninglessGroup)
            .map(_layoutConditionalReplacement)
            .toList()

              /// Filter out the elements that are null in the tree
              ..removeWhere((element) => element == null);
      });

      ///After all the layouts are generated, the [PostConditionRules] are going
      ///to be applyed to the layerss
      return _applyPostConditionRules(rootNode);
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      log.error(e.toString());
    } finally {
      return rootNode;
    }
  }

  PBIntermediateNode _traverseLayersUtil(
      PBIntermediateNode rootNode,
      List<PBIntermediateNode> Function(List<PBIntermediateNode> layer)
          transformation) {
    ///The stack is going to saving the current layer of tree along with the parent of
    ///the layer. It makes use of a `Tuple2()` to save the parent in the first index and a list
    ///of nodes for the current layer in the second layer.
    var stack = <Tuple2<PBIntermediateNode, List<PBAttribute>>>[];
    stack.add(Tuple2(null, [
      PBAttribute('root', attributeNodes: [rootNode])
    ]));

    while (stack.isNotEmpty) {
      var currentTuple = stack.removeLast();
      currentTuple.item2.forEach((currentAttribute) {
        currentAttribute.attributeNodes =
            transformation(currentAttribute.attributeNodes);
        currentAttribute?.attributeNodes?.forEach((currentNode) {
          currentNode?.attributes?.forEach((attribute) {
            stack.add(Tuple2(currentNode, [
              PBAttribute(attribute.attributeName,
                  attributeNodes: attribute.attributeNodes)
            ]));
          });
        });
      });
      var node = currentTuple.item1;
      if (node != null) {
        currentTuple.item2.forEach((attribute) {
          node.addAttribute(attribute, overwrite: true);
        });
      } else {
        ///if the `currentTuple.item1` is null, that implies the `currentTuple.item2.first` is the
        ///new `rootNode`.
        rootNode = currentTuple.item2.first.attributeNode;
      }
    }
    return rootNode;
  }

  /// If this node is an unecessary [TempGroupLayoutNode], just return the child or an
  /// [InjectContainer] if the group is empty
  ///
  /// Ex: Designer put a group with one child that was a group
  /// and that group contained the visual nodes.
  PBIntermediateNode _removingMeaninglessGroup(PBIntermediateNode tempGroup) {
    while (tempGroup is TempGroupLayoutNode && tempGroup.children.length <= 1) {
      tempGroup = (tempGroup as TempGroupLayoutNode).children.isNotEmpty
          ? _replaceNode(
              tempGroup, (tempGroup as TempGroupLayoutNode).children[0])
          : _replaceNode(
              tempGroup,
              InjectedContainer(tempGroup.bottomRightCorner,
                  tempGroup.topLeftCorner, tempGroup.name, tempGroup.UUID));
    }
    return tempGroup;
  }

  ///If `node` contains a single or multiple [PBIntermediateNode]s
  bool _containsChildren(PBIntermediateNode node) =>
      (node is PBVisualIntermediateNode && node.child != null) ||
      (node is PBLayoutIntermediateNode && node.children.isNotEmpty);

  ///Each of the [TempGroupLayoutNode] could derive multiple [IntermediateLayoutNode]s because
  ///nodes should be considered into subsections. For example, if child 0 and child 1 statisfy the
  ///rule of a [Row] but not child 3, then child 0 and child 1 should be placed inside of a [Row]. Therefore,
  ///there could be many[IntermediateLayoutNodes] derived in the children level of the `group`.
  PBIntermediateNode _layoutConditionalReplacement(PBIntermediateNode parent,
      {depth = 1}) {
    if (parent is PBLayoutIntermediateNode && depth >= 0) {
      parent.sortChildren();
      var children = parent.children;
      var childPointer = 0;
      var reCheck = false;

      while (childPointer < children.length - 1) {
        var currentNode = children[childPointer];
        var nextNode = children[childPointer + 1];

        for (var layout in _availableLayouts) {
          if (layout.satisfyRules(currentNode, nextNode) &&
              layout.runtimeType != parent.runtimeType) {
            var generatedLayout;

            ///If either `currentNode` or `nextNode` is of the same `runtimeType` as the satified [PBLayoutIntermediateNode],
            ///then its going to use either one instead of creating a new [PBLayoutIntermediateNode].
            if (layout.runtimeType == currentNode.runtimeType) {
              currentNode.addChild(nextNode);
              currentNode =
                  _layoutConditionalReplacement(currentNode, depth: depth - 1);
              generatedLayout = currentNode;
            } else if (layout.runtimeType == nextNode.runtimeType) {
              nextNode.addChild(currentNode);
              nextNode =
                  _layoutConditionalReplacement(nextNode, depth: depth - 1);
              generatedLayout = nextNode;
            }

            ///If neither of the current nodes are of the same `runtimeType` as the layout, we are going to use the actual
            ///satified [PBLayoutIntermediateNode] to generate the layout. We place both of the nodes inside
            ///of the generated layout.
            generatedLayout ??= layout
                .generateLayout([currentNode, nextNode], currentContext, '');
            var start = childPointer, end = childPointer + 2;
            children.replaceRange(
                start,
                (end > children.length ? children.length : end),
                [generatedLayout]);
            childPointer = 0;
            reCheck = true;
            break;
          }
        }
        childPointer = reCheck ? 0 : childPointer + 1;
        reCheck = false;
      }
      parent.replaceChildren(children);
      if (children.length == 1) {
        return _replaceNode(parent, children[0]);
      } else {
        return parent is! TempGroupLayoutNode
            ? parent
            : _replaceNode(
                parent,
                _defaultLayout.generateLayout(
                    children, currentContext, parent.name));
      }
    }
    return parent;
  }

  ///Makes sure all the necessary attributes are recovered before replacing a [PBIntermediateNode]
  PBIntermediateNode _replaceNode(
      PBIntermediateNode candidate, PBIntermediateNode replacement) {
    if (candidate is PBLayoutIntermediateNode &&
        replacement is PBLayoutIntermediateNode) {
      replacement.prototypeNode = candidate.prototypeNode;
    }
    return replacement;
  }

  ///Applying [PostConditionRule]s at the end of the [PBLayoutIntermediateNode]
  PBIntermediateNode _applyPostConditionRules(PBIntermediateNode node) {
    if (node == null) {
      return node;
    }
    if (node is PBLayoutIntermediateNode && node.children.isNotEmpty) {
      node.replaceChildren(
          node.children.map((node) => _applyPostConditionRules(node)).toList());
    } else if (node is PBVisualIntermediateNode) {
      node.child = _applyPostConditionRules(node.child);
    }

    for (var postConditionRule in _postLayoutRules) {
      if (postConditionRule.testRule(node, null)) {
        var result = postConditionRule.executeAction(node, null);
        if (result != null) {
          return _replaceNode(node, result);
        }
      }
    }
    return node;
  }
}
