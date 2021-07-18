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
  /// calculates the distance given two [Point]s
  /// 
  /// [isXAxis], which default to `true`, is a flag on which axis should
  /// the calculation be done.
  static double dist(Point TLC, Point BTC, [isXAxis = true]){
    if(TLC == null || BTC == null){
      throw NullThrownError();
    }
    return isXAxis ? (BTC.x - TLC.x).abs() : (BTC.y - TLC.y).abs();
  }
}
