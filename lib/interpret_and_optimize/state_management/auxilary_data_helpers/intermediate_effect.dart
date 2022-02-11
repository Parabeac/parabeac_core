import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intermediate_effect.g.dart';

@JsonSerializable(explicitToJson: true)
class PBEffect {
  String type;
  bool visible;
  num radius;
  PBColor color;
  String blendMode;
  Map offset;
  bool showShadowBehindNode;

  var pbdlType = 'effect';

  PBEffect({
    this.type,
    this.visible,
    this.radius,
    this.color,
    this.blendMode,
    this.offset,
    this.showShadowBehindNode,
  });

  Map<String, dynamic> toJson() => _$PBEffectToJson(this);
  factory PBEffect.fromJson(Map<String, dynamic> json) =>
      _$PBEffectFromJson(json);
}
