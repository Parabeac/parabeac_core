import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import '../abstract_figma_node_factory.dart';

@JsonSerializable(nullable: true)
abstract class FigmaNode implements DesignNode {
  @JsonKey(name: 'id')
  @override
  String UUID;

  @override
  String name;

  @override
  String type;

  var pluginData;

  var sharedPluginData;

  @override
  @JsonKey(name: 'visible', defaultValue: true)
  bool isVisible;

  FigmaNode(
    this.name,
    this.isVisible,
    this.type,
    this.pluginData,
    this.sharedPluginData, {
    this.UUID,
  });
  @override
  Map<String, dynamic> toJson();
  factory FigmaNode.fromJson(Map<String, dynamic> json) =>
      AbstractFigmaNodeFactory.getFigmaNode(json);
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext);
}
