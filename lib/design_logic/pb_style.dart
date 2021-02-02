import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';

class PBStyle {
  PBColor backgroundColor;
  List<PBFill> fills;
  List<PBBorder> borders;
  PBBorderOptions borderOptions;
  PBTextStyle textStyle;

  PBStyle({this.fills, this.backgroundColor});

  // toPBDF() {}

  factory PBStyle.fromPBDF(Map<String, dynamic> json) {
    if (json.containsKey('_class')) {
      return Style.fromJson(json);
    } else {
      return FigmaStyle.fromJson(json);
    }
  }
}
