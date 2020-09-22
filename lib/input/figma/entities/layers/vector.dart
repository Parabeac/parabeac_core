import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vector.g.dart';

@JsonSerializable(nullable: true)
class FigmaVector extends FigmaNode implements FigmaNodeFactory {
  @override
  bool isVisible;

  @override
  var style;

  String layoutAlign;

  var constraints;

  @override
  @JsonKey(name: 'transitionNodeID')
  String prototypeNodeUUID;

  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  var size;

  var fills;

  var strokes;

  double strokeWeight;

  String strokeAlign;

  var styles;
  @override
  String type = 'VECTOR';

  FigmaVector({
    String name,
    bool visible,
    String type,
    pluginData,
    sharedPluginData,
    this.style,
    this.layoutAlign,
    this.constraints,
    Frame this.boundaryRectangle,
    this.size,
    this.fills,
    this.strokes,
    this.strokeWeight,
    this.strokeAlign,
    this.styles,
  }) : super(
          name,
          visible,
          type,
          pluginData,
          sharedPluginData,
        );

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaVector.fromJson(json);
  factory FigmaVector.fromJson(Map<String, dynamic> json) =>
      _$FigmaVectorFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaVectorToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    // TODO: implement interpretNode
    throw UnimplementedError();
  }
}
