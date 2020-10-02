import 'package:hex/hex.dart';

abstract class PBColor {
  PBColor(
    this.alpha,
    this.red,
    this.green,
    this.blue,
  );

  double alpha;
  double red;
  double green;
  double blue;

  toJson();
}

mixin PBColorMixin {
  String toHex(PBColor color) {
    if (color != null) {
      int a, r, g, b;
      a = ((color.alpha ?? 0) * 255).round();
      r = ((color.red ?? 0) * 255).round();
      g = ((color.green ?? 0) * 255).round();
      b = ((color.blue ?? 0) * 255).round();
      return '0x' + HEX.encode([a, r, g, b]);
    } else {
      return '0x' + HEX.encode([0, 0, 0, 0]);
    }
  }
}
