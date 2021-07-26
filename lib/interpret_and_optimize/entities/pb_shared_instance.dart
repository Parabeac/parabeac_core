import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'alignments/injected_align.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pb_shared_instance.g.dart';

@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)

/// As some nodes are shared throughout the project, shared instances are pointers to shared master nodes with overridable properties.
/// Superclass: PBSharedIntermediateNode
class PBSharedInstanceIntermediateNode extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @JsonKey()
  final String SYMBOL_ID;

  ///The parameters that are going to be overriden in the [PBSharedMasterNode].

  @JsonKey(name: 'overrideValues')
  List<PBSharedParameterValue> sharedParamValues;

  ///The name of the function call that the [PBSharedInstanceIntermediateNode] is
  ///going to use; the name of the [PBSharedMasterNode].
  String functionCallName;

  bool foundMaster = false;
  bool isMasterState = false;

  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'shared_instance';

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  List<PBSymbolInstanceOverridableValue> overrideValues;
  // quick lookup based on UUID_type
  Map<String, PBSymbolInstanceOverridableValue> overrideValuesMap = {};

  @override
  @JsonKey(fromJson: PBInheritedIntermediate.originalRefFromJson)
  final Map<String, dynamic> originalRef;

  PBSharedInstanceIntermediateNode({
    this.originalRef,
    this.SYMBOL_ID,
    this.sharedParamValues,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.currentContext,
    this.UUID,
    this.prototypeNode,
    this.size,
    this.overrideValues,
    String name,
  }) : super(topLeftCorner, bottomRightCorner, currentContext, name,
            UUID: UUID) {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    generator = PBSymbolInstanceGenerator();

    /// if [sharedParamValues] sets [overrideValues], then only pass one
    // overrideValues = sharedParamValues.map((v) {
    //   var symOvrValue =
    //       PBSymbolInstanceOverridableValue(v.UUID, v.value, v.type);
    //   overrideValuesMap[v.overrideName] = symOvrValue;
    //   return symOvrValue;
    // }).toList()
    //   ..removeWhere((v) => v == null || v.value == null);
  }

  @override
  void addChild(PBIntermediateNode node) {}

  @override
  void alignChild() {
    if (child != null) {
      var align =
          InjectedAlign(topLeftCorner, bottomRightCorner, currentContext, '');
      align.addChild(child);
      align.alignChild();
      child = align;
    }
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$PBSharedInstanceIntermediateNodeFromJson(json);

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json) =>
      PBSharedInstanceIntermediateNode.fromJson(json);
}

@JsonSerializable()
class PBSharedParameterValue {
  final String type;

  final dynamic value;

  final String UUID;

  final String overrideName;

  PBSharedParameterValue(
    this.type,
    this.value,
    this.UUID,
    this.overrideName,
  );

  @override
  factory PBSharedParameterValue.fromJson(Map<String, dynamic> json) =>
      _$PBSharedParameterValueFromJson(json);

  Map<String, dynamic> toJson() => _$PBSharedParameterValueToJson(this);
}
