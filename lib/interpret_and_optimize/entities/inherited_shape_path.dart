import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/abstract_intermediate_node_factory.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inherited_shape_path.g.dart';

@JsonSerializable()
class InheritedShapePath extends PBVisualIntermediateNode
    implements PBInheritedIntermediate, IntermediateNodeFactory {
  @override
  @JsonKey(fromJson: PrototypeNode.prototypeNodeFromJson)
  PrototypeNode prototypeNode;

  @override
  @JsonKey(fromJson: Point.topLeftFromJson)
  Point topLeftCorner;
  @override
  @JsonKey(fromJson: Point.bottomRightFromJson)
  Point bottomRightCorner;

  @override
  @JsonKey()
  String type = 'inherited_shape_path';

  @override
  String UUID;

  @override
  @JsonKey(fromJson: PBIntermediateNode.sizeFromJson)
  Map size;

  @override
  @JsonKey(ignore: true)
  PBContext currentContext;

  InheritedShapePath({
    String name,
    Uint8List image,
    this.currentContext,
    this.topLeftCorner,
    this.bottomRightCorner,
    this.prototypeNode,
    this.type,
    this.UUID,
    this.size,
  }) : super(
          topLeftCorner,
          bottomRightCorner,
          currentContext,
          name,
          UUID: UUID ?? '',
        ) {
    // if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
    //   prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    // }
    generator = PBBitmapGenerator();

    // size = {
    //   'width': originalRef.boundaryRectangle.width,
    //   'height': originalRef.boundaryRectangle.height
    // };

    // name = originalRef.name;

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, '${MainInfo().outputPath}assets/images', image);

    // Detect shape path as container if applicable
    _detectLineAsContainer();
  }

  void _detectLineAsContainer() {
    // var path = (originalRef as ShapePath);
    // // Possible vertical or horizontal point
    // if (path.points.length == 2) {
    //   //Parse the points
    //   var p1Str = path.points[0]['point']
    //       .toString()
    //       .replaceAll('{', '')
    //       .replaceAll('}', '')
    //       .split(',');
    //   var p2Str = path.points[1]['point']
    //       .toString()
    //       .replaceAll('{', '')
    //       .replaceAll('}', '')
    //       .split(',');

    //   var p1 = Point(double.parse(p1Str[0]), double.parse(p1Str[1]));
    //   var p2 = Point(double.parse(p2Str[0]), double.parse(p2Str[1]));

    //   if (_isEdgeAdjacent(p1, p2)) {
    //     generator = PBContainerGenerator();
    //     auxiliaryData.color = toHex(originalRef.style.borders[0].color);
    //   }
    // }
  }

  /// Returns true if [p1] and [p2] form
  /// either a vertical or horizontal line.
  bool _isEdgeAdjacent(Point p1, Point p2) {
    num deltaX = (p1.x - p2.x).abs();
    num deltaY = (p1.y - p2.y).abs();

    var isVertical = deltaX < 0.01 && deltaY > 0;
    var isHorizontal = deltaY < 0.01 && deltaX > 0;

    return isVertical || isHorizontal;
  }

  @override
  void addChild(PBIntermediateNode node) {
    return;
  }

  @override
  void alignChild() {}

  @override
  PBIntermediateNode fromJson(Map<String, dynamic> json) =>
      _$InheritedShapePathFromJson(json);
}
