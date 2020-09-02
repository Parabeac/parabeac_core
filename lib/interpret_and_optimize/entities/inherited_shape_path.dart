import 'dart:io';
import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/input/entities/layers/abstract_layer.dart';
import 'package:parabeac_core/input/entities/layers/shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';
import 'package:json_annotation/json_annotation.dart';

import 'injected_container.dart';

part 'inherited_shape_path.g.dart';

@JsonSerializable(nullable: false)
class InheritedShapePath extends PBVisualIntermediateNode
    implements PBInheritedIntermediate {
  @override
  var originalRef;

  @override
  String UUID;

  ///Represents the location of the png file.
  @JsonKey(ignore: true)
  Uint8List image;

  ///Name of the png file
  String name;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String referenceImage;

  Map size;

  String widgetType = 'Bitmap';

  InheritedShapePath(this.originalRef, {this.image, this.currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext) {
    generator = PBBitmapGenerator();

    UUID = originalRef.UUID;

    size = {
      'width': originalRef.boundaryRectangle.width,
      'height': originalRef.boundaryRectangle.height
    };

    name = originalRef.name;

    ImageReferenceStorage().addReferenceAndWrite(
        UUID, '${MainInfo().outputPath}assets/images', image);

    // Detect shape path as container if applicable
    _detectLineAsContainer();
  }

  void _detectLineAsContainer() {
    ShapePath path = (originalRef as ShapePath);
    // Possible vertical or horizontal point
    if (path.points.length == 2) {
      //Parse the points
      List<String> p1Str = path.points[0]['point']
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',');
      List<String> p2Str = path.points[1]['point']
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',');

      Point p1 = Point(double.parse(p1Str[0]), double.parse(p1Str[1]));
      Point p2 = Point(double.parse(p2Str[0]), double.parse(p2Str[1]));

      if (_isEdgeAdjacent(p1, p2)) {
        Point tlc = Point(
            originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y);
        Point brc = Point(
            originalRef.boundaryRectangle.x +
                originalRef.boundaryRectangle.width,
            originalRef.boundaryRectangle.y +
                originalRef.boundaryRectangle.height);

        generator = PBContainerGenerator();
        color = originalRef.style.borders[0].color.toHex();
      }
    }
  }

  /// Returns true if [p1] and [p2] form
  /// either a vertical or horizontal line.
  bool _isEdgeAdjacent(Point p1, Point p2) {
    num deltaX = (p1.x - p2.x).abs();
    num deltaY = (p1.y - p2.y).abs();

    bool isVertical = deltaX < 0.01 && deltaY > 0;
    bool isHorizontal = deltaY < 0.01 && deltaX > 0;

    return isVertical || isHorizontal;
  }

  @override
  void addChild(PBIntermediateNode node) {
    return;
  }

  @override
  void alignChild() {
    // TODO: implement alignChild
  }

  factory InheritedShapePath.fromJson(Map<String, Object> json) =>
      _$InheritedShapePathFromJson(json);
  Map<String, Object> toJson() => _$InheritedShapePathToJson(this);
}
