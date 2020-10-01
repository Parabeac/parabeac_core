import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/symbol_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pb_shared_instance.g.dart';

/// As some nodes are shared throughout the project, shared instances are pointers to shared master nodes with overridable properties.
/// Superclass: PBSharedIntermediateNode
@JsonSerializable(nullable: true)
class PBSharedInstanceIntermediateNode extends PBIntermediateNode
    implements PBInheritedIntermediate {
  @override
  String UUID;

  final String SYMBOL_ID;

  ///The parameters that are going to be overriden in the [PBSharedMasterNode].
  @JsonKey(ignore: true)
  List<PBSharedParameterValue> sharedParamValues;

  ///The name of the function call that the [PBSharedInstanceIntermediateNode] is
  ///going to use; the name of the [PBSharedMasterNode].
  String functionCallName;

  bool foundMaster = false;

  @override
  SymbolInstance originalRef;

  @override
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  List overrideValues;

  PBSharedInstanceIntermediateNode(
    this.originalRef,
    this.SYMBOL_ID, {
    this.sharedParamValues,
    Point topLeftCorner,
    Point bottomRightCorner,
    this.currentContext,
  }) : super(
          Point(
              originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y),
          Point(
              (originalRef.boundaryRectangle.x +
                  originalRef.boundaryRectangle.width),
              (originalRef.boundaryRectangle.y +
                  originalRef.boundaryRectangle.height)),
          originalRef.do_objectID,
          currentContext: currentContext,
        ) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBSymbolInstanceGenerator();

    UUID = originalRef.do_objectID;

    overrideValues = sharedParamValues
        .map((v) =>
            PBSymbolInstanceOverridableValue(v.do_objectId, v.value, v.type))
        .toList()
          ..removeWhere((v) => v == null || v.value == null);
  }

  @override
  void addChild(PBIntermediateNode node) {}

  factory PBSharedInstanceIntermediateNode.fromJson(Map<String, Object> json) =>
      _$PBSharedInstanceIntermediateNodeFromJson(json);
  Map<String, Object> toJson() =>
      _$PBSharedInstanceIntermediateNodeToJson(this);
}

class PBSharedParameterValue {
  final Type _type;
  Type get type => _type;
  set type(Type type) => _type;

  final dynamic _value;
  dynamic get value => _value;

  final String _do_objectId;
  String get do_objectId => _do_objectId;

  PBSharedParameterValue(this._type, this._value, this._do_objectId);
}
