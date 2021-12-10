import 'package:json_annotation/json_annotation.dart';

part 'layout_properties.g.dart';

@JsonSerializable(createToJson: true)
class LayoutProperties {
  num spacing;

  num leftPadding;
  num rightPadding;
  num topPadding;
  num bottomPadding;

  IntermediateAxisAlignment primaryAxisAlignment;
  @JsonKey(name: 'counterAxisAlignment')
  IntermediateAxisAlignment crossAxisAlignment;

  IntermediateAxisMode primaryAxisSizing;
  @JsonKey(name: 'counterAxisSizing')
  IntermediateAxisMode crossAxisSizing;

  LayoutProperties({
    this.spacing,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
    this.bottomPadding,
    this.crossAxisAlignment,
    this.primaryAxisAlignment,
    this.crossAxisSizing,
    this.primaryAxisSizing,
  });

  @override
  factory LayoutProperties.fromJson(Map<String, dynamic> json) =>
      _$LayoutPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$LayoutPropertiesToJson(this);
}

enum IntermediateAxisAlignment { START, CENTER, END, SPACE_BETWEEN }

enum IntermediateAxisMode { FIXED, HUGGED }
