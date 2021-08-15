import 'dart:math';
import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/alignments/padding.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'alignments/injected_align.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/state_management/intermediate_auxillary_data.dart';

part 'pb_shared_instance.g.dart';

@JsonSerializable(ignoreUnannotated: true, explicitToJson: true)

/// As some nodes are shared throughout the project, shared instances are pointers to shared master nodes with overridable properties.
/// Superclass: PBSharedIntermediateNode
class PBSharedInstanceIntermediateNode extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @JsonKey(name: 'symbolID')
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
  @JsonKey(
      fromJson: PrototypeNode.prototypeNodeFromJson, name: 'prototypeNodeUUID')
  PrototypeNode prototypeNode;

  @override
  @JsonKey()
  String type = 'shared_instance';


  List<PBSymbolInstanceOverridableValue> overrideValues;
  // quick lookup based on UUID_type
  Map<String, PBSymbolInstanceOverridableValue> overrideValuesMap = {};

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  PBSharedInstanceIntermediateNode(
    String UUID,
    Rectangle frame, {
    this.originalRef,
    this.SYMBOL_ID,
    this.sharedParamValues,
    this.prototypeNode,
    this.overrideValues,
    String name,
  }) : super(
          UUID,
          frame,
          name,
        ) {
    generator = PBSymbolInstanceGenerator();
    
    childrenStrategy = NoChildStrategy();
    alignStrategy = NoAlignment();
    /// if [sharedParamValues] sets [overrideValues], then only pass one
    // overrideValues = sharedParamValues.map((v) {
    //   var symOvrValue =
    //       PBSymbolInstanceOverridableValue(v.UUID, v.value, v.type);
    //   overrideValuesMap[v.overrideName] = symOvrValue;
    //   return symOvrValue;
    // }).toList()
    //   ..removeWhere((v) => v == null || v.value == null);
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$PBSharedInstanceIntermediateNodeFromJson(json)
        // . .frame.topLeft = Point.topLeftFromJson(json)
        // . .frame.bottomRight = Point.bottomRightFromJson(json)
        ..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) =>
      PBSharedInstanceIntermediateNode.fromJson(json);
}

@JsonSerializable()
class PBSharedParameterValue {
  final String type;

  /// Initial value of [PBSharedParameterValue]
  @JsonKey(name: 'value')
  dynamic initialValue;

  /// Current value of [PBSharedParameterValue]
  ///
  /// This is useful when we need to do something to `initialValue`
  /// in order to correctly export the Override
  @JsonKey(ignore: true)
  String value;

  final String UUID;

  @JsonKey(name: 'name')
  String overrideName;

  PBSharedParameterValue(
    this.type,
    this.initialValue,
    this.UUID,
    this.overrideName,
  ) {
    value = initialValue;
  }

  @override
  factory PBSharedParameterValue.fromJson(Map<String, dynamic> json) =>
      _$PBSharedParameterValueFromJson(json);

  Map<String, dynamic> toJson() => _$PBSharedParameterValueToJson(this);
}
