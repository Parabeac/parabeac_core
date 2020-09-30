import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';
import 'package:parabeac_core/input/sketch/entities/style/paragraph_style.dart';
part 'text_style.g.dart';

@JsonSerializable(nullable: true)
class TextStyle implements PBTextStyle {
  @JsonKey(name: 'encodedAttributes')
  Map<String, dynamic> rawEncodedAttributes;
  @JsonKey(ignore: true)
  FontDescriptor fontDescriptor;
  @JsonKey(ignore: true)
  ParagraphStyle paragraphStyle;
  @JsonKey(ignore: true)
  num verticalAlignment;
  @JsonKey(ignore: true)
  String weight;
  @JsonKey(ignore: true)

  /// List of possible text weights
  final List<String> WEIGHTS = [
    'BoldOblique',
    'LightOblique',
    'Bold',
    'Light',
    'Oblique'
  ];

  TextStyle({this.rawEncodedAttributes}) {
    fontColor = Color.fromJson(
        rawEncodedAttributes['MSAttributedStringColorAttribute']);
    fontDescriptor = FontDescriptor.fromJson(
        rawEncodedAttributes['MSAttributedStringFontAttribute']);
    paragraphStyle =
        ParagraphStyle.fromJson(rawEncodedAttributes['paragraphStyle'] ?? {});
    verticalAlignment = rawEncodedAttributes['textStyleVerticalAlignment'];

    //Find if text has special weight
    for (var w in WEIGHTS) {
      if (fontDescriptor.fontName.contains(w)) {
        weight = w;

        fontDescriptor.fontName =
            fontDescriptor.fontName.replaceFirst('-$w', '');
        break;
      }
    }
  }

  factory TextStyle.fromJson(Map<String, dynamic> json) =>
      _$TextStyleFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleToJson(this);

  @override
  ALIGNMENT alignment;

  @override
  @JsonKey(ignore: true)
  PBColor fontColor;

  @override
  String fontFamily;

  @override
  String fontSize;

  @override
  String fontWeight;
}
