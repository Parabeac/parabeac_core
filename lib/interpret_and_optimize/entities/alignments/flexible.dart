import 'package:parabeac_core/generation/generators/visual-widgets/pb_flexible_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'package:json_annotation/json_annotation.dart';
part 'flexible.g.dart';

@JsonSerializable(nullable: true)
class Flexible extends PBVisualIntermediateNode {
  int flex;
  var child;

  @override
  @JsonKey(ignore: true)
  var currentContext;

  final String UUID;

  @override
  @JsonKey(nullable: false, ignore: false)
  String widgetType = 'FLEXIBLE';

  //TODO: Find a way to make currentContext required
  //without breaking the json serializable
  Flexible(
    this.UUID, {
    this.currentContext,
    this.child,
    this.flex,
    this.topLeftCorner,
    this.bottomRightCorner,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID) {
    generator = PBFlexibleGenerator(currentContext.generationManager);
  }

  @JsonKey(ignore: true)
  Point topLeftCorner;
  @JsonKey(ignore: true)
  Point bottomRightCorner;

  @override
  void addChild(PBIntermediateNode node) {
    assert(child == null, 'Tried adding another child to Flexible');
    child = node;
  }

  factory Flexible.fromJson(Map<String, Object> json) =>
      _$FlexibleFromJson(json);

  Map<String, Object> toJson() => _$FlexibleToJson(this);

  @override
  void alignChild() {}
}
