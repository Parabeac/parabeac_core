import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';

class FigmaTextStyle implements PBTextStyle {
  @override
  PBColor fontColor;

  @override
  String fontFamily;

  @override
  String fontSize;

  @override
  String fontWeight;

  FigmaTextStyle();
}
