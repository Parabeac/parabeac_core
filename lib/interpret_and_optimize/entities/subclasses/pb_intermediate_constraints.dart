import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';

part 'pb_intermediate_constraints.g.dart';

/// Named PBDL in anticipation of the refactor where PBDL becomes the design standard.
/// Each property must be set.
/// TODO: Use https://pub.dev/packages/meta to make these named parameters required.
@JsonSerializable()
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

  factory PBIntermediateConstraints.fromConstraints(
          Map<String, dynamic> json, double height, double width) =>
      PBIntermediateConstraints(
        pinLeft: json['pinLeft'],
        pinRight: json['pinRight'],
        pinTop: json['pinTop'],
        pinBottom: json['pinBottom'],
        fixedHeight: json['fixedHeight'] ? height : null,
        fixedWidth: json['fixedWidth'] ? width : null,
      );

  factory PBIntermediateConstraints.fromJson(Map<String, dynamic> json) =>
      _$PBIntermediateConstraintsFromJson(json);

  Map<String, dynamic> toJson() => _$PBIntermediateConstraintsToJson(this);

  PBIntermediateConstraints clone() {
    return PBIntermediateConstraints(
        pinBottom: pinBottom,
        pinTop: pinTop,
        pinRight: pinRight,
        pinLeft: pinLeft,
        fixedHeight: fixedHeight,
        fixedWidth: fixedWidth);
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
