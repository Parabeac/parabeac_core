import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_border_options.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_fill.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_text_style.dart';

part 'figma_style.g.dart';

@JsonSerializable()
class FigmaStyle implements PBStyle {
  @override
  PBColor backgroundColor;
  @override
  List<PBFill> fills = [];
  @override
  List<PBBorder> borders;
  @override
  PBTextStyle textStyle;

  FigmaStyle({
    FigmaColor this.backgroundColor,
    List<FigmaBorder> this.borders,
    List<FigmaFill> this.fills,
    FigmaTextStyle this.textStyle,
    FigmaBorderOptions this.borderOptions,
  }) {
    if (this.fills == null) {
      this.fills = [];
    }
  }

  @override
  PBBorderOptions borderOptions;

  Map<String, dynamic> toJson() => _$FigmaStyleToJson(this);
  factory FigmaStyle.fromJson(Map<String, dynamic> json) =>
      _$FigmaStyleFromJson(json);

  @override
  @JsonKey(ignore: true)
  bool hasShadow;
}
