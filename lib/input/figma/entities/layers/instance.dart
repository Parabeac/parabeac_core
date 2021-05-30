import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/pb_shared_instance_design_node.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/figma/entities/style/figma_color.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/input/sketch/entities/objects/override_value.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

part 'instance.g.dart';

@JsonSerializable(nullable: true)
class Instance extends FigmaFrame
    implements AbstractFigmaNodeFactory, PBSharedInstanceDesignNode {
  @override
  String type = 'INSTANCE';

  @override
  List parameters;

  @override
  String symbolID;

  @override
  List children;
  Instance(
      {name,
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
      this.componentId,
      List<FigmaNode> this.children,
      this.parameters,
      this.symbolID,
      FigmaColor backgroundColor,
      String prototypeNodeUUID,
      num transitionDuration,
      String transitionEasing})
      : super(
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
            transitionEasing: transitionEasing) {
    pbdfType = 'symbol_instance';
  }

  String componentId;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      Instance.fromJson(json);
  factory Instance.fromJson(Map<String, dynamic> json) =>
      _$InstanceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$InstanceToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    /// TODO: Check if `sharedParamValues` exits and pass to it, default to emptu for now
    var sym = PBSharedInstanceIntermediateNode(
      this,
      componentId,
      sharedParamValues: [],
      currentContext: currentContext,
    );
    return Future.value(sym);
  }

  @override
  String pbdfType = 'symbol_instance';

  @override
  Map AddMasterSymbolOverrideName(String overrideName, List children) {
    // TODO: implement AddMasterSymbolOverrideName
    throw UnimplementedError();
  }

  @override
  String MakeFriendlyName(String inName, Type type) {
    // TODO: implement AddMasterSymbolOverrideName
    throw UnimplementedError();
  }

  @override
  String GetUniqueVarName(String overrideName, String friendlyName) {
    // TODO: implement AddMasterSymbolOverrideName
    throw UnimplementedError();
  }

  @override
  String FindName(String uuid, List children, Type type) {
    // TODO: implement FindName
    throw UnimplementedError();
  }

  @override
  Map extractParameter(String overrideName) {
    // TODO: implement extractParameter
    throw UnimplementedError();
  }

  @override
  // TODO: implement overrideValues
  List<OverridableValue> get overrideValues => throw UnimplementedError();

  @override
  // TODO: implement typeToAbbreviation
  Map<Type, String> get typeToAbbreviation => throw UnimplementedError();
}
