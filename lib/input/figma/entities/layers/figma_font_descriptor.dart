import 'package:parabeac_core/design_logic/pb_font_descriptor.dart';

class FigmaFontDescriptor implements PBFontDescriptor {
  @override
  String fontName;

  @override
  num fontSize;

  @override
  Map<String, dynamic> rawAttributes;

  FigmaFontDescriptor(
    this.fontName,
    this.fontSize,
    this.rawAttributes,
  );
}
