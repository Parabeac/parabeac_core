import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/design_logic/group_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../abstract_figma_node_factory.dart';

part 'canvas.g.dart';

@JsonSerializable(nullable: true)
class Canvas extends FigmaNode implements FigmaNodeFactory, GroupNode {
  @override
  String type = 'CANVAS';
  Canvas({
    this.name,
    this.type,
    List<FigmaNode> this.children,
    this.backgroundColor,
    this.prototypeStartNodeID,
    this.prototypeDevice,
    this.exportSettings,
  }) : super(name, true, type, null, null);
  // Last two nulls are used for Figma plugins

  @override
  String name;

  @override
  List children;

  dynamic backgroundColor;

  dynamic prototypeStartNodeID;

  dynamic prototypeDevice;

  dynamic exportSettings;

  Canvas createSketchNode(Map<String, dynamic> json) => Canvas.fromJson(json);
  factory Canvas.fromJson(Map<String, dynamic> json) => _$CanvasFromJson(json);

  Map<String, dynamic> toJson() => _$CanvasToJson(this);

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) => Canvas.fromJson(json);

  @override
  var boundaryRectangle;

  @override
  String prototypeNodeUUID;

  @override
  @JsonKey(ignore: true)
  var style;

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    assert(false, 'We don\'t product pages as Intermediate Nodes.');
    return null;
  }
}
