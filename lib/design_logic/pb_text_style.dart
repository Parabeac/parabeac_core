import 'package:parabeac_core/design_logic/color.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_font_descriptor.dart';
import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';

abstract class PBTextStyle {
  PBColor fontColor;
  String weight;
  PBFontDescriptor fontDescriptor;
  PBParagraphStyle paragraphStyle;

  PBTextStyle({
    this.fontColor,
    this.weight,
    this.paragraphStyle,
  });

  toJson();
}
