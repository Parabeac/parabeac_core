import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_font_descriptor.dart';
part 'font_descriptor.g.dart';

@JsonSerializable(nullable: true)
class FontDescriptor implements PBFontDescriptor {
  @override
  @JsonKey(name: 'attributes')
  Map<String, dynamic> rawAttributes;
  @override
  @JsonKey(ignore: true)
  String fontName;
  @override
  @JsonKey(ignore: true)
  num fontSize;
  @JsonKey(ignore: true)
  String fontWeight;
  @JsonKey(ignore: true)
  String fontStyle;
  @JsonKey(ignore: true)
  num letterSpacing;

  FontDescriptor({this.rawAttributes}) {
    fontSize = rawAttributes['size'];
    fontName = rawAttributes['name'];
  }

  factory FontDescriptor.fromJson(Map<String, dynamic> json) =>
      _$FontDescriptorFromJson(json);

  Map<String, dynamic> toJson() => _$FontDescriptorToJson(this);
}
