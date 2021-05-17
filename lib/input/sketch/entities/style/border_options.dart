import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
part 'border_options.g.dart';

@JsonSerializable(nullable: true)
class BorderOptions implements PBBorderOptions {
  @JsonKey(name: '_class')
  String classField;
  @override
  bool isEnabled;
  @override
  List dashPattern;
  @override
  int lineCapStyle, lineJoinStyle;

  BorderOptions(
    this.classField,
    this.dashPattern,
    this.isEnabled,
    this.lineCapStyle,
    this.lineJoinStyle,
  );

  factory BorderOptions.fromJson(Map json) => _$BorderOptionsFromJson(json);
  @override
  Map toJson() => _$BorderOptionsToJson(this);
}
