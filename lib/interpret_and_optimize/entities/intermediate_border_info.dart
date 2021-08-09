import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'package:json_annotation/json_annotation.dart';

part 'intermediate_border_info.g.dart';

@JsonSerializable()
class IntermediateBorderInfo {
  num borderRadius;

  PBColor color;

  num thickness;

  String shape;

  /// Whether `color`, `thickness` and `shape` are available.
  ///
  /// Note that `borderRadius` should always be enabled
  @JsonKey(name: 'isEnabled')
  bool isBorderOutlineVisible;

  IntermediateBorderInfo({
    this.borderRadius,
    this.color,
    this.thickness,
    this.shape,
    this.isBorderOutlineVisible,
  });

  factory IntermediateBorderInfo.fromJson(Map<String, dynamic> json) =>
      _$IntermediateBorderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IntermediateBorderInfoToJson(this);
}
