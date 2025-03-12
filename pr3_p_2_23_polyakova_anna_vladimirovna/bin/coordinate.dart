class Coordinate {
  final int x;
  final int y;

  Coordinate(this.x, this.y);

  bool equals(Coordinate other) => x == other.x && y == other.y;

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) => other is Coordinate && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}