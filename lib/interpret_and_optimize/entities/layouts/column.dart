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
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:uuid/uuid.dart';

import 'package:json_annotation/json_annotation.dart';

part 'column.g.dart';

///Colum contains nodes that are all `vertical` to each other, without overlapping eachother
@JsonSerializable(nullable: true)
class PBIntermediateColumnLayout extends PBLayoutIntermediateNode {
  @JsonKey(ignore: true)
  static final List<LayoutRule> COLUMN_RULES = [
    VerticalNodesLayoutRule(),
  ];

  @JsonKey(ignore: true)
  static final List<LayoutException> COLUMN_EXCEPTIONS = [
    ColumnOverlappingException(),
  ];

  @override
  final String UUID;

  @override
  PBContext currentContext;

  @override
  @JsonKey(ignore: true)
  Point topLeftCorner;

  @override
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  Map alignment = {};

  

  @override
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;

  PBIntermediateColumnLayout(
    String name, {
    this.currentContext,
    this.UUID,
  }) : super(COLUMN_RULES, COLUMN_EXCEPTIONS, currentContext, name) {
    generator = PBColumnGenerator();
    checkCrossAxisAlignment();
  }

  checkCrossAxisAlignment() {
    // TODO: this is the default for now
    alignment['crossAxisAlignment'] =
        'crossAxisAlignment: CrossAxisAlignment.start';
  }

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
    var newchildren = handleFlex(true, topLeftCorner, bottomRightCorner,
        children?.cast<PBIntermediateNode>());
    replaceChildren(newchildren);
  }

  void _addPerpendicularAlignment() {
    var columnMinX = topLeftCorner.x;
    var columnMaxX = bottomRightCorner.x;

    if (topLeftCorner.x < currentContext.screenTopLeftCorner.x) {
      columnMinX = currentContext.screenTopLeftCorner.x;
    }
    if (bottomRightCorner.x > currentContext.screenBottomRightCorner.x) {
      columnMaxX = currentContext.screenBottomRightCorner.x;
    }

    for (var i = 0; i < children.length; i++) {
      //TODO: Check to see if the left or right padding or both is equal to 0 or even negative if that's even possible.
      var padding = Padding(Uuid().v4(),
          left: children[i].topLeftCorner.x - columnMinX,
          right: columnMaxX - children[i].bottomRightCorner.x,
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
    var col = PBIntermediateColumnLayout(name,
        currentContext: currentContext, UUID: Uuid().v4());
    col.prototypeNode = prototypeNode;
    children.forEach((child) => col.addChild(child));
    return col;
  }

  @override
  void addChild(PBIntermediateNode node) => addChildToLayout(node);

  factory PBIntermediateColumnLayout.fromJson(Map<String, Object> json) =>
      _$PBIntermediateColumnLayoutFromJson(json);
  Map<String, Object> toJson() => _$PBIntermediateColumnLayoutToJson(this);
}
