import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';

part 'intermediate_border.g.dart';

@JsonSerializable(explicitToJson: true)
class PBBorder {
  String blendMode;

  String type;

  PBColor color;

  @JsonKey(defaultValue: true)
  bool visible;

  final pbdlType = 'border';

  PBBorder({
    this.blendMode,
    this.type,
    this.color,
    this.visible,
  });

  factory PBBorder.fromJson(Map<String, dynamic> json) {
    return _$PBBorderFromJson(json);
  }
  @override
  Map<String, dynamic> toJson() => _$PBBorderToJson(this);
}
