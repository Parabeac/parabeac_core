import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/design_logic/pb_shared_master_node.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_constraints.dart';
import 'package:parabeac_core/input/helper/figma_constraint_to_pbdl.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/helper/symbol_node_mixin.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_master_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'dart:math';

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
    FigmaConstraints constraints,
    layoutAlign,
    size,
    horizontalPadding,
    verticalPadding,
    itemSpacing,
    this.overrideProperties,
    List<FigmaNode> children,
    FigmaColor backgroundColor,
    this.symbolID,
    this.overriadableProperties,
    String prototypeNodeUUID,
    num transitionDuration,
    String transitionEasing,
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
          children: children,
          backgroundColor: backgroundColor,
          prototypeNodeUUID: prototypeNodeUUID,
          transitionDuration: transitionDuration,
          transitionEasing: transitionEasing,
        ) {
    pbdfType = 'symbol_master';
  }

  // make sure only store unique UUID overrides with Map
  @override
  var overrideProperties;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      Component.fromJson(json);
  factory Component.fromJson(Map<String, dynamic> json) =>
      _$ComponentFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ComponentToJson(this);

  List<PBSharedParameterProp> _extractParameters() {
    var ovrNames = <String>{};
    var sharedParameters = <PBSharedParameterProp>[];
    overrideProperties ??= [];
    for (var prop in overrideProperties) {
      if (!ovrNames.contains(prop.overrideName)) {
        var properties = extractParameter(prop.overrideName);
        sharedParameters.add(PBSharedParameterProp(
            name,
            properties['type'],
            null,
            prop.canOverride,
            prop.overrideName,
            properties['uuid'],
            properties['default_value']));
        ovrNames.add(prop.overrideName);
      }
    }
    return sharedParameters;
  }

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

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'symbol_master';

  @override
  DesignNode createDesignNode(Map<String, dynamic> json) {
    // TODO: implement createDesignNode
    throw UnimplementedError();
  }

  @override
  DesignNode fromPBDF(Map<String, dynamic> json) {
    // TODO: implement fromPBDF
    throw UnimplementedError();
  }

  @override
  var isFlowHome;
}
