import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_master.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'package:json_annotation/json_annotation.dart';

part 'pb_shared_master_node.g.dart';

@JsonSerializable(nullable: false)
class PBSharedMasterNode extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  String UUID;

  @override
  final SymbolMaster originalRef;

  ///The unique symbol identifier of the [PBSharedMasterNode]
  final String SYMBOL_ID;

  ///The name of the [PBSharedMasterNode]
  final String name;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  List<PBSymbolMasterParameter> parametersDefinition;

  String widgetType = 'PBSymbolMaster';

  ///The children that makes the UI of the [PBSharedMasterNode]. The children are going to be wrapped
  ///using a [TempGroupLayoutNode] as the root Node.
  set children(List<PBIntermediateNode> children) {
    child ??= TempGroupLayoutNode(originalRef, currentContext);
    if (child is PBLayoutIntermediateNode) {
      children.forEach((element) => child.addChild(element));
    } else {
      child = TempGroupLayoutNode(originalRef, currentContext)
        ..replaceChildren([child, ...children]);
    }
  }

  ///The properties that could be be overridable on a [PBSharedMasterNode]
  @JsonKey(ignore: true)
  List<PBSharedParameterProp> overridableProperties;

  PBSharedMasterNode(
    this.originalRef,
    this.SYMBOL_ID,
    this.name,
    Point topLeftCorner,
    Point bottomRightCorner, {
    this.overridableProperties,
    this.currentContext,
  }) : super(topLeftCorner, bottomRightCorner, currentContext) {
    UUID = originalRef.do_objectID;

    generator = PBMasterSymbolGenerator();

    this.currentContext.screenBottomRightCorner = Point(
        originalRef.boundaryRectangle.x + originalRef.boundaryRectangle.width,
        originalRef.boundaryRectangle.y + originalRef.boundaryRectangle.height);
    this.currentContext.screenTopLeftCorner =
        Point(originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y);

    parametersDefinition = overridableProperties
        .map((p) => PBSymbolMasterParameter(
            p.type,
            p.do_objectId,
            p.canOverride,
            p.propertyName,
            p.value?.toJson(),
            currentContext.screenTopLeftCorner.x,
            currentContext.screenTopLeftCorner.y,
            currentContext.screenBottomRightCorner.x,
            currentContext.screenBottomRightCorner.y,
            context: currentContext))
        .toList()
          ..removeWhere((p) => p == null || p.parameterDefinition == null);
  }

  @override
  void addChild(PBIntermediateNode node) =>
      child == null ? child = node : children = [node];

  @override
  void alignChild() {}

  factory PBSharedMasterNode.fromJson(Map<String, Object> json) =>
      _$PBSharedMasterNodeFromJson(json);
  Map<String, Object> toJson() => _$PBSharedMasterNodeToJson(this);
}

class PBSharedParameterProp {
  final Type _type;
  Type get type => _type;
  set type(Type type) => _type;

  PBIntermediateNode value;

  final bool _canOverride;
  bool get canOverride => _canOverride;

  final String _propertyName;
  String get propertyName => _propertyName;

  final String _do_objectId;
  String get do_objectId => _do_objectId;

  PBSharedParameterProp(this._type, this.value, this._canOverride,
      this._propertyName, this._do_objectId);
}
