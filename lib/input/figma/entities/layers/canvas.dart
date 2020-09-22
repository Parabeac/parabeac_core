import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../abstract_figma_node_factory.dart';

part 'canvas.g.dart';

@JsonSerializable(nullable: true)
class Canvas extends FigmaNode implements FigmaNodeFactory {
  @override
  String type = 'CANVAS';
  Canvas({
    this.name,
    this.type,
    this.children,
    this.backgroundColor,
    this.prototypeStartNodeID,
    this.prototypeDevice,
    this.exportSettings,
  }) : super(name, true, type, null, null);
  // Last two nulls are used for Figma plugins

  @override
  String name;

  List<FigmaNode> children;

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
  bool isVisible;

  @override
  String prototypeNodeUUID;

  @override
  var style;

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    assert(false, 'We don\'t product pages as Intermediate Nodes.');
    return null;
  }
}
