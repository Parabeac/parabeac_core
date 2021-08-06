import 'package:parabeac_core/generation/generators/layouts/pb_row_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/stack_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/handle_flex.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

///Row contains nodes that are all `horizontal` to each other, without overlapping eachother

class PBIntermediateRowLayout extends PBLayoutIntermediateNode {
  static final List<LayoutRule> ROW_RULES = [HorizontalNodesLayoutRule()];

  static final List<LayoutException> ROW_EXCEPTIONS = [
    RowOverlappingException()
  ];

  @override
  PrototypeNode prototypeNode;

  @override
  AlignStrategy alignStrategy = RowAlignment();

  PBIntermediateRowLayout(PBContext currentContext, {String name})
      : super(ROW_RULES, ROW_EXCEPTIONS, currentContext, name) {
    generator = PBRowGenerator();
  }

  @override
  void addChild(node) => addChildToLayout(node);

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var row = PBIntermediateRowLayout(currentContext, name: name);
    row.prototypeNode = prototypeNode;
    children.forEach((child) => row.addChild(child));
    return row;
  }

  @override
  void sortChildren() => replaceChildren(children
    ..sort((child0, child1) =>
        child0.topLeftCorner.x.compareTo(child1.topLeftCorner.x)));
}

class RowAlignment extends AlignStrategy<PBIntermediateRowLayout>{
  @override
  void align(PBContext context, PBIntermediateRowLayout node) {
    node.checkCrossAxisAlignment();
    if (node.currentContext.configuration.widgetSpacing == 'Expanded') {
      _addPerpendicularAlignment(node);
      _addParallelAlignment(node);
    } else {
      assert(false,
          'We don\'t support Configuration [${node.currentContext.configuration.widgetSpacing}] yet.');
    }
  }

   void _addParallelAlignment(PBIntermediateRowLayout node) {
    var newchildren = handleFlex(false, node.topLeftCorner, node.bottomRightCorner,
        node.children?.cast<PBIntermediateNode>());
    node.replaceChildren(newchildren);
  }

  void _addPerpendicularAlignment(PBIntermediateRowLayout node) {
    var rowMinY = node.topLeftCorner.y;
    var rowMaxY = node.bottomRightCorner.y;

    if (node.topLeftCorner.y < node.currentContext.screenTopLeftCorner.y) {
      rowMinY = node.currentContext.screenTopLeftCorner.y;
    }
    if (node.bottomRightCorner.y > node.currentContext.screenBottomRightCorner.y) {
      rowMaxY = node.currentContext.screenBottomRightCorner.y;
    }

    for (var i = 0; i < node.children.length; i++) {
      var padding = Padding('', node.children[i].constraints,
          top: node.children[i].topLeftCorner.y - rowMinY ?? 0.0,
          bottom: rowMaxY - node.children[i].bottomRightCorner.y ?? 0.0,
          left: 0.0,
          right: 0.0,
          topLeftCorner: node.children[i].topLeftCorner,
          bottomRightCorner: node.children[i].bottomRightCorner,
          currentContext: node.currentContext);
      padding.addChild(node.children[i]);

      //Replace Children.
      var childrenCopy = node.children;
      childrenCopy[i] = padding;
      node.replaceChildren(childrenCopy);
    }
  }

}
