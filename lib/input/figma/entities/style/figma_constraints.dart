/// Defined by https://www.figma.com/plugin-docs/api/Constraints/
class FigmaConstraints {
  FigmaConstraints(this.horizontal, this.vertical);
  FigmaConstraintType horizontal;
  FigmaConstraintType vertical;
}

enum FigmaConstraintType { MIN, CENTER, MAX, STRETCH, SCALE }
