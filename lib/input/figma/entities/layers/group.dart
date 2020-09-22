import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/figma_node.dart';
import 'package:parabeac_core/input/figma/entities/layers/frame.dart';
import 'package:parabeac_core/input/sketch/entities/layers/flow.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

part 'group.g.dart';

@JsonSerializable(nullable: true)
class Group extends FigmaFrame implements AbstractFigmaNodeFactory {
  @override
  String type = 'GROUP';
  Group({
    name,
    visible,
    type,
    pluginData,
    sharedPluginData,
    Frame boundaryRectangle,
    style,
    fills,
    strokes,
    strokeWeight,
    strokeAlign,
    cornerRadius,
    constraints,
    layoutAlign,
    size,
    horizontalPadding,
    verticalPadding,
    itemSpacing,
    Flow flow,
  }) : super(
          name: name,
          visible: visible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          boundaryRectangle: boundaryRectangle,
          style: style,
          fills: fills,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          cornerRadius: cornerRadius,
          constraints: constraints,
          layoutAlign: layoutAlign,
          size: size,
          horizontalPadding: horizontalPadding,
          verticalPadding: verticalPadding,
          itemSpacing: itemSpacing,
          flow: flow,
        );

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) => Group.fromJson(json);
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(TempGroupLayoutNode(this, currentContext,
        topLeftCorner: Point(boundaryRectangle.x, boundaryRectangle.y),
        bottomRightCorner: Point(boundaryRectangle.x + boundaryRectangle.width,
            boundaryRectangle.y + boundaryRectangle.height)));
  }
}
