import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class ShapesComparisonUtils {
  static bool areXCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.x >= topLeftCorner0.x &&
          topLeftCorner1.x <= bottomRightCorner0.x ||
      bottomRightCorner1.x <= bottomRightCorner0.x &&
          bottomRightCorner1.x >= topLeftCorner0.x;

  static bool areYCoordinatesOverlapping(
          Point topLeftCorner0,
          Point bottomRightCorner0,
          Point topLeftCorner1,
          Point bottomRightCorner1) =>
      topLeftCorner1.y >= topLeftCorner0.y &&
          topLeftCorner1.y <= bottomRightCorner0.y ||
      bottomRightCorner1.y <= bottomRightCorner0.y &&
          bottomRightCorner1.y >= topLeftCorner0.y;

  static bool isHorizontalTo(Point topLeftCorner, Point bottomRightCorner,
      Point topLeftCorner0, Point bottomRightCorner0) {
    return (!(areXCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0))) &&
        areYCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0);
  }

  static bool isVerticalTo(Point topLeftCorner, Point bottomRightCorner,
      Point topLeftCorner0, Point bottomRightCorner0) {
    return (!(areYCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0))) &&
        areXCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0);
  }

  static bool isOverlappingTo(Point topLeftCorner, Point bottomRightCorner,
      Point topLeftCorner0, Point bottomRightCorner0) {
    return (areXCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0)) &&
        areYCoordinatesOverlapping(topLeftCorner, bottomRightCorner,
            topLeftCorner0, bottomRightCorner0);
  }
  }