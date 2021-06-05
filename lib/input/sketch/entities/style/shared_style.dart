import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/input/sketch/entities/style/font_descriptor.dart';
import 'package:parabeac_core/input/sketch/entities/style/style.dart';
import 'package:recase/recase.dart';

part 'shared_style.g.dart';

Map<String, String> SharedStyle_UUIDToName = {};

@JsonSerializable(nullable: true)
class SharedStyle with PBColorMixin {
  @JsonKey(name: '_class')
  final String classField;
  @override
  @JsonKey(name: 'do_objectID')
  String UUID;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'value')
  Style style;

  SharedStyle({
    this.classField,
    this.UUID,
    this.name,
    this.style,
  }) {
    name = name.camelCase;
    SharedStyle_UUIDToName[UUID] = name.replaceAll(
        RegExp(
          r'[^A-Za-z0-9_]',
        ),
        '');
  }

  String generate() {
    var buffer = StringBuffer();

    if (style != null) {
      buffer.write('SK_Style ${name} = SK_Style(\n');
      var bgc = style.backgroundColor;
      if (bgc == null) {
        buffer.write('null,\t\t// backgroundColor\n');
      } else {
        buffer.write(
            'Color.fromARGB(${(bgc.alpha * 255.0).toInt()}, ${(bgc.red * 255.0).toInt()}, ${(bgc.green * 255.0).toInt()}, ${(bgc.blue * 255.0).toInt()}),\n');
      }

      var fills = style.fills;
      if (fills == null) {
        buffer.write('null,\t\t// List<Fill>\n');
      } else {
        buffer.write('[\n');
        fills.forEach((fill) {
          buffer.write('SK_Fill(');
          if (fill.color == null) {
            buffer.write('null, ${fill.isEnabled})\t\t// fill.color\n');
          } else {
            buffer.write(
                'Color.fromARGB(${(fill.color.alpha * 255.0).toInt()}, ${(fill.color.red * 255.0).toInt()}, ${(fill.color.green * 255.0).toInt()}, ${(fill.color.blue * 255.0).toInt()}), ${fill.isEnabled})\n');
          }
        });
        buffer.write('],\n');
      }
      var borders = style.borders;
      if (borders == null) {
        buffer.write('null,\t\t// borders\n');
      } else {
        buffer.write('[\n');
        borders.forEach((border) {
          buffer.write('SK_Border(${border.isEnabled}, ${border.fillType}, ');
          if (border.color == null) {
            buffer.write('null,\t\t// border.color\n');
          } else {
            buffer.write(
                'Color.fromARGB(${(border.color.alpha * 255.0).toInt()}, ${(border.color.red * 255.0).toInt()}, ${(border.color.green * 255.0).toInt()}, ${(border.color.blue * 255.0).toInt()}), ${border.thickness}),\n');
          }
        });
        buffer.write('],\n');
      }
      var bo = style.borderOptions;
      if (bo == null) {
        buffer.write('null,,\t\t// borderOptions\n');
      } else {
        // TODO if dashPattern is used figure out how to export, using null for now
        buffer.write(
            'SK_BorderOptions(${bo.isEnabled}, null, ${bo.lineCapStyle}, ${bo.lineJoinStyle}),\n');
      }

      if (style.textStyle == null) {
        buffer.write('null,\t\t// textStyle\n');
      } else {
        var ts = style.textStyle;
        var fd = ts.fontDescriptor as FontDescriptor;
        buffer.write('TextStyle(\n');
        if (fd.fontName != null) {
          buffer.write('fontFamily: \'${fd.fontName}\',\n');
        }
        if (fd.fontSize != null) {
          buffer.write('fontSize: ${fd.fontSize.toString()},\n');
        }
        if (fd.fontWeight != null) {
          buffer.write('fontWeight: FontWeight.${fd.fontWeight.toString()},\n');
        }

        if (fd.fontStyle != null) {
          buffer.write('fontStyle: FontStyle.${fd.fontStyle},\n');
        }
        if (fd.letterSpacing != null) {
          buffer.write('letterSpacing: ${fd.letterSpacing},\n');
        }

        if (ts.fontColor != null) {
          var color = toHex(ts.fontColor);
          var defColor = findDefaultColor(color);
          if (defColor == null) {
            buffer.write('color: Color($color),');
          } else {
            buffer.write('color: $defColor,');
          }
        }

        buffer.write('),\n');
      }
      buffer.write('${style.hasShadow});\n');
    }

    return buffer.toString();
  }

  factory SharedStyle.fromJson(Map json) => _$SharedStyleFromJson(json);

  Map<String, dynamic> toJson() => _$SharedStyleToJson(this);
}
