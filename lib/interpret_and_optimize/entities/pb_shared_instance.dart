import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_instancesym_gen.dart';
import 'package:parabeac_core/generation/generators/util/pb_input_formatter.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_instance_overridable_value.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
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
  List<PBInstanceOverride> sharedParamValues;

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

  @JsonKey(ignore: false)
  String sharedNodeSetID;

  PBSharedInstanceIntermediateNode(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    this.SYMBOL_ID,
    this.sharedParamValues,
    this.prototypeNode,
    this.overrideValues,
    String name,
    this.sharedNodeSetID,
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
        ..originalRef = json
        ..name;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var instance = PBSharedInstanceIntermediateNode.fromJson(json);
    instance.name = PBInputFormatter.formatPageName(instance.name);
    _formatOverrideVals(
        (instance as PBSharedInstanceIntermediateNode).sharedParamValues, tree);

    return instance;
  }

  void _formatOverrideVals(
      List<PBInstanceOverride> vals, PBIntermediateTree tree) {
    vals.forEach((overrideValue) {
      if (overrideValue.ovrType == 'stringValue') {
        overrideValue.valueName = MainInfo.cleanString(overrideValue.valueName);
      } else if (overrideValue.ovrType == 'image') {
        overrideValue.valueName = 'assets/' + overrideValue.valueName;
      }
      overrideValue.initialValue;
      overrideValue.value =
          PBIntermediateNode.fromJson(overrideValue.initialValue, this, tree);
    });
  }
}

@JsonSerializable()
class PBInstanceOverride {
  final String ovrType;

  /// Initial value of [PBInstanceOverride]
  @JsonKey(name: 'value')
  Map initialValue;

  /// Current value of [PBInstanceOverride]
  ///
  /// This is useful when we need to do something to `initialValue`
  /// in order to correctly export the Override
  @JsonKey(ignore: true)
  PBIntermediateNode value;

  final String UUID;

  @JsonKey(name: 'name')
  String overrideName;

  String valueName;

  PBInstanceOverride(
    this.ovrType,
    this.initialValue,
    this.UUID,
    this.overrideName,
    this.valueName,
  );

  @override
  factory PBInstanceOverride.fromJson(Map<String, dynamic> json) =>
      _$PBInstanceOverrideFromJson(json);

  Map<String, dynamic> toJson() => _$PBInstanceOverrideToJson(this);
}
