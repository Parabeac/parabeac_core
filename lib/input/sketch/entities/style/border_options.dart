import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
part 'border_options.g.dart';

@JsonSerializable(nullable: true)
class BorderOptions implements PBBorderOptions {
  @JsonKey(name: '_class')
  final String classField;
  @override
  final bool isEnabled;
  @override
  final List dashPattern;
  @override
  final int lineCapStyle, lineJoinStyle;

  BorderOptions(
      {this.classField,
      this.dashPattern,
      this.isEnabled,
      this.lineCapStyle,
      this.lineJoinStyle});

  factory BorderOptions.fromJson(Map json) => _$BorderOptionsFromJson(json);
  Map toJson() => _$BorderOptionsToJson(this);
}
