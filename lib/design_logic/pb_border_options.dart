abstract class PBBorderOptions {
  final bool isEnabled;
  final List dashPattern;
  final int lineCapStyle, lineJoinStyle;

  PBBorderOptions({
    this.isEnabled,
    this.dashPattern,
    this.lineCapStyle,
    this.lineJoinStyle,
  });

  toJson();
}
