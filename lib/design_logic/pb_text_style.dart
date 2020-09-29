import 'package:parabeac_core/design_logic/color.dart';

abstract class PBTextStyle {
  PBColor fontColor;
  String fontWeight;
  String fontSize;
  String fontFamily;

  PBTextStyle({
    this.fontColor,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
  });
}
