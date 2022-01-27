import 'package:pbdl/pbdl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intermediate_effect.g.dart';

@JsonSerializable(explicitToJson: true)
class PBEffect {
  EffectType type;
  bool visible;
  num radius;
  PBDLColor color;
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

enum EffectType {
  LAYER_BLUR,
  DROP_SHADOW,
  INNER_SHADOW,
  BACKGROUND_BLUR,
}
