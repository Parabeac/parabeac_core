import 'package:parabeac_core/generation/generators/layouts/pb_column_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/layout_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/exceptions/stack_exception.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/axis_comparison_rules.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/rules/layout_rule.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
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

  PBIntermediateColumnLayout(
    PBContext currentContext,
    {String name}) : super(COLUMN_RULES, COLUMN_EXCEPTIONS, currentContext, name) {
    generator = PBColumnGenerator();
  }

  @override
  void alignChildren() {
    checkCrossAxisAlignment();
    _invertAlignment();
    if (currentContext.configuration.widgetSpacing == 'Expanded') {
      _addPerpendicularAlignment();
      _addParallelAlignment();
    } else {
      assert(false,
          'We don\'t support Configuration [${currentContext.configuration.widgetSpacing}] yet.');
    }
  }

  void _addParallelAlignment() {
    var newchildren = handleFlex(true, topLeftCorner, bottomRightCorner,
        children?.cast<PBIntermediateNode>());
    replaceChildren(newchildren);
  }

  void _addPerpendicularAlignment() {
    var columnMinX = topLeftCorner.x;
    var columnMaxX = bottomRightCorner.x;

    for (var i = 0; i < children.length; i++) {
      var padding = Padding('', children[i].constraints,
          left: children[i].topLeftCorner.x - columnMinX ?? 0.0,
          right: columnMaxX - children[i].bottomRightCorner.x ?? 0.0,
          top: 0.0,
          bottom: 0.0,
          topLeftCorner: children[i].topLeftCorner,
          bottomRightCorner: children[i].bottomRightCorner,
          currentContext: currentContext);
      padding.addChild(children[i]);

      //Replace Children.
      var childrenCopy = children;
      childrenCopy[i] = padding;
      replaceChildren(childrenCopy?.cast<PBIntermediateNode>());
    }
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var col = PBIntermediateColumnLayout(currentContext, name: name);
    col.prototypeNode = prototypeNode;
    children.forEach((child) => col.addChild(child));
    return col;
  }

  @override
  void addChild(node) => addChildToLayout(node);

  /// Invert method for Column alignment
  void _invertAlignment() {
    if (alignment.isNotEmpty) {
      var tempCrossAxis = alignment['crossAxisAlignment'];
      var tempMainAxis = alignment['mainAxisAlignment'];
      alignment['crossAxisAlignment'] = tempMainAxis;
      alignment['mainAxisAlignment'] = tempCrossAxis;
    }
  }
}
