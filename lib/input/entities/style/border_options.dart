import 'package:json_annotation/json_annotation.dart';
part 'border_options.g.dart';

@JsonSerializable(nullable: true)
class BorderOptions{
  @JsonKey(name: '_class')
  final String classField;
  final bool isEnabled;
  final List dashPattern;
  final int lineCapStyle, lineJoinStyle;

  BorderOptions({this.classField, this.dashPattern, this.isEnabled, this.lineCapStyle, this.lineJoinStyle});

  factory BorderOptions.fromJson(Map json) =>_$BorderOptionsFromJson(json);
  Map toJson() => _$BorderOptionsToJson(this);
}
