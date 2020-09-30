import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_border_options.dart';
import 'package:parabeac_core/design_logic/pb_fill.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_style.dart';
import 'package:parabeac_core/design_logic/pb_text_style.dart';
import 'package:parabeac_core/input/sketch/entities/style/border.dart';
import 'package:parabeac_core/input/sketch/entities/style/border_options.dart';
import 'package:parabeac_core/input/sketch/entities/style/color_controls.dart';
import 'package:parabeac_core/input/sketch/entities/style/context_settings.dart';
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
  final BorderOptions borderOptions;
  final List<Border> borders;
  final ColorControls colorControls;
  final ContextSettings contextSettings;
  @JsonKey(ignore: true)
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
    this.fills,
    this.innerShadows,
    this.miterLimit,
    this.shadows,
    this.startMarkerType,
    this.windingRule,
    TextStyle this.textStyle,
  });

  factory Style.fromJson(Map json) => _$StyleFromJson(json);
  Map<String, dynamic> toJson() => _$StyleToJson(this);

  @override
  @JsonKey(ignore: true)
  PBColor backgroundColor;

  @override
  var boundaryRectangle;

  @override
  bool isVisible;

  @override
  String name;

  @override
  String prototypeNodeUUID;

  @override
  String type;

  @override
  void set borders(List _borders) {
    // TODO: implement borders
  }

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    // TODO: implement interpretNode
    throw UnimplementedError();
  }

  @override
  void set borderOptions(PBBorderOptions _borderOptions) {
    // TODO: implement borderOptions
  }
}
