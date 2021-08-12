import 'dart:html';

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

  PBIntermediateColumnLayout(PBContext currentContext, Rectangle frame,
      {String name})
      : super(null, frame, COLUMN_RULES, COLUMN_EXCEPTIONS, currentContext,
            name) {
    generator = PBColumnGenerator();
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var col = PBIntermediateColumnLayout(currentContext, null, name: name);
    col.prototypeNode = prototypeNode;
    children.forEach((child) => col.addChild(child));
    return col;
  }

  @override
  void addChild(node) => addChildToLayout(node);
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
    node.checkCrossAxisAlignment();
    _invertAlignment(node);
    if (node.currentContext.configuration.widgetSpacing == 'Expanded') {
      _addPerpendicularAlignment(node);
      _addParallelAlignment(node);
    } else {
      assert(false,
          'We don\'t support Configuration [${node.currentContext.configuration.widgetSpacing}] yet.');
    }
  }

  void _addParallelAlignment(PBIntermediateColumnLayout node) {
    var newchildren = handleFlex(true, node.topLeftCorner,
        node.bottomRightCorner, node.children?.cast<PBIntermediateNode>());
    node.replaceChildren(newchildren);
  }

  void _addPerpendicularAlignment(PBIntermediateColumnLayout node) {
    var columnMinX = node.topLeftCorner.x;
    var columnMaxX = node.bottomRightCorner.x;

    for (var i = 0; i < node.children.length; i++) {
      var padding = Padding(null, node.frame, node.children[i].constraints,
          left: node.children[i].topLeftCorner.x - columnMinX ?? 0.0,
          right: columnMaxX - node.children[i].bottomRightCorner.x ?? 0.0,
          top: 0.0,
          bottom: 0.0,
          currentContext: node.currentContext);
      padding.addChild(node.children[i]);

      //Replace Children.
      var childrenCopy = node.children;
      childrenCopy[i] = padding;
      node.replaceChildren(childrenCopy?.cast<PBIntermediateNode>());
    }
  }

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) => null;
}
