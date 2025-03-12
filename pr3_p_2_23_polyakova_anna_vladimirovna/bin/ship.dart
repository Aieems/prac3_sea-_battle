import 'coordinate.dart';

class Ship {
  final List<Coordinate> coordinates;
  final Set<Coordinate> hits = <Coordinate>{};

  Ship(this.coordinates);

  bool isSunk() => hits.length == coordinates.length;

  bool containsCoordinate(Coordinate coordinate) {
    return coordinates.any((coord) => coord.equals(coordinate));
  }

  void hit(Coordinate coordinate) {
    if (containsCoordinate(coordinate)) {
      hits.add(coordinate);
    }
  }
}
