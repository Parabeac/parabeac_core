import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/pb_border.dart';
import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/figma/helper/style_extractor.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_bitmap.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:parabeac_core/input/figma/helper/image_helper.dart'
    as image_helper;

import 'figma_node.dart';

part 'rectangle.g.dart';

@JsonSerializable(nullable: true)
class FigmaRectangle extends FigmaVector
    with PBColorMixin, image_helper.PBImageHelperMixin
    implements AbstractFigmaNodeFactory {
  @override
  String type = 'RECTANGLE';
  FigmaRectangle({
    String name,
    bool isVisible,
    type,
    pluginData,
    sharedPluginData,
    style,
    layoutAlign,
    constraints,
    Frame boundaryRectangle,
    size,
    strokes,
    strokeWeight,
    strokeAlign,
    styles,
    this.cornerRadius,
    this.rectangleCornerRadii,
    this.points,
    List fillsList,
  }) : super(
          name: name,
          visible: isVisible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          style: style,
          layoutAlign: layoutAlign,
          constraints: constraints,
          boundaryRectangle: boundaryRectangle,
          size: size,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          styles: styles,
          fillsList: fillsList,
        );

  List points;
  double cornerRadius;

  List<double> rectangleCornerRadii;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) {
    var node = FigmaRectangle.fromJson(json);
    node.style = StyleExtractor().getStyle(json);
    return node;
  }

  factory FigmaRectangle.fromJson(Map<String, dynamic> json) =>
      _$FigmaRectangleFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaRectangleToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    var fillsMap =
        (fillsList == null || fillsList.isEmpty) ? {} : fillsList.first;
    if (fillsMap != null && fillsMap['type'] == 'IMAGE') {
      imageReference = addToImageQueue(UUID);

      return Future.value(
          InheritedBitmap(this, name, currentContext: currentContext));
    }
    PBBorder border;
    for (var b in style?.borders?.reversed ?? []) {
      if (b.isEnabled) {
        border = b;
      }
    }
    return Future.value(InheritedContainer(
      this,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      name,
      currentContext: currentContext,
      isBackgroundVisible:
          !fillsMap.containsKey('visible') || fillsMap['visible'],
      borderInfo: {
        'borderRadius': (style != null && style.borderOptions != null)
            ? cornerRadius
            : null,
        'borderColorHex': style.borders != null && style.borders.isNotEmpty
            ? toHex(style.borders[0].color)
            : null
      },
    ));
  }
}
