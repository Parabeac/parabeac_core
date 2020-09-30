import 'package:parabeac_core/design_logic/color.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class PBTextStyle {
  PBColor fontColor;
  String fontWeight;
  String fontSize;
  String fontFamily;
  ALIGNMENT alignment;

  PBTextStyle({
    this.fontColor,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.alignment,
  });

  toJson();
}

enum ALIGNMENT {
  LEFT,
  RIGHT,
  CENTER,
  JUSTIFY,
}
