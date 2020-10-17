import 'package:parabeac_core/design_logic/color.dart';

import 'package:json_annotation/json_annotation.dart';
part 'figma_color.g.dart';

@JsonSerializable()
class FigmaColor implements PBColor {
  @override
  double alpha;

  @override
  double blue;

  @override
  double green;

  @override
  double red;

  FigmaColor({this.alpha, this.red, this.green, this.blue});

  @override
  Map<String, dynamic> toJson() => _$FigmaColorToJson(this);

  factory FigmaColor.fromJson(Map<String, dynamic> json) =>
      _$FigmaColorFromJson(json);
}
