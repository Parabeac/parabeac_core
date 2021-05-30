/// Named PBDL in anticipation of the refactor where PBDL becomes the design standard.
/// Each property must be set, potentially use https://pub.dev/packages/meta to make these named parameters required.
class PBDLConstraints {
  PBDLConstraints(
      {this.pinLeft,
      this.pinRight,
      this.pinTop,
      this.pinBottom,
      this.fixedHeight,
      this.fixedWidth});
  bool pinLeft;
  bool pinRight;
  bool pinTop;
  bool pinBottom;
  bool fixedHeight;
  bool fixedWidth;
}
