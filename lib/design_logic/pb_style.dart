import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';

abstract class PBStyle {
  PBColor backgroundColor;
  List<PBFill> fills;
  List<PBBorder> borders;
  PBBorderOptions borderOptions;
  PBTextStyle textStyle;

  PBStyle({this.fills, this.backgroundColor});
  Map<String, dynamic> toJson();
}
