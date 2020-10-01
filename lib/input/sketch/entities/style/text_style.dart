import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';
import 'package:parabeac_core/input/sketch/entities/style/paragraph_style.dart';
part 'text_style.g.dart';

@JsonSerializable(nullable: true)
class TextStyle {
  @JsonKey(name: 'encodedAttributes')
  Map<String, dynamic> rawEncodedAttributes;
  @JsonKey(ignore: true)
  Color color;
  @JsonKey(ignore: true)
  FontDescriptor fontDescriptor;
  @JsonKey(ignore: true)
  ParagraphStyle paragraphStyle;
  @JsonKey(ignore: true)
  num verticalAlignment;
  @JsonKey(ignore: true)
  String style;

  /// List of possible text weights, sorted by longest string first for .contains
  final List<String> STYLES = [
    'ExtraLightItalic',
    'ExtraBoldItalic',
    'SemiBoldItalic',
    'MediumItalic',
    'LightItalic',
    'BlackItalic',
    'ThinItalic',
    'ExtraLight',
    'BoldItalic',
    'ExtraBold',
    'SemiBold',
    'Regular',
    'Italic',
    'Medium',
    'Light',
    'Black',
    'Bold',
    'Thin',
//    'BoldOblique',
//    'LightOblique',
//    'Oblique',
  ];

  final Map<String, Map<String, String> > fontInfo = {
    'Thin': { 'fontWeight': 'w100', 'fontStyle': 'normal'},
    'ThinItalic': { 'fontWeight': 'w100', 'fontStyle': 'italic'},
    'ExtraLight': { 'fontWeight': 'w200', 'fontStyle': 'normal'},
    'ExtraLightItalic': { 'fontWeight': 'w200', 'fontStyle': 'italic'},
    'Light': { 'fontWeight': 'w300', 'fontStyle': 'normal'},
    'LightItalic': { 'fontWeight': 'w300', 'fontStyle': 'italic'},
    'Regular': { 'fontWeight': 'w400', 'fontStyle': 'normal'},
    'Italic': { 'fontWeight': 'w400', 'fontStyle': 'italic'},
    'Medium': { 'fontWeight': 'w500', 'fontStyle': 'normal'},
    'MediumItalic': { 'fontWeight': 'w500', 'fontStyle': 'italic'},
    'SemiBold': { 'fontWeight': 'w600', 'fontStyle': 'normal'},
    'SemiBoldItalic': { 'fontWeight': 'w600', 'fontStyle': 'italic'},
    'Bold': { 'fontWeight': 'w700', 'fontStyle': 'normal'},
    'BoldItalic': { 'fontWeight': 'w700', 'fontStyle': 'italic'},
    'ExtraBold': { 'fontWeight': 'w800', 'fontStyle': 'normal'},
    'ExtraBoldItalic': { 'fontWeight': 'w800', 'fontStyle': 'italic'},
    'Black': { 'fontWeight': 'w900', 'fontStyle': 'normal'},
    'BlackItalic': { 'fontWeight': 'w900', 'fontStyle': 'italic'},
  };

  TextStyle({this.rawEncodedAttributes}) {
    color = Color.fromJson(
        rawEncodedAttributes['MSAttributedStringColorAttribute']);
    fontDescriptor = FontDescriptor.fromJson(
        rawEncodedAttributes['MSAttributedStringFontAttribute']);
    paragraphStyle =
        ParagraphStyle.fromJson(rawEncodedAttributes['paragraphStyle'] ?? {});
    verticalAlignment = rawEncodedAttributes['textStyleVerticalAlignment'];

    //Find if text has special weight
    for (var s in STYLES) {
      if (fontDescriptor.fontName.contains(s)) {
        // this is really a mapping of style to weight
        fontDescriptor.fontWeight = fontInfo[s]['fontWeight'];
        // this is only normal, italic style
        fontDescriptor.fontStyle = fontInfo[s]['fontStyle'];
        // this is really fontFamily with removal of -XXX font type name suffix
        fontDescriptor.fontName =
            fontDescriptor.fontName.replaceFirst('-$s', '');
        fontDescriptor.letterSpacing = rawEncodedAttributes['kerning'] ?? 0.0;
        break;
      }
    }
  }

  factory TextStyle.fromJson(Map<String, dynamic> json) =>
      _$TextStyleFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleToJson(this);
}
