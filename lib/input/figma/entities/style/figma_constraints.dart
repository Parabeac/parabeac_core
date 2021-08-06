import 'package:json_annotation/json_annotation.dart';

part 'figma_constraints.g.dart';

/// Defined by https://www.figma.com/plugin-docs/api/Constraints/
@JsonSerializable(nullable: true)
class FigmaConstraints {
  FigmaConstraints(this.horizontal, this.vertical);
  FigmaConstraintType horizontal;
  FigmaConstraintType vertical;

  factory FigmaConstraints.fromJson(Map<String, dynamic> json) =>
      _$FigmaConstraintsFromJson(json);
  Map<String, dynamic> toJson() => _$FigmaConstraintsToJson(this);
}

enum FigmaConstraintType {
  @JsonValue('CENTER')
  CENTER,
  @JsonValue('TOP_BOTTOM')
  TOP_BOTTOM,
  @JsonValue('LEFT_RIGHT')
  LEFT_RIGHT,
  @JsonValue('SCALE')
  SCALE,
  @JsonValue('TOP')
  TOP,
  @JsonValue('BOTTOM')
  BOTTOM,
  @JsonValue('RIGHT')
  RIGHT,
  @JsonValue('LEFT')
  LEFT
}
