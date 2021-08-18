import 'dart:math';
import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/symbols/pb_mastersym_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_constraints.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_layout_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/align_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/child_strategy.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/override_helper.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_intermediate_node_tree.dart';
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

  List<PBSymbolMasterParameter> parametersDefinition;
  Map<String, PBSymbolMasterParameter> parametersDefsMap = {};

  ///The properties that could be be overridable on a [PBSharedMasterNode]
  @JsonKey(ignore: true)
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
    this.prototypeNode,
  }) : super(
          UUID,
          frame,
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
    childrenStrategy = TempChildrenStrategy('child');
  }

  static PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$PBSharedMasterNodeFromJson(json)..originalRef = json;

  @override
  PBIntermediateNode createIntermediateNode(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var master = PBSharedMasterNode.fromJson(json)..mapRawChildren(json, tree);

    /// Map overridableProperties which need parent and tree
    (master as PBSharedMasterNode).overridableProperties =
        (json['overrideProperties'] as List)
                ?.map(
                  (prop) => prop == null
                      ? null
                      : PBSharedParameterProp.createSharedParameter(
                          prop as Map<String, dynamic>,
                          parent,
                          tree,
                        ),
                )
                ?.toList() ??
            [];

    // Add override properties to the [OverrideHelper]
    (master as PBSharedMasterNode)
        .overridableProperties
        .where((element) => element != null)
        .forEach((OverrideHelper.addProperty));

    return master;
  }
}

@JsonSerializable()
class PBSharedParameterProp {
  final String type;

  @JsonKey(ignore: true)
  PBIntermediateNode value;

  @JsonKey(name: 'name', fromJson: _propertyNameFromJson)
  final String propertyName;

  final String UUID;

  PBSharedParameterProp(
    this.type,
    this.propertyName,
    this.UUID,
  );

  static PBSharedParameterProp createSharedParameter(Map<String, dynamic> json,
      PBIntermediateNode parent, PBIntermediateTree tree) {
    var fromJson = PBSharedParameterProp.fromJson(json);

    // Populate `value` of Override Property since it is an [IntermediateNode]
    fromJson.value = json['value'] == null
        ? null
        : PBIntermediateNode.fromJson(json, parent, tree);

    return fromJson;
  }

  factory PBSharedParameterProp.fromJson(Map<String, dynamic> json) =>
      _$PBSharedParameterPropFromJson(json);

  Map<String, dynamic> toJson() => _$PBSharedParameterPropToJson(this);

  static String _propertyNameFromJson(String name) =>
      name.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').camelCase;
}
