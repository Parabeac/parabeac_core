import 'dart:developer';

import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';

/// Named PBDL in anticipation of the refactor where PBDL becomes the design standard.
/// Each property must be set.
/// TODO: Use https://pub.dev/packages/meta to make these named parameters required.
class PBIntermediateConstraints {
  bool pinLeft;
  bool pinRight;
  bool pinTop;
  bool pinBottom;

  /// If value is null, then the height is not fixed.
  double fixedHeight;

  /// If value is null, then the width is not fixed.
  double fixedWidth;

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

  PBIntermediateConstraints.mergeFromContraints(
      PBIntermediateConstraints first, PBIntermediateConstraints second) {
    pinTop = (first.pinTop || second.pinTop) ? true : false;
    pinLeft = (first.pinLeft || second.pinLeft) ? true : false;
    pinRight = (first.pinRight || second.pinRight) ? true : false;
    pinBottom = (first.pinBottom || second.pinBottom) ? true : false;

    /// Set Fixed Height Value
    if (first.fixedHeight != null || second.fixedHeight != null) {
      if (first.fixedHeight != null && second.fixedHeight != null) {
        if (first.fixedHeight != second.fixedHeight) {
          log('PBIntermediatConstraints tried merging constraints where fixed height & fixed height were both set & not equal.');
          fixedHeight = first.fixedHeight;
        } else {
          fixedHeight = first.fixedHeight;
        }
      }
      if (first.fixedHeight == null) {
        fixedHeight = second.fixedHeight;
      } else {
        fixedHeight = first.fixedHeight;
      }
    }

    /// Set Fixed Width Value
    if (first.fixedWidth != null || second.fixedWidth != null) {
      if (first.fixedWidth != null && second.fixedWidth != null) {
        if (first.fixedWidth != second.fixedWidth) {
          log('PBIntermediatConstraints tried merging constraints where fixed width & fixed width were both set & not equal.');
          fixedWidth = first.fixedHeight;
        } else {
          fixedWidth = first.fixedHeight;
        }
      }
      if (first.fixedWidth == null) {
        fixedWidth = second.fixedWidth;
      } else {
        fixedWidth = first.fixedWidth;
      }
    }
  }
}
