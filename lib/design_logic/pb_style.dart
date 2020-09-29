import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';

abstract class PBStyle {
  PBColor backgroundColor;
  PBFill fills;

  PBStyle({this.fills, this.backgroundColor});
}
