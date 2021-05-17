import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_font_descriptor.dart';
import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_paragraph_style.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';

part 'figma_text_style.g.dart';

@JsonSerializable()
class FigmaTextStyle implements PBTextStyle {
  @override
  PBColor fontColor;

  @override
  String weight;

  @JsonKey(ignore: true)
  @override
  PBFontDescriptor fontDescriptor;

  @override
  @JsonKey(ignore: true)
  PBParagraphStyle paragraphStyle;

  FigmaTextStyle({
    FigmaColor this.fontColor,
    this.fontDescriptor,
    this.weight,
    this.paragraphStyle,
  });

  @override
  Map<String, dynamic> toJson() => _$FigmaTextStyleToJson(this);
  factory FigmaTextStyle.fromJson(Map<String, dynamic> json) =>
      _$FigmaTextStyleFromJson(json);
}
