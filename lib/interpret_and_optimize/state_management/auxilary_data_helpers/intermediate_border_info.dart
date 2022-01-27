import 'package:json_annotation/json_annotation.dart';
import 'intermediate_border.dart';

part 'intermediate_border_info.g.dart';

@JsonSerializable(explicitToJson: true)
class PBBorderInfo {
  List<PBBorder> borders;

  num strokeWeight;

  String strokeAlign;

  String strokeJoin;

  List strokeDashes;

  num cornerRadius;

  final pbdlType = 'border_options';

  PBBorderInfo({
    this.borders,
    this.strokeWeight,
    this.strokeAlign,
    this.strokeJoin,
    this.strokeDashes,
    this.cornerRadius,
  });

  @override
  factory PBBorderInfo.fromJson(Map<String, dynamic> json) =>
      _$PBBorderInfoFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PBBorderInfoToJson(this);
}
