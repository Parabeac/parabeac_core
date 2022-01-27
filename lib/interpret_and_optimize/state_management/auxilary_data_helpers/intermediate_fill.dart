import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:pbdl/src/pbdl/pbdl_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intermediate_fill.g.dart';

@JsonSerializable(explicitToJson: true)
class PBFill {
  // String that tidentifies the ID of the image
  String imageRef;

  PBColor color;

  @JsonKey(defaultValue: 100)
  num opacity;

  String blendMode;

  String type;

  @JsonKey(defaultValue: true)
  bool isEnabled;

  final pbdlType = 'fill';

  PBFill({
    this.opacity,
    this.blendMode,
    this.type,
    this.isEnabled,
    this.color,
    this.imageRef,
  });

  @override
  factory PBFill.fromJson(Map<String, dynamic> json) => _$PBFillFromJson(json);

  Map<String, dynamic> toJson() => _$PBFillToJson(this);
}

// enum BlendMode {
//   NORMAL,
//   DARKEN,
//   MULTIPLY,
//   COLOR_BURN,
//   LIGHTEN,
//   SCREEN,
//   COLOR_DODGE,
//   OVERLAY,
//   SOFT_LIGHT,
//   HARD_LIGHT,
//   DIFFERENCE,
//   EXCLUSION,
//   HUE,
//   SATURATION,
//   COLOR,
//   LUMINOSITY,
// }
