import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/pb_symbol_master_params.dart';
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

  List<PBSymbolMasterParameter> parametersDefinition;
  Map<String, PBSymbolMasterParameter> parametersDefsMap = {};

  ///The properties that could be be overridable on a [PBSharedMasterNode]
  @JsonKey(ignore: true)
  List<PBMasterOverride> overridableProperties;
  String _friendlyName;

  //Remove any special characters and leading numbers from the method name
  //Make first letter of method name capitalized using PascalCase
  String get friendlyName => name
      .replaceAll(RegExp(r'[^\w]+'), '')
      .replaceAll(RegExp(r'/'), '')
      .replaceFirst(RegExp(r'^[\d]+'), '')
      .pascalCase;

  @override
  @JsonKey(ignore: true)
  Map<String, dynamic> originalRef;

  @JsonKey(ignore: false)
  String componentSetName;

  @JsonKey(ignore: false)
  String sharedNodeSetID;

  PBSharedMasterNode(
    String UUID,
    Rectangle3D frame, {
    this.originalRef,
    this.SYMBOL_ID,
    String name,
    this.overridableProperties,
    this.prototypeNode,
    PBIntermediateConstraints constraints,
    this.componentSetName,
    this.sharedNodeSetID,
  }) : super(UUID, frame, name, constraints: constraints) {
    overridableProperties ??= [];

    generator = PBMasterSymbolGenerator();
    childrenStrategy = TempChildrenStrategy('child');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) {
    return _$PBSharedMasterNodeFromJson(json)..originalRef = json;
  }

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    PBSharedMasterNode master = PBSharedMasterNode.fromJson(json)
      ..mapRawChildren(json, tree);

    /// Map overridableProperties which need parent and tree
    master.overridableProperties = (json['overrideProperties'] as List)
            ?.map(
              (prop) => prop == null
                  ? null
                  : PBMasterOverride.createSharedParameter(
                      prop as Map<String, dynamic>,
                      master,
                      tree,
                    ),
            )
            ?.toList() ??
        [];

    master.overridableProperties.removeWhere((element) => element == null);

    // Add override properties to the [OverrideHelper]
    master.overridableProperties.forEach((OverrideHelper.addProperty));

    return master;
  }
}

@JsonSerializable()
class PBMasterOverride {
  final String type;

  @JsonKey(ignore: true)
  PBIntermediateNode value;

  @JsonKey(name: 'name', fromJson: _propertyNameFromJson)
  final String propertyName;

  final String UUID;

  PBMasterOverride(
    this.type,
    this.propertyName,
    this.UUID,
  );

  static PBMasterOverride createSharedParameter(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    // Override properties with <custom> as name will create issues since their
    // PBIntermediateNode counterparts will have already been interpreted
    if (json['name'].contains('<custom>')) {
      return null;
    }
    var fromJson = PBMasterOverride.fromJson(json);

    // Populate `value` of Override Property since it is an [IntermediateNode]
    fromJson.value = tree.firstWhere((element) => element.UUID == json['UUID'],
        orElse: () => null);

    return fromJson;
  }

  factory PBMasterOverride.fromJson(Map<String, dynamic> json) =>
      _$PBMasterOverrideFromJson(json);

  Map<String, dynamic> toJson() => _$PBMasterOverrideToJson(this);

  static String _propertyNameFromJson(String name) =>
      name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').camelCase;

  /// Generated the given [PBMasterOverride]
  String generateOverride() {
    return 'widget.$propertyName ?? ';
  }
}
