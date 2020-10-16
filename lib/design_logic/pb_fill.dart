import 'package:parabeac_core/design_logic/color.dart';

abstract class PBFill {
  PBColor color;
  bool isEnabled;
  PBFill(this.color, [this.isEnabled = true]);

  toJson();
}
