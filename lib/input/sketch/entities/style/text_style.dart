import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_font_descriptor.dart';
import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';
import 'package:parabeac_core/input/sketch/entities/style/paragraph_style.dart';
part 'text_style.g.dart';

@JsonSerializable(nullable: true)
class TextStyle implements PBTextStyle {
  @JsonKey(name: 'encodedAttributes')
  Map<String, dynamic> rawEncodedAttributes;
  @override
  @JsonKey(ignore: true)
  PBFontDescriptor fontDescriptor;
  @JsonKey(ignore: true)
  PBParagraphStyle paragraphStyle;
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

  final Map<String, Map<String, String>> fontInfo = {
    'Thin': {'fontWeight': 'w100', 'fontStyle': 'normal'},
    'ThinItalic': {'fontWeight': 'w100', 'fontStyle': 'italic'},
    'ExtraLight': {'fontWeight': 'w200', 'fontStyle': 'normal'},
    'ExtraLightItalic': {'fontWeight': 'w200', 'fontStyle': 'italic'},
    'Light': {'fontWeight': 'w300', 'fontStyle': 'normal'},
    'LightItalic': {'fontWeight': 'w300', 'fontStyle': 'italic'},
    'Regular': {'fontWeight': 'w400', 'fontStyle': 'normal'},
    'Italic': {'fontWeight': 'w400', 'fontStyle': 'italic'},
    'Medium': {'fontWeight': 'w500', 'fontStyle': 'normal'},
    'MediumItalic': {'fontWeight': 'w500', 'fontStyle': 'italic'},
    'SemiBold': {'fontWeight': 'w600', 'fontStyle': 'normal'},
    'SemiBoldItalic': {'fontWeight': 'w600', 'fontStyle': 'italic'},
    'Bold': {'fontWeight': 'w700', 'fontStyle': 'normal'},
    'BoldItalic': {'fontWeight': 'w700', 'fontStyle': 'italic'},
    'ExtraBold': {'fontWeight': 'w800', 'fontStyle': 'normal'},
    'ExtraBoldItalic': {'fontWeight': 'w800', 'fontStyle': 'italic'},
    'Black': {'fontWeight': 'w900', 'fontStyle': 'normal'},
    'BlackItalic': {'fontWeight': 'w900', 'fontStyle': 'italic'},
  };

  TextStyle({this.rawEncodedAttributes}) {
    fontColor = Color.fromJson(
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
        (fontDescriptor as FontDescriptor).fontWeight =
            fontInfo[s]['fontWeight'];
        // this is only normal, italic style
        (fontDescriptor as FontDescriptor).fontStyle = fontInfo[s]['fontStyle'];
        // this is really fontFamily with removal of -XXX font type name suffix
        (fontDescriptor as FontDescriptor).fontName =
            fontDescriptor.fontName.replaceFirst('-$s', '');
        (fontDescriptor as FontDescriptor).letterSpacing =
            rawEncodedAttributes['kerning'] ?? 0.0;
        break;
      }
    }
  }

  factory TextStyle.fromJson(Map<String, dynamic> json) =>
      _$TextStyleFromJson(json);
  Map<String, dynamic> toJson() => _$TextStyleToJson(this);

  @override
  @JsonKey(ignore: true)
  PBColor fontColor;

  @override
  String fontFamily;

  @override
  String fontSize;

  @override
  String fontWeight;

  @override
  String weight;
}
