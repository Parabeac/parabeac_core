import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'slice.g.dart';

@JsonSerializable(nullable: true)
class FigmaSlice extends FigmaNode implements FigmaNodeFactory {
  @override
  String type = 'SLICE';

  String layoutAlign;

  var constraints;

  @override
  @JsonKey(name: 'transitionNodeID')
  String prototypeNodeUUID;

  @override
  @JsonKey(name: 'absoluteBoundingBox')
  var boundaryRectangle;

  var size;

  FigmaSlice({
    String name,
    bool visible,
    String type,
    pluginData,
    sharedPluginData,
    this.layoutAlign,
    this.constraints,
    Frame this.boundaryRectangle,
    this.size,
  }) : super(
          name,
          visible,
          type,
          pluginData,
          sharedPluginData,
        ) {
    pbdfType = 'image';
  }

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaSlice.fromJson(json);
  factory FigmaSlice.fromJson(Map<String, dynamic> json) =>
      _$FigmaSliceFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaSliceToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    // TODO: implement interpretNode
    throw UnimplementedError();
  }

  @override
  bool isVisible;

  @override
  @JsonKey(ignore: true)
  var style;

  @override
  Map<String, dynamic> toPBDF() => toJson();

  @override
  String pbdfType = 'image';
}
