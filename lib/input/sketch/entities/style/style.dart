import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/sketch/entities/style/border.dart';
import 'package:parabeac_core/input/sketch/entities/style/border_options.dart';
import 'package:parabeac_core/input/sketch/entities/style/color_controls.dart';
import 'package:parabeac_core/input/sketch/entities/style/context_settings.dart';
import 'package:parabeac_core/input/sketch/entities/style/fill.dart';
import 'package:parabeac_core/input/sketch/entities/style/text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/blur.dart';
part 'style.g.dart';

@JsonSerializable(nullable: true)
class Style {
  @JsonKey(name: '_class')
  final String classField;
  final String do_objectID;
  final int endMarkerType, miterLimit, startMarkerType, windingRule;
  final Blur blur;
  final BorderOptions borderOptions;
  final List<Border> borders;
  final ColorControls colorControls;
  final ContextSettings contextSettings;
  final List<Fill> fills, innerShadows, shadows;
  @JsonKey(nullable: true)
  final TextStyle textStyle;

  Style({
    this.blur,
    this.borderOptions,
    this.borders,
    this.classField,
    this.colorControls,
    this.contextSettings,
    this.do_objectID,
    this.endMarkerType,
    this.fills,
    this.innerShadows,
    this.miterLimit,
    this.shadows,
    this.startMarkerType,
    this.windingRule,
    this.textStyle,
  });

  factory Style.fromJson(Map json) => _$StyleFromJson(json);
  Map toJson() => _$StyleToJson(this);
}
