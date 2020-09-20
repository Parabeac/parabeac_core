import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';

import '../abstract_figma_node_factory.dart';

@JsonSerializable(nullable: true)
abstract class FigmaNode implements DesignNode {
  String id;

  @override
  String name;

  bool visible = true;

  @override
  String type;

  var pluginData;

  var sharedPluginData;

  FigmaNode(
    this.id,
    this.name,
    this.visible,
    this.type,
    this.pluginData,
    this.sharedPluginData,
  );

  @override
  Map<String, dynamic> toJson();
  factory FigmaNode.fromJson(Map<String, dynamic> json) =>
      AbstractFigmaNodeFactory.getFigmaNode(json);
  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext);
}
