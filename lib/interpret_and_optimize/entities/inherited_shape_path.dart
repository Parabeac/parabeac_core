import 'dart:typed_data';

import 'package:parabeac_core/controllers/main_info.dart';
import 'package:parabeac_core/design_logic/color.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_bitmap_gen.dart';
import 'package:parabeac_core/generation/generators/visual-widgets/pb_container_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/shape_path.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_image_reference_storage.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InheritedShapePath extends PBVisualIntermediateNode
    with PBColorMixin
    implements PBInheritedIntermediate {
  @override
  var originalRef;
  @override
  PrototypeNode prototypeNode;

  InheritedShapePath(this.originalRef, String name,
      {Uint8List image, PBContext currentContext})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext,
            name,
            UUID: originalRef.UUID ?? '') {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    generator = PBBitmapGenerator();

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
    var path = (originalRef as ShapePath);
    // Possible vertical or horizontal point
    if (path.points.length == 2) {
      //Parse the points
      var p1Str = path.points[0]['point']
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',');
      var p2Str = path.points[1]['point']
          .toString()
          .replaceAll('{', '')
          .replaceAll('}', '')
          .split(',');

      var p1 = Point(double.parse(p1Str[0]), double.parse(p1Str[1]));
      var p2 = Point(double.parse(p2Str[0]), double.parse(p2Str[1]));

      if (_isEdgeAdjacent(p1, p2)) {
        generator = PBContainerGenerator();
        auxiliaryData.color = toHex(originalRef.style.borders[0].color);
      }
    }
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
}
