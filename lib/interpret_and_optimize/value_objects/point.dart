import 'package:json_annotation/json_annotation.dart';

part 'point.g.dart';

///Geographical point on the canvas.
@JsonSerializable()
class Point implements Comparable<Point> {
  ///absolue positions
  final double x, y;

  Point(this.x, this.y);

  @override
  String toString() => ' X: $x, Y:$y';

  Point clone(Point point) => Point(point.x, point.y);

  // TODO: This is a temporal fix
  // (y.abs() - anotherPoint.y.abs()).abs() < 3
  @override
  int compareTo(Point anotherPoint) =>
      y == anotherPoint.y || (y.abs() - anotherPoint.y.abs()).abs() < 3
          ? x.compareTo(anotherPoint.x)
          : y.compareTo(anotherPoint.y);
  @override
  bool operator ==(Object point) {
    if (point is Point) {
      return y == point.y ? x == point.x : y == point.y;
    }
    return false;
  }

  bool operator <(Object point) {
    if (point is Point) {
      return y == point.y ? x <= point.x : y <= point.y;
    }
    return false;
  }

  bool operator >(Object point) {
    if (point is Point) {
      return y == point.y ? x >= point.x : y >= point.y;
    }
    return false;
  }

  static Point topLeftFromJson(Map<String, dynamic> json) {
    if (json == null) {
      print('nullVal');
    }
    var x, y;
    if (json.containsKey('boundaryRectangle')) {
      x = json['boundaryRectangle']['x'];
      y = json['boundaryRectangle']['y'];
    } else {
      x = json['x'];
      y = json['y'];
    }
    return Point(x, y);
  }

  static Point bottomRightFromJson(Map<String, dynamic> json) {
    if (json == null) {
      print('nullVal');
    }
    var x, y;
    if (json.containsKey('boundaryRectangle')) {
      x = json['boundaryRectangle']['x'] + json['boundaryRectangle']['width'];
      y = json['boundaryRectangle']['y'] + json['boundaryRectangle']['width'];
    } else {
      x = json['x'] + json['width'];
      y = json['y'] + json['height'];
    }
    return Point(x, y);
  }

  Map<String, dynamic> toJson() => _$PointToJson(this);
}
