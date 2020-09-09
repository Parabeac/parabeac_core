import 'package:json_annotation/json_annotation.dart';
import 'package:hex/hex.dart';

part 'color.g.dart';

@JsonSerializable(nullable: true)
class Color {
  @JsonKey(name: '_class')
  final String classField;
  final double alpha, blue, green, red;

  Color({this.alpha, this.blue, this.classField, this.green, this.red});

  ///Converts the current ARBG values into hex
  ///in the form of a string `0xAARRGGBB`
  String toHex() {
    int a, r, g, b;
    a = ((alpha ?? 0) * 255).round();
    r = ((red ?? 0) * 255).round();
    g = ((green ?? 0) * 255).round();
    b = ((blue ?? 0) * 255).round();
    return '0x' + HEX.encode([a, r, g, b]);
  }

  factory Color.fromJson(Map json) => _$ColorFromJson(json);
  Map toJson() => _$ColorToJson(this);
}
