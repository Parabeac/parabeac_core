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
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

///Row contains nodes that are all `horizontal` to each other, without overlapping eachother

class PBIntermediateRowLayout extends PBLayoutIntermediateNode {
  static final List<LayoutRule> ROW_RULES = [HorizontalNodesLayoutRule()];

  static final List<LayoutException> ROW_EXCEPTIONS = [
    RowOverlappingException()
  ];

  //TODO: remove all overriden UUID
  @override
  final String UUID;

  Map alignment = {};

  // @override
  // PBContext currentContext;

  @override
  PrototypeNode prototypeNode;

  PBIntermediateRowLayout(String name, this.UUID, {PBContext currentContext})
      : super(ROW_RULES, ROW_EXCEPTIONS, currentContext, name) {
    generator = PBRowGenerator();
    checkCrossAxisAlignment();
  }

  @override
  void addChild(PBIntermediateNode node) => addChildToLayout(node);

  @override
  void alignChildren() {
    if (currentContext.configuration.widgetSpacing == 'Expanded') {
      _addPerpendicularAlignment();
      _addParallelAlignment();
    } else {
      assert(false,
          'We don\'t support Configuration [${currentContext.configuration.widgetSpacing}] yet.');
    }
  }

  void _addParallelAlignment() {
    var newchildren = handleFlex(false, topLeftCorner, bottomRightCorner,
        children?.cast<PBIntermediateNode>());
    replaceChildren(newchildren);
  }

  void _addPerpendicularAlignment() {
    var rowMinY = topLeftCorner.y;
    var rowMaxY = bottomRightCorner.y;

    if (topLeftCorner.y < currentContext.screenTopLeftCorner.y) {
      rowMinY = currentContext.screenTopLeftCorner.y;
    }
    if (bottomRightCorner.y > currentContext.screenBottomRightCorner.y) {
      rowMaxY = currentContext.screenBottomRightCorner.y;
    }

    for (var i = 0; i < children.length; i++) {
      //TODO: Check to see if the left or right padding or both is equal to 0 or even negative if that's even possible.
      var padding = Padding(Uuid().v4(),
          top: children[i].topLeftCorner.y - rowMinY,
          bottom: rowMaxY - children[i].bottomRightCorner.y,
          topLeftCorner: children[i].topLeftCorner,
          bottomRightCorner: children[i].bottomRightCorner,
          currentContext: currentContext);
      padding.addChild(children[i]);

      //Replace Children.
      var childrenCopy = children;
      childrenCopy[i] = padding;
      replaceChildren(childrenCopy);
    }
  }

  @override
  PBLayoutIntermediateNode generateLayout(List<PBIntermediateNode> children,
      PBContext currentContext, String name) {
    var row = PBIntermediateRowLayout(name, Uuid().v4(),
        currentContext: currentContext);
    row.prototypeNode = prototypeNode;
    children.forEach((child) => row.addChild(child));
    return row;
  }

  checkCrossAxisAlignment() {
    // TODO: this is the default for now
    alignment['crossAxisAlignment'] =
        'crossAxisAlignment: CrossAxisAlignment.start,';
  }

  @override
  void sortChildren() => replaceChildren(children
    ..sort((child0, child1) =>
        child0.topLeftCorner.x.compareTo(child1.topLeftCorner.x)));
}
