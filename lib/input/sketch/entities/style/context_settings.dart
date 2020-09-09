import 'package:json_annotation/json_annotation.dart';
part 'context_settings.g.dart';

@JsonSerializable(nullable: true)
class ContextSettings{
  @JsonKey(name: '_class')
  final String classField;
  final double blendMode, opacity;

  ContextSettings({this.blendMode, this.classField, this.opacity});

  factory ContextSettings.fromJson(Map json) =>_$ContextSettingsFromJson(json);
  Map toJson() => _$ContextSettingsToJson(this);
}
