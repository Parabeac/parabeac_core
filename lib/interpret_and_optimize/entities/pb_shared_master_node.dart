import 'dart:math';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
import 'package:quick_log/quick_log.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';
import 'package:recase/recase.dart';

part 'pb_shared_master_node.g.dart';

@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)
class PBSharedMasterNode extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  ///The unique symbol identifier of the [PBSharedMasterNode]
  @JsonKey(name: 'symbolID')
  final String SYMBOL_ID;

  @override
  @JsonKey()
  String type = 'shared_master';

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson, name: 'boundaryRectangle')
  Map size;

  List<PBSymbolMasterParameter> parametersDefinition;
  Map<String, PBSymbolMasterParameter> parametersDefsMap = {};

  ///The children that makes the UI of the [PBSharedMasterNode]. The children are going to be wrapped
  ///using a [TempGroupLayoutNode] as the root Node.
  set children(List<PBIntermediateNode> children) {
    child ??= TempGroupLayoutNode(null, null,
        currentContext: currentContext, name: name);
    if (child is PBLayoutIntermediateNode) {
      children.forEach((element) => child.addChild(element));
    } else {
      child = TempGroupLayoutNode(null, null,
          currentContext: currentContext, name: name)
        ..replaceChildren([child, ...children]);
    }
  }

  ///The properties that could be be overridable on a [PBSharedMasterNode]
  @JsonKey(name: 'overrideProperties')
  List<PBSharedParameterProp> overridableProperties;
  String friendlyName;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  PBSharedMasterNode(
    String UUID,
    Rectangle frame, {
    this.originalRef,
    this.SYMBOL_ID,
    String name,
    this.overridableProperties,
    PBContext currentContext,
    this.prototypeNode,
    this.size,
  }) : super(
          UUID,
          frame,
          currentContext,
          name,
        ) {
    overridableProperties ??= [];
    try {
      if (name != null) {
        //Remove any special characters and leading numbers from the method name
        friendlyName = name
            .replaceAll(RegExp(r'[^\w]+'), '')
            .replaceAll(RegExp(r'/'), '')
            .replaceFirst(RegExp(r'^[\d]+'), '');
        //Make first letter of method name capitalized
        friendlyName =
            friendlyName[0].toUpperCase() + friendlyName.substring(1);
      }
    } catch (e, stackTrace) {
      MainInfo().sentry.captureException(
            exception: e,
            stackTrace: stackTrace,
          );
      logger.error(e.toString());
    }

    generator = PBMasterSymbolGenerator();

    overridableProperties.forEach(OverrideHelper.addProperty);

    // this.currentContext.screenBottomRightCorner = Point(
    //     originalRef.boundaryRectangle.x + originalRef.boundaryRectangle.width,
    //     originalRef.boundaryRectangle.y + originalRef.boundaryRectangle.height);
    // this.currentContext.screenTopLeftCorner =
    //     Point(originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y);

    // parametersDefinition = overridableProperties.map((p) {
    //   var PBSymMasterP = PBSymbolMasterParameter(
    //       // p._friendlyName,
    //       p.type,
    //       p.value,
    //       p.UUID,
    //       p.canOverride,
    //       p.propertyName,
    //       /* Removed Parameter Definition as it was accepting JSON?*/
    //       null, // TODO: @Eddie
    //       currentContext.screenTopLeftCorner.x,
    //       currentContext.screenTopLeftCorner.y,
    //       currentContext.screenBottomRightCorner.x,
    //       currentContext.screenBottomRightCorner.y,
    //       context: currentContext);
    //   parametersDefsMap[p.propertyName] = PBSymMasterP;
    //   return PBSymMasterP;
    // }).toList()
    //   ..removeWhere((p) => p == null || p.parameterDefinition == null);
  }

  @override
  void addChild(node) => child == null ? child = node : children = [node];

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$PBSharedMasterNodeFromJson(json)
        // ..topLeftCorner = Point.topLeftFromJson(json)
        // ..bottomRightCorner = Point.bottomRightFromJson(json)
        ..originalRef = json
        ..mapRawChildren(json);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      PBSharedMasterNode.fromJson(json);
}

@JsonSerializable()
class PBSharedParameterProp {
  final String type;

  PBIntermediateNode value;

  @JsonKey(name: 'name', fromJson: _propertyNameFromJson)
  final String propertyName;

  final String UUID;

  PBSharedParameterProp(
    this.type,
    this.value,
    this.propertyName,
    this.UUID,
  );

  factory PBSharedParameterProp.fromJson(Map<String, dynamic> json) =>
      _$PBSharedParameterPropFromJson(json);

  Map<String, dynamic> toJson() => _$PBSharedParameterPropToJson(this);

  static String _propertyNameFromJson(String name) =>
      name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').camelCase;
}
