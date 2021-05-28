import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/border.dart';
import 'package:parabeac_core/input/sketch/entities/style/border_options.dart';
import 'package:parabeac_core/input/sketch/entities/style/color_controls.dart';
import 'package:parabeac_core/input/sketch/entities/style/context_settings.dart';
import 'package:parabeac_core/input/sketch/entities/style/fill.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/blur.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
part 'style.g.dart';

@JsonSerializable(nullable: true)
class Style implements PBStyle {
  @JsonKey(name: '_class')
  final String classField;
  @override
  @JsonKey(name: 'do_objectID')
  String UUID;
  final int endMarkerType, miterLimit, startMarkerType, windingRule;
  final Blur blur;
  @override
  final BorderOptions borderOptions;
  @override
  final List<Border> borders;
  final ColorControls colorControls;
  final ContextSettings contextSettings;
  @override
  List<PBFill> fills, innerShadows, shadows;
  @JsonKey(nullable: true)
  PBTextStyle textStyle;

  Style({
    this.blur,
    this.borderOptions,
    this.borders,
    this.classField,
    this.colorControls,
    this.contextSettings,
    this.UUID,
    this.endMarkerType,
    List<Fill> this.fills,
    List<Fill> this.innerShadows,
    this.miterLimit,
    List<Fill> this.shadows,
    this.startMarkerType,
    this.windingRule,
    TextStyle this.textStyle,
    this.backgroundColor,
    this.hasShadow,
  }) {
    if (shadows != null) {
      //this.shadows = null;
      this.innerShadows = null;
      hasShadow = true;
    }
    // TODO: add rectangle fill types, for now just copy the fill[0] to the background color
    if (fills != null && fills.isNotEmpty) {
      if (fills[0].isEnabled && (fills[0].fillType == 0)) {
        backgroundColor = fills[0].color;
      }
    }
  }

  factory Style.fromJson(Map json) => _$StyleFromJson(json);
  Map<String, dynamic> toJson() => _$StyleToJson(this);

  @override
  @JsonKey(ignore: true)
  PBColor backgroundColor;

  @override
  set borderOptions(PBBorderOptions _borderOptions) {}

  @override
  set borders(List<PBBorder> _borders) {}

  @override
  @JsonKey(ignore: true)
  bool hasShadow;
}
