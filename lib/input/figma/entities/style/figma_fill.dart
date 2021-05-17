import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
part 'figma_fill.g.dart';

@JsonSerializable()
class FigmaFill implements PBFill {
  @override
  PBColor color;

  FigmaFill(FigmaColor this.color, [this.isEnabled = true]);

  @override
  bool isEnabled;

  @override
  Map<String, dynamic> toJson() => _$FigmaFillToJson(this);
  factory FigmaFill.fromJson(Map<String, dynamic> json) =>
      _$FigmaFillFromJson(json);
}
