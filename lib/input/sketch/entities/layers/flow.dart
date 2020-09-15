import 'package:json_annotation/json_annotation.dart';

part 'flow.g.dart';

@JsonSerializable(nullable: true)
class Flow {
  @JsonKey(name: '_class')
  final String classField;
  String destinationArtboardID;
  bool maintainScrollPosition;
  dynamic animationType;
  Flow({
    this.classField,
    this.destinationArtboardID,
    this.maintainScrollPosition,
    this.animationType,
  });
  factory Flow.fromJson(Map<String, dynamic> json) => _$FlowFromJson(json);
  Map<String, dynamic> toJson() => _$FlowToJson(this);
}
