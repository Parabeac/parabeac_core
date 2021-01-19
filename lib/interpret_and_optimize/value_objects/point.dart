///Geographical point on the canvas.
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
}
