import 'package:build/build.dart';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/column.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/row.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_constraint_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/container_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/stack.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/services/pb_generation_service.dart';
import 'package:quick_log/quick_log.dart';
import 'package:uuid/uuid.dart';

/// PBLayoutGenerationService:
/// Inject PBLayoutIntermediateNode to a PBIntermediateNode Tree that signifies the grouping of PBItermediateNodes in a given direction. There should not be any PBAlignmentIntermediateNode in the input tree.
/// Input: PBVisualIntermediateNode Tree or PBLayoutIntermediate Tree
/// Output:PBIntermediateNode Tree
class PBLayoutGenerationService implements PBGenerationService {
  ///The available Layouts that could be injected.
  List<PBLayoutIntermediateNode> _availableLayouts;

  var log = Logger('Layout Generation Service');

  ///[LayoutRule] that check post conditions.
  final List<PostConditionRule> _postLayoutRules = [
    ContainerPostRule(),
    ContainerConstraintRule()
  ];

  @override
  PBContext currentContext;

  PBLayoutGenerationService({this.currentContext}) {
    _availableLayouts = [
      PBIntermediateColumnLayout(
          currentContext: currentContext, UUID: Uuid().v4()),
      PBIntermediateRowLayout(Uuid().v4(), currentContext: currentContext),
      PBIntermediateStackLayout(Uuid().v4(), currentContext: currentContext)
    ];

    defaultLayout = PBIntermediateColumnLayout(
        currentContext: currentContext, UUID: Uuid().v4());
  }

  ///The default [PBLayoutIntermediateNode]
  PBLayoutIntermediateNode defaultLayout;

  ///Going to replace the [TempGroupLayoutNode]s by [PBLayoutIntermediateNode]s
  PBIntermediateNode injectNodes(PBIntermediateNode rootNode) {
    try {
      if (!(_containsChildren(rootNode))) {
        return rootNode;
      } else if (rootNode is PBVisualIntermediateNode) {
        rootNode.child = injectNodes(rootNode.child);
        return rootNode;
      } else if (rootNode is TempGroupLayoutNode) {
        rootNode = _replaceGroupByLayout(rootNode);
      }

      if (rootNode is PBLayoutIntermediateNode) {
        var children = rootNode.children;
        children = children.map((child) => injectNodes(child)).toList();
        rootNode.replaceChildren(children);
      }

      assert(
          rootNode != null, 'Layout Generation Service produced a null node.');

      // If we still have a temp group, this probably means this should be a container.
      if (rootNode is TempGroupLayoutNode) {
        assert(rootNode.children.length < 2,
            'TempGroupLayout was not converted and has multiple children.');
        // If this node is an unecessary temp group, just return the child. Ex: Designer put a group with one child that was a group and that group contained the visual nodes.
        if (rootNode.children[0] is InjectedContainer) {
          return rootNode.children[0];
        }
        var replacementNode = InjectedContainer(
            rootNode.bottomRightCorner, rootNode.topLeftCorner, Uuid().v4(),
            currentContext: currentContext);
        replacementNode.addChild(rootNode.children.first);
        return replacementNode;
      }
      rootNode = _postConditionRules(rootNode);
      return rootNode;
    } catch (e, stackTrace) {
      // FIXME: Capturing this exception causes sentry to crash parabeac-core.
      
      // MainInfo().sentry.captureException(
      //       exception: e,
      //       stackTrace: stackTrace,
      //     );

      /// Put breakpoint here to see when the stack overflow occurs TODO: PC-170
      // print(e);
      log.error(e.toString());
    }
  }

  bool _containsChildren(PBIntermediateNode node) =>
      (node is PBVisualIntermediateNode && node.child != null) ||
      (node is PBLayoutIntermediateNode && node.children.isNotEmpty);

  ///Each of the [TempGroupLayoutNode] could derive multiple [IntermediateLayoutNode]s because
  ///nodes should be considered into subsections. For example, if child 0 and child 1 statisfy the
  ///rule of a [Row] but not child 3, then child 0 and child 1 should be placed inside of a [Row]. Therefore,
  ///there could be many[IntermediateLayoutNodes] derived in the children level of the `group`.
  PBLayoutIntermediateNode _replaceGroupByLayout(TempGroupLayoutNode group) {
    var children = group.children;
    PBLayoutIntermediateNode rootLayout;

    if (children.length < 2) {
      ///the last step is going to replace these layout that contain one child into containers
      return group;
    }
    children = _arrangeChildren(group);
    rootLayout = children.length == 1
        ? children[0]
        : defaultLayout.generateLayout(children, currentContext);
    return rootLayout;
  }

  List<PBIntermediateNode> _arrangeChildren(PBLayoutIntermediateNode parent) {
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

          if (layout.runtimeType == currentNode.runtimeType) {
            currentNode.addChild(nextNode);
            (currentNode as PBLayoutIntermediateNode)
                .replaceChildren(_arrangeChildren(currentNode));
            generatedLayout = currentNode;
          } else if (layout.runtimeType == nextNode.runtimeType) {
            nextNode.addChild(currentNode);
            (nextNode as PBLayoutIntermediateNode)
                .replaceChildren(_arrangeChildren(nextNode));
            generatedLayout = nextNode;
          }
          generatedLayout ??=
              layout.generateLayout([currentNode, nextNode], currentContext);
          children
              .replaceRange(childPointer, childPointer + 2, [generatedLayout]);
          childPointer = 0;
          reCheck = true;
          break;
        }
      }
      childPointer = reCheck ? 0 : childPointer + 1;
      reCheck = false;
    }
    return children?.cast<PBIntermediateNode>();
  }

  ///Applying [PostConditionRule]s at the end of the [PBLayoutIntermediateNode]
  PBIntermediateNode _postConditionRules(PBIntermediateNode node) {
    if (node == null) {
      return node;
    }
    for (var postConditionRule in _postLayoutRules.reversed) {
      if (postConditionRule.testRule(node, null)) {
        var result = postConditionRule.executeAction(node, null);
        if (result != null) {
          return result;
        }
      }
    }

    if (node is PBLayoutIntermediateNode && node.children.isNotEmpty) {
      node.replaceChildren(node.children
          .map((node) => _postConditionRules(node as PBIntermediateNode))
          .toList());
    } else if (node is PBVisualIntermediateNode) {
      node.child = _postConditionRules(node.child);
    }
    return node;
  }
}
