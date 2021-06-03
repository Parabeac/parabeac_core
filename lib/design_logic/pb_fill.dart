import 'package:parabeac_core/design_logic/color.dart';

abstract class PBFill {
  PBColor color;
  bool isEnabled;
  int fillType;

  PBFill(this.color, this.fillType, [this.isEnabled = true]);

  toJson();
}
