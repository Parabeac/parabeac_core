import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_color.dart';
import 'intermediate_border.dart';

part 'intermediate_border_info.g.dart';

/// Class that represents the border information for a node.
///
/// We are operating under the assumption that every [PBIntermediateNode]
/// can only have a single border.
@JsonSerializable(explicitToJson: true)
class IntermediateBorderInfo {
  /// TODO: Consider removing this class and simplifying the structure of PBDL to
  /// lay out all border options insde a single class.
  @JsonKey(fromJson: _borderFromJson, name: 'borders')
  PBBorder border;

  @JsonKey(name: 'strokeWeight')
  num thickness;

  String strokeAlign;

  String strokeJoin;

  List strokeDashes;

  @JsonKey(name: 'cornerRadius')
  num borderRadius;

  final pbdlType = 'border_options';

  /// These gets are used in order to not break existing tag files
  /// that use these attributes directly. We can deprecate these over time
  /// or rethink the way borders is structured.
  String get blendMode => border?.blendMode;

  String get type => border?.type;

  PBColor get color => border?.color;

  bool get visible => border?.visible;

  IntermediateBorderInfo({
    this.border,
    this.thickness,
    this.strokeAlign,
    this.strokeJoin,
    this.strokeDashes,
    this.borderRadius,
  });

  @override
  factory IntermediateBorderInfo.fromJson(Map<String, dynamic> json) =>
      _$IntermediateBorderInfoFromJson(json);

  Map<String, dynamic> toJson() => _$IntermediateBorderInfoToJson(this);

  static PBBorder _borderFromJson(List borders) =>
      borders == null || borders.isEmpty ? null : PBBorder.fromJson(borders[0]);
}
