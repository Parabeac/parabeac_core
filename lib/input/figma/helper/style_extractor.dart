import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_font_descriptor.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_paragraph_style.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border_options.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_fill.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_style.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_text_style.dart';

/// Helper class used to get and sort the styling of FigmaNodes
class StyleExtractor {
  StyleExtractor();

  PBStyle getStyle(Map<String, dynamic> json) {
    if (json != null) {
      var bgColor;
      if (json['background'] != null) {
        bgColor = _getColor(json['background'][0]['color']);
      }

      var textStyle;
      if (json['style'] != null) {
        textStyle = _getTextStyle(json['style']);
      }

      List<FigmaBorder> borders = [];

      var strokes = json['strokes'];

      var borderOptions;

      var figmaBorder = FigmaBorder(
        isEnabled: strokes.isNotEmpty ? strokes[0]['visible'] : false,
        fillType: strokes.isNotEmpty ? strokes[0]['opacity'] : 1.0,
        color: strokes.isNotEmpty
            ? _getColor(strokes[0]['color'])
            : _getColor(null),
        thickness: json['strokeWeight'],
      );

      borderOptions = FigmaBorderOptions(
        json['strokeDashes'],
        strokes.isNotEmpty ? strokes[0]['visible'] : false,
        json['strokeCap'],
        json['strokeJoin'],
      );

      borders.add(figmaBorder);

      List<FigmaFill> fills = [];

      var fill = FigmaFill(
        _getColor(json['fills'].isNotEmpty ? json['fills'][0]['color'] : null),
      );

      fills.add(fill);

      return FigmaStyle(
        backgroundColor: bgColor,
        borders: borders,
        textStyle: textStyle,
        borderOptions: borderOptions,
        fills: fills,
      );
    }
  }

  FigmaTextStyle _getTextStyle(Map<String, dynamic> json) {
    var fontColor = json['fills'] != null
        ? _getColor(json['fills'][0]['color'])
        : _getColor(null);
    var fontDescriptor = _getFontDescriptor(json);
    var alignment = _getAlignment(json['textAlignHorizontal']);

    return FigmaTextStyle(
      fontColor: fontColor,
      fontDescriptor: fontDescriptor,
      weight: '${json['fontWeight']}',
      paragraphStyle: FigmaParagraphStyle(alignment: alignment.index),
    );
  }

  ALIGNMENT _getAlignment(String align) {
    switch (align) {
      case 'RIGHT':
        return ALIGNMENT.RIGHT;
        break;
      case 'JUSTIFIED':
        return ALIGNMENT.JUSTIFY;
        break;
      case 'CENTER':
        return ALIGNMENT.CENTER;
        break;
      case 'LEFT':
      default:
        return ALIGNMENT.LEFT;
    }
  }

  FigmaFontDescriptor _getFontDescriptor(Map<String, dynamic> json) {
    return FigmaFontDescriptor(
      json['fontFamily'],
      json['fontSize'],
      json,
    );
  }

  FigmaColor _getColor(Map<String, dynamic> json) {
    if (json != null) {
      return FigmaColor(
        alpha: json['a'],
        blue: json['b'],
        green: json['g'],
        red: json['r'],
      );
    } else {
      // Set color default to Black if fill is null
      return FigmaColor(
        alpha: 1.0,
        blue: 0.0,
        green: 0.0,
        red: 0.0,
      );
    }
  }
}
