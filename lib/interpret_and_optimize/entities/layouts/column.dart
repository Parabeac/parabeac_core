import 'dart:math';

import 'package:parabeac_core/generation/generators/layouts/pb_column_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/stack_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/handle_flex.dart';

///Colum contains nodes that are all `vertical` to each other, without overlapping eachother

class PBIntermediateColumnLayout extends PBLayoutIntermediateNode {
  static final List<LayoutRule> COLUMN_RULES = [
    VerticalNodesLayoutRule(),
  ];

  static final List<LayoutException> COLUMN_EXCEPTIONS = [
    ColumnOverlappingException(),
  ];

  @override
  PrototypeNode prototypeNode;

  @override
  AlignStrategy alignStrategy = ColumnAlignment();

  PBIntermediateColumnLayout(Rectangle frame, {String name})
      : super(null, frame, COLUMN_RULES, COLUMN_EXCEPTIONS, name) {
    generator = PBColumnGenerator();
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var col = PBIntermediateColumnLayout(null, name: name);
    col.prototypeNode = prototypeNode;
    //FIXME children.forEach((child) => col.addChild(child));
    return col;
  }
}

class ColumnAlignment extends AlignStrategy<PBIntermediateColumnLayout> {
  /// Invert method for Column alignment
  void _invertAlignment(PBIntermediateColumnLayout node) {
    if (node.alignment.isNotEmpty) {
      var tempCrossAxis = node.alignment['crossAxisAlignment'];
      var tempMainAxis = node.alignment['mainAxisAlignment'];
      node.alignment['crossAxisAlignment'] = tempMainAxis;
      node.alignment['mainAxisAlignment'] = tempCrossAxis;
    }
  }

  @override
  void align(PBContext context, PBIntermediateColumnLayout node) {
    // node.checkCrossAxisAlignment();
    // _invertAlignment(node);
    // if (context.configuration.widgetSpacing == 'Expanded') {
    //   _addPerpendicularAlignment(node, context);
    //   _addParallelAlignment(node, context);
    // } else {
    //   assert(false,
    //       'We don\'t support Configuration [${context.configuration.widgetSpacing}] yet.');
    // }
  }

  // void _addParallelAlignment(
  //     PBIntermediateColumnLayout node, PBContext context) {
  //   var newchildren = handleFlex(true, node.frame.topLeft,
  //       node.frame.bottomRight, node.children?.cast<PBIntermediateNode>());
  //   node.replaceChildren(newchildren, context);
  // }

  // void _addPerpendicularAlignment(
  //     PBIntermediateColumnLayout node, PBContext context) {
  //   var columnMinX = node.frame.topLeft.x;
  //   var columnMaxX = node.frame.bottomRight.x;

  //   for (var i = 0; i < node.children.length; i++) {
  //     var padding = Padding(
  //       null,
  //       node.frame,
  //       node.children[i].constraints,
  //       left: node.children[i].frame.topLeft.x - columnMinX ?? 0.0,
  //       right: columnMaxX - node.children[i].frame.bottomRight.x ?? 0.0,
  //       top: 0.0,
  //       bottom: 0.0,
  //     );
  //   //FIXME  padding.addChild(node.children[i]);

  //     //Replace Children.
  //     node.children[i] = padding;
  //   }
  // }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
