import 'package:json_annotation/json_annotation.dart';
part 'font_descriptor.g.dart';

@JsonSerializable(nullable: true)
class FontDescriptor {
  @JsonKey(name: 'attributes')
  Map<String, dynamic> rawAttributes;
  @JsonKey(ignore: true)
  String fontName;
  @JsonKey(ignore: true)
  num fontSize;
  @JsonKey(ignore: true)
  String fontWeight;
  @JsonKey(ignore: true)
  String fontStyle;

  FontDescriptor({this.rawAttributes}) {
    fontSize = rawAttributes['size'];
    fontName = rawAttributes['name'];
  }

  factory FontDescriptor.fromJson(Map<String, dynamic> json) =>
      _$FontDescriptorFromJson(json);

  Map<String, dynamic> toJson() => _$FontDescriptorToJson(this);
}
