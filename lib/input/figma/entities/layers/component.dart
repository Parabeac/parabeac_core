import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_shared_master_node.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/objects/override_property.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'component.g.dart';

@JsonSerializable(nullable: true)
class Component extends FigmaFrame
    with SymbolNodeMixin
    implements AbstractFigmaNodeFactory, PBSharedMasterDesignNode {
  @override
  String type = 'COMPONENT';
  Component({
    name,
    isVisible,
    type,
    pluginData,
    sharedPluginData,
    Frame boundaryRectangle,
    style,
    fills,
    strokes,
    strokeWeight,
    strokeAlign,
    cornerRadius,
    constraints,
    layoutAlign,
    size,
    horizontalPadding,
    verticalPadding,
    itemSpacing,
    Flow flow,
    this.overrideProperties,
    List<FigmaNode> children,
    FigmaColor backgroundColor,
    this.symbolID,
    this.overriadableProperties,
  }) : super(
          name: name,
          isVisible: isVisible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          boundaryRectangle: boundaryRectangle,
          style: style,
          fills: fills,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          cornerRadius: cornerRadius,
          constraints: constraints,
          layoutAlign: layoutAlign,
          size: size,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          itemSpacing: itemSpacing,
          flow: flow,
          children: children,
          backgroundColor: backgroundColor,
        );

  final List<OverridableProperty> overrideProperties;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      Component.fromJson(json);
  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ComponentToJson(this);

  List<PBSharedParameterProp> _extractParameters() =>
      overrideProperties?.map((prop) {
        var properties = extractParameter(prop.overrideName);
        return PBSharedParameterProp(
            properties[0], null, prop.canOverride, name, properties[1]);
      })?.toList();

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    var sym_master = PBSharedMasterNode(
      this,
      UUID,
      name,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      overridableProperties: _extractParameters() ?? [],
      currentContext: currentContext,
    );
    return Future.value(sym_master);
  }

  @override
  List overriadableProperties;

  @override
  String symbolID;
}
