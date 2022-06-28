import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/layout_properties.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_constraint_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/stack_reduction_visual_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/group/group.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/tags/custom_tag/custom_tag.dart';
import 'package:sentry/sentry.dart';

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

  ///Going to replace the [Group]s by [PBLayoutIntermediateNode]s
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
      PBIntermediateTree tree, PBContext context) async {
    if (tree.rootNode == null) {
      return Future.value(tree);
    }
    try {
      _transformGroup(tree);
      _layoutTransformation(tree, context);

      ///After all the layouts are generated, the [PostConditionRules] are going
      ///to be applyed to the layerss
      _applyPostConditionRules(tree.rootNode, context);

      _wrapLayout(tree, context);
      if (tree.rootNode is PBSharedMasterNode) {
        _applyComponentRules(tree, tree.rootNode);
      }
      return Future.value(tree);
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
      logger.error(e.toString());
    } finally {
      return Future.value(tree);
    }
  }

  /// Method that applies specific layout rules that only apply to the [PBSharedMasterNode]s.
  ///
  /// Namely, when a [PBSharedMasterNode] has only one child, we need to inject
  /// a stack to ensure alignment.
  void _applyComponentRules(
      PBIntermediateTree tree, PBSharedMasterNode component) {
    /// Check that children is not an empty list
    var children = tree.childrenOf(component);
    var firstChild = children.isNotEmpty ? children.first : null;
    if (firstChild is CustomTag &&
        tree.childrenOf(firstChild).length == 1 &&
        tree.childrenOf(firstChild).first is! Group) {
      /// Get child's child
      var grandChild = tree.childrenOf(firstChild).first;

      _addStack(tree, firstChild, grandChild);
    } else if (tree.childrenOf(component).length == 1 && firstChild is! Group) {
      _addStack(tree, component, firstChild);
    }
  }

  void _addStack(
    PBIntermediateTree tree,
    PBIntermediateNode parent,
    PBIntermediateNode child,
  ) {
    /// TODO: Improve the way we create Stacks
    var stack = PBIntermediateStackLayout(
      name: parent.name,
      constraints: parent.constraints.copyWith(),
    )
      ..auxiliaryData = parent.auxiliaryData
      ..frame = parent.frame.copyWith()
      ..layoutCrossAxisSizing = parent.layoutCrossAxisSizing
      ..layoutMainAxisSizing = parent.layoutMainAxisSizing;

    /// Insert the stack below the component.
    tree.injectBetween(insertee: stack, parent: parent, child: child);
  }

  void _wrapLayout(PBIntermediateTree tree, PBContext context) {
    // Get all the LayoutIntermediateNodes from the tree
    tree.whereType<PBLayoutIntermediateNode>().forEach((tempGroup) {
      // Ignore Stacks
      // We will get only Columns and Rows
      if (tempGroup is! PBIntermediateStackLayout) {
        // Let tempLayout be Column or Row
        var tempLayout;
        var isVertical = true;
        if (tempGroup is PBIntermediateColumnLayout) {
          tempLayout = tempGroup;
        } else if (tempGroup is PBIntermediateRowLayout) {
          tempLayout = tempGroup;
          isVertical = false;
        }
        if (tempLayout.layoutProperties != null) {
          // Create the injected container to wrap the layout
          var wrapper = InjectedContainer(
            null,
            tempGroup.frame.copyWith(),
            name: tempGroup.name,
            // Add padding
            padding: InjectedPadding(
              left: tempLayout.layoutProperties.leftPadding,
              right: tempLayout.layoutProperties.rightPadding,
              top: tempLayout.layoutProperties.topPadding,
              bottom: tempLayout.layoutProperties.bottomPadding,
            ),
            constraints: tempLayout.constraints.copyWith(),
            // Let the Container know if it is going to show
            // the width or height on the generation process
            // showHeight: shouldBeShown(tempLayout, true, isVertical),
            // showWidth: shouldBeShown(tempLayout, false, isVertical),
            showHeight: isVertical
                ? tempLayout.layoutProperties.primaryAxisSizing ==
                    IntermediateAxisMode.FIXED
                : tempLayout.layoutProperties.crossAxisSizing ==
                    IntermediateAxisMode.FIXED,
            showWidth: isVertical
                ? tempLayout.layoutProperties.crossAxisSizing ==
                    IntermediateAxisMode.FIXED
                : tempLayout.layoutProperties.crossAxisSizing ==
                    IntermediateAxisMode.FIXED,
          )
            ..layoutCrossAxisSizing = tempLayout.layoutCrossAxisSizing
            ..layoutMainAxisSizing = tempLayout.layoutMainAxisSizing
            ..auxiliaryData = tempGroup.auxiliaryData;

          // Let the tree know that the layout will be
          // wrapped by the Container
          tree.wrapNode(wrapper, tempLayout);
        }
      }
    });
  }

  /// Transforming the [Group] into regular [PBLayoutIntermediateNode]
  void _transformGroup(PBIntermediateTree tree) {
    tree.whereType<Group>().forEach((tempGroup) {
      var newStack = PBIntermediateStackLayout(
        name: tempGroup.name,
        constraints: tempGroup.constraints.copyWith(),
      )
        ..auxiliaryData = tempGroup.auxiliaryData
        ..frame = tempGroup.frame.copyWith()
        ..layoutCrossAxisSizing = tempGroup.layoutCrossAxisSizing
        ..layoutMainAxisSizing = tempGroup.layoutMainAxisSizing;

      tree.replaceNode(
        tempGroup,
        newStack,
        acceptChildren: true,
      );

      if (tempGroup.auxiliaryData.colors != null) {
        var isVertical = true;
        if (tempGroup is PBIntermediateRowLayout) {
          isVertical = false;
        }
        var tempContainer = InjectedContainer(
          null,
          tempGroup.frame.copyWith(),
          constraints: tempGroup.constraints.copyWith(),
          name: tempGroup.name,
          showHeight: isVertical
              ? tempGroup.layoutMainAxisSizing == ParentLayoutSizing.INHERIT
              : tempGroup.layoutCrossAxisSizing == ParentLayoutSizing.INHERIT,
          showWidth: isVertical
              ? tempGroup.layoutCrossAxisSizing == ParentLayoutSizing.INHERIT
              : tempGroup.layoutMainAxisSizing == ParentLayoutSizing.INHERIT,
        )
          ..auxiliaryData = tempGroup.auxiliaryData
          ..layoutCrossAxisSizing = tempGroup.layoutCrossAxisSizing
          ..layoutMainAxisSizing = tempGroup.layoutMainAxisSizing;

        tree.wrapNode(tempContainer, newStack);
      }
    });
  }

  void _layoutTransformation(PBIntermediateTree tree, PBContext context) {
    for (var parent in tree) {
      var children = tree.childrenOf(parent);
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
          ///
          /// currentNode and parent shall be skipped if they are either a Row or Column
          /// because they should not be interpreted as Stack even though, their children
          /// are too close to each other.
          if (currentNode.attributeName != nextNode.attributeName ||
              currentNode is PBIntermediateColumnLayout ||
              currentNode is PBIntermediateRowLayout ||
              parent is PBIntermediateColumnLayout ||
              parent is PBIntermediateRowLayout) {
            break;
          }
          if (layout.satisfyRules(context, currentNode, nextNode) &&
              layout.runtimeType != parent.runtimeType) {
            ///If either `currentNode` or `nextNode` is of the same `runtimeType` as the satified [PBLayoutIntermediateNode],
            ///then its going to use either one instead of creating a new [PBLayoutIntermediateNode].
            if (layout.runtimeType == currentNode.runtimeType) {
              //FIXME   tree.replaceNode(nextNode, currentNode);
              tree.addEdges(currentNode, [nextNode]);
              tree.removeEdges(parent, [nextNode]);
            } else if (layout.runtimeType == nextNode.runtimeType) {
              //FIXME      tree.replaceNode(currentNode, nextNode);
              tree.addEdges(nextNode, [currentNode]);
              tree.removeEdges(parent, [currentNode]);
            } else {
              ///If neither of the current nodes are of the same `runtimeType` as the layout, we are going to use the actual
              ///satified [PBLayoutIntermediateNode] to generate the layout. We place both of the nodes inside
              ///of the generated layout.
              //FIXME      tree.removeNode(currentNode, eliminateSubTree: true);
              //FIXME      tree.removeNode(nextNode, eliminateSubTree: true);
              tree.removeEdges(parent, [currentNode, nextNode]);
              tree.addEdges(parent, [
                layout.generateLayout([currentNode, nextNode], context,
                    '${currentNode.name}${nextNode.name}${layout.runtimeType}')
              ]);
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
      PBContext context, PBIntermediateTree tree) async {
    return await extractLayouts(tree, context);
  }
}
