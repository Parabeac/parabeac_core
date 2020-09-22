import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';

import 'figma_node.dart';

part 'rectangle.g.dart';

@JsonSerializable(nullable: true)
class FigmaRectangle extends FigmaVector implements AbstractFigmaNodeFactory {
  @override
  String type = 'RECTANGLE';
  FigmaRectangle({
    String name,
    bool visible,
    String type,
    pluginData,
    sharedPluginData,
    style,
    layoutAlign,
    constraints,
    Frame boundaryRectangle,
    size,
    fills,
    strokes,
    strokeWeight,
    strokeAlign,
    styles,
    this.cornerRadius,
    this.rectangleCornerRadii,
  }) : super(
          name: name,
          visible: visible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          style: style,
          layoutAlign: layoutAlign,
          constraints: constraints,
          boundaryRectangle: boundaryRectangle,
          size: size,
          fills: fills,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          styles: styles,
        );

  double cornerRadius;

  List<double> rectangleCornerRadii;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaRectangle.fromJson(json);
  factory FigmaRectangle.fromJson(Map<String, dynamic> json) =>
      _$FigmaRectangleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaRectangleToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    // TODO: implement interpretNode
    throw UnimplementedError();
  }
}
