import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';

/// Named PBDL in anticipation of the refactor where PBDL becomes the design standard.
/// Each property must be set.
/// TODO: Use https://pub.dev/packages/meta to make these named parameters required.
class PBIntermediateConstraints {
  PBIntermediateConstraints(
      {this.pinLeft,
      this.pinRight,
      this.pinTop,
      this.pinBottom,
      this.fixedHeight,
      this.fixedWidth});

  PBIntermediateConstraints.fromConstraints(
      PBDLConstraints constraints, double height, double width) {
    pinLeft = constraints.pinLeft ?? false;
    pinRight = constraints.pinRight ?? false;
    pinTop = constraints.pinTop ?? false;
    pinBottom = constraints.pinBottom ?? false;
    if (constraints.fixedHeight) {
      fixedHeight = height;
    }
    if (constraints.fixedWidth) {
      fixedWidth = width;
    }
  }
  bool pinLeft;
  bool pinRight;
  bool pinTop;
  bool pinBottom;

  /// If value is null, then the height is not fixed.
  double fixedHeight;

  /// If value is null, then the width is not fixed.
  double fixedWidth;
}
