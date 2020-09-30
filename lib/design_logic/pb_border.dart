import 'color.dart';

abstract class PBBorder {
  final bool isEnabled;
  final double fillType;
  final PBColor color;
  final double thickness;

  PBBorder({
    this.isEnabled = true,
    this.fillType,
    this.color,
    this.thickness,
  });

  toJson();
}
