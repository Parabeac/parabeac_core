import 'package:json_annotation/json_annotation.dart';
part 'pb_configuration.g.dart';

@JsonSerializable(nullable: true)
class PBConfiguration {
  @JsonKey(defaultValue: 'Material')
  final String widgetStyle;

  @JsonKey(defaultValue: 'Stateless')
  final String widgetType;

  @JsonKey(defaultValue: 'Expanded')
  final String widgetSpacing;

  @JsonKey(defaultValue: 'None')
  final String stateManagement;

  @JsonKey(defaultValue: ['column', 'row', 'stack'])
  final List<String> layoutPrecedence;

  Map configurations;
  PBConfiguration(this.widgetStyle, this.widgetType, this.widgetSpacing,
      this.stateManagement, this.layoutPrecedence);

  factory PBConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PBConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$PBConfigurationToJson(this);
}
