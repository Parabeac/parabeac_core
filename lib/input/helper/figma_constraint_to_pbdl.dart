import 'package:parabeac_core/input/figma/entities/style/figma_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pbdl_constraints.dart';

PBDLConstraints convertFigmaConstraintToPBDLConstraint(
    FigmaConstraints figmaConstraints) {
  var constraints = PBDLConstraints();
  constraints =
      _convertFigmaConstraint(figmaConstraints.horizontal, constraints, false);
  return _convertFigmaConstraint(figmaConstraints.vertical, constraints, true);
}

/// Defined by https://www.figma.com/plugin-docs/api/Constraints/
PBDLConstraints _convertFigmaConstraint(FigmaConstraintType figmaConstraintType,
    PBDLConstraints constraints, bool isVertical) {
  if (figmaConstraintType == FigmaConstraintType.SCALE) {
    if (isVertical) {
      constraints.pinTop = false;
      constraints.pinBottom = false;
      constraints.fixedHeight = false;
    } else {
      constraints.pinLeft = false;
      constraints.pinRight = false;
      constraints.fixedWidth = false;
    }
  } else if (figmaConstraintType == FigmaConstraintType.TOP) {
    constraints.pinTop = true;
    constraints.pinBottom = false;
    constraints.fixedHeight = true;
  } else if (figmaConstraintType == FigmaConstraintType.LEFT) {
    constraints.pinLeft = true;
    constraints.pinRight = false;
    constraints.fixedWidth = true;
  } else if (figmaConstraintType == FigmaConstraintType.RIGHT) {
    constraints.pinLeft = false;
    constraints.pinRight = true;
    constraints.fixedWidth = true;
  } else if (figmaConstraintType == FigmaConstraintType.BOTTOM) {
    constraints.pinTop = false;
    constraints.pinBottom = true;
    constraints.fixedHeight = true;
  } else if (figmaConstraintType == FigmaConstraintType.CENTER) {
    if (isVertical) {
      constraints.pinTop = false;
      constraints.pinBottom = false;
      constraints.fixedHeight = true;
    } else {
      constraints.pinLeft = false;
      constraints.pinRight = false;
      constraints.fixedWidth = true;
    }
  } else if (figmaConstraintType == FigmaConstraintType.TOP_BOTTOM) {
    constraints.pinTop = true;
    constraints.pinBottom = true;
    constraints.fixedHeight = false;
  } else if (figmaConstraintType == FigmaConstraintType.LEFT_RIGHT) {
    constraints.pinLeft = true;
    constraints.pinRight = true;
    constraints.fixedWidth = false;
  } else {
    print(
        'We currently do not support Figma Constraint Type: ${figmaConstraintType}');
  }
  return constraints;
}

// } else if (figmaConstraintType == FigmaConstraintType.MIN) {
//   if (isVertical) {
//     constraints.pinTop = true;
//     constraints.pinBottom = false;
//     constraints.fixedHeight = false;
//   } else {
//     constraints.pinLeft = true;
//     constraints.pinRight = false;
//     constraints.fixedWidth = false;
//   }
// } else if (figmaConstraintType == FigmaConstraintType.MAX) {
//   if (isVertical) {
//     constraints.pinTop = false;
//     constraints.pinBottom = true;
//     constraints.fixedHeight = false;
//   } else {
//     constraints.pinLeft = false;
//     constraints.pinRight = true;
//     constraints.fixedWidth = false;
//   }
