import 'dart:io';
import 'dart:math';
import 'coordinate.dart';
import 'ship.dart';

class Board {
  final int size;
  final List<List<String>> grid;
  final List<Ship> ships;

  Board(this.size)
      : grid = List<List<String>>.generate(size, (_) => List<String>.generate(size, (_) => '.', growable: false)),
        ships = <Ship>[];

  bool isValidPosition(List<Coordinate> coordinates) {
    for (var coordinate in coordinates) {
      if (coordinate.x < 0 || coordinate.x >= size || coordinate.y < 0 || coordinate.y >= size || grid[coordinate.x][coordinate.y] != '.') {
        return false;
      }
      for (var dx = -1; dx <= 1; dx++) {
        for (var dy = -1; dy <= 1; dy++) {
          int nx = coordinate.x + dx;
          int ny = coordinate.y + dy;
          if (nx >= 0 && ny >= 0 && nx < size && ny < size && grid[nx][ny] == 'S') {
            return false;
          }
        }
      }
    }
    return true;
  }

  bool placeShip(Ship ship) {
    if (!isValidPosition(ship.coordinates)) return false;
    for (var coordinate in ship.coordinates) {
      grid[coordinate.x][coordinate.y] = 'S';
    }
    ships.add(ship);
    return true;
  }

  bool fireAt(Coordinate coordinate) {
    if (grid[coordinate.x][coordinate.y] == 'X' || grid[coordinate.x][coordinate.y] == 'O') {
      return false;
    }
    for (var ship in ships) {
      if (ship.containsCoordinate(coordinate)) {
        ship.hit(coordinate);
        grid[coordinate.x][coordinate.y] = 'X';
        if (ship.isSunk()) {
          print("Корабль потоплен!");
        }
        return true;
      }
    }
    grid[coordinate.x][coordinate.y] = 'O';
    return false;
  }

  bool allShipsSunk() => ships.every((ship) => ship.isSunk());

  void printSideBySide(Board otherBoard) {
    stdout.write("   ");
    for (var i = 0; i < size; i++) stdout.write("$i ");
    stdout.write("        ");
    for (var i = 0; i < size; i++) stdout.write("$i ");
    print("");

    for (var x = 0; x < size; x++) {
      stdout.write("$x ");
      if (x < 10) stdout.write(" ");
      for (var y = 0; y < size; y++) stdout.write("${grid[x][y]} ");
      stdout.write("     $x ");
      if (x < 10) stdout.write(" ");
      for (var y = 0; y < size; y++) {
        var cell = otherBoard.grid[x][y];
        if (cell == 'S') cell = '.';
        stdout.write("$cell ");
      }
      print("");
    }
  }

  void randomizeShips(List<int> shipSizes) {
    Random rand = Random();
    for (var size in shipSizes) {
      bool placed = false;
      while (!placed) {
        int x = rand.nextInt(this.size);
        int y = rand.nextInt(this.size);
        int orientation = rand.nextInt(2);

        List<Coordinate> coordinates = List<Coordinate>.generate(
            size, (i) => orientation == 0 ? Coordinate(x, y + i) : Coordinate(x + i, y));

        if (placeShip(Ship(coordinates))) {
          placed = true;
        }
      }
    }
  }
}
