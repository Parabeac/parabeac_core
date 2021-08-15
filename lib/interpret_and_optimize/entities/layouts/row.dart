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

  PBIntermediateRowLayout({String name})
      : super(null, null, ROW_RULES, ROW_EXCEPTIONS, name) {
    generator = PBRowGenerator();
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var row = PBIntermediateRowLayout(name: name);
    row.prototypeNode = prototypeNode;
   //FIXME children.forEach((child) => row.addChild(child));
    return row;
  }

  // @override
  // void sortChildren() => replaceChildren(children
  //   ..sort((child0, child1) =>
  //       child0..frame.topLeft.x.compareTo(child1.frame.topLeft.x)));
}

class RowAlignment extends AlignStrategy<PBIntermediateRowLayout> {
  @override
  void align(PBContext context, PBIntermediateRowLayout node) {
    node.checkCrossAxisAlignment();
    if (context.configuration.widgetSpacing == 'Expanded') {
      _addPerpendicularAlignment(node, context);
      _addParallelAlignment(node, context);
    } else {
      assert(false,
          'We don\'t support Configuration [${context.configuration.widgetSpacing}] yet.');
    }
  }

  void _addParallelAlignment(PBIntermediateRowLayout node, PBContext context) {
    var newchildren = handleFlex(false, node.frame.topLeft,
        node.frame.bottomRight, node.children?.cast<PBIntermediateNode>());
    node.replaceChildren(newchildren, context);
  }

  void _addPerpendicularAlignment(
      PBIntermediateRowLayout node, PBContext context) {
    var rowMinY = node.frame.topLeft.y;
    var rowMaxY = node.frame.bottomRight.y;

    if (node.frame.topLeft.y < context.screenFrame.topLeft.y) {
      rowMinY = context.screenFrame.topLeft.y;
    }
    if (node.frame.bottomRight.y > context.screenFrame.bottomRight.y) {
      rowMaxY = context.screenFrame.bottomRight.y;
    }

    for (var i = 0; i < node.children.length; i++) {
      var padding = Padding(
        null,
        node.frame,
        node.children[i].constraints,
        top: node.children[i].frame.topLeft.y - rowMinY ?? 0.0,
        bottom: rowMaxY - node.children[i].frame.bottomRight.y ?? 0.0,
        left: 0.0,
        right: 0.0,
      );
   //FIXME   padding.addChild(node.children[i]);

      //Replace Children.
      node.children[i] = padding;
    }
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var row = PBIntermediateRowLayout(name: name);
    // row.prototypeNode = prototypeNode;
   //FIXME children.forEach((child) => row.addChild(child));
    return row;
  }

  // @override
  // void sortChildren() => replaceChildren(children
  //   ..sort((child0, child1) =>
  //       child0 .frame.topLeft.x.compareTo(child1 .frame.topLeft.x)));

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
