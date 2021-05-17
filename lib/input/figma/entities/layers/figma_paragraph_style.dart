import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';

class FigmaParagraphStyle implements PBParagraphStyle {
  @override
  int alignment = ALIGNMENT.LEFT.index;

  FigmaParagraphStyle({this.alignment});
}
