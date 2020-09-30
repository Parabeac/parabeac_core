import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';

part 'figma_text_style.g.dart';

@JsonSerializable()
class FigmaTextStyle implements PBTextStyle {
  @override
  PBColor fontColor;

  @override
  String fontFamily;

  @override
  String fontSize;

  @override
  String fontWeight;

  FigmaTextStyle({Color this.fontColor});

  @override
  ALIGNMENT alignment;

  Map<String, dynamic> toJson() => _$FigmaTextStyleToJson(this);
  factory FigmaTextStyle.fromJson(Map<String, dynamic> json) =>
      _$FigmaTextStyleFromJson(json);
}
