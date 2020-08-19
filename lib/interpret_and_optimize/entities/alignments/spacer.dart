import 'package:parabeac_core/generation/generators/visual-widgets/pb_spacer_gen.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spacer.g.dart';

@JsonSerializable(nullable: true)
class Spacer extends PBVisualIntermediateNode {
  int flex;
  final String UUID;
  String widgetType = 'SPACER';

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  Spacer(topLeftCorner, bottomRightCorner, this.UUID,
      {this.flex, this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext, UUID: UUID) {
    generator = PBSpacerGenerator();
  }

  @override
  void addChild(PBIntermediateNode node) {
    assert(false, 'Spacer cannot accept any children.');
  }

  factory Spacer.fromJson(Map<String, Object> json) => _$SpacerFromJson(json);
  Map<String, Object> toJson() => _$SpacerToJson(this);

  @override
  void alignChild() {}
}
