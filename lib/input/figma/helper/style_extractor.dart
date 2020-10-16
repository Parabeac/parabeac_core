import 'package:parabeac_core/design_logic/pb_paragraph_style.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
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
      // Check if color exists in fills
      if (json['fills'] != null && json['fills'].isNotEmpty) {
        // Check if color should be visible
        if (!json['fills'][0].containsKey('visible') ||
            !json['fills'][0]['visible']) {
          bgColor = _getColor(null);
        } else {
          bgColor = _getColor(json['background'][0]['color']);
        }
      } else {
        bgColor = _getColor(null);
      }

      var textStyle;
      if (json['style'] != null) {
        textStyle = _getTextStyle(json);
      }

      List<FigmaBorder> borders = [];

      var strokes = json['strokes'];

      var borderOptions;

      var visible = strokes.isNotEmpty ? strokes[0]['visible'] : false;

      var figmaBorder = FigmaBorder(
        isEnabled: visible ?? false,
        fillType: strokes.isNotEmpty ? strokes[0]['opacity'] : 1.0,
        color: strokes.isNotEmpty
            ? _getColor(strokes[0]['color'])
            : _getColor(null),
        thickness: json['strokeWeight'],
      );

      var tempVisible = strokes.isNotEmpty ? strokes[0]['visible'] : false;

      borderOptions = FigmaBorderOptions(
        json['strokeDashes'],
        tempVisible ?? false,
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
    } else {
      return null;
    }
  }

  FigmaTextStyle _getTextStyle(Map<String, dynamic> json) {
    var fontColor = json['fills'] != null
        ? _getColor(json['fills'][0]['color'])
        : _getColor(null);
    var fontDescriptor = _getFontDescriptor(json['style']);
    var alignment = _getAlignment(json['style']['textAlignHorizontal']);

    return FigmaTextStyle(
      fontColor: fontColor,
      fontDescriptor: fontDescriptor,
      weight: '${json['style']['fontWeight']}',
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
      'w' + (json['fontWeight'].toString() ?? '100'),
      json.containsKey('italic') && json['italic'] ? 'italic' : 'normal',
      json['letterSpacing'],
    );
  }

  FigmaColor _getColor(Map<String, dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return FigmaColor(
        alpha: json['a'],
        blue: json['b'],
        green: json['g'],
        red: json['r'],
      );
    } else {
      return null;
    }
  }
}
