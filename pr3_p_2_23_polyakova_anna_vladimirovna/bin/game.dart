import 'dart:io';
import 'dart:math';
import 'coordinate.dart';
import 'board.dart';


class Game {
  final Board playerBoard;
  final Board enemyBoard;
  final Set<Coordinate> enemyShots = <Coordinate>{};

  Game(int size)
      : playerBoard = Board(size),
        enemyBoard = Board(size);

  Coordinate getUserCoordinate(String prompt) {
    while (true) {
      print(prompt);
      String? input = stdin.readLineSync();
      if (input != null) {
        List<String> parts = input.split(' ');
        if (parts.length == 2) {
          int? x = int.tryParse(parts[0]);
          int? y = int.tryParse(parts[1]);
          if (x != null && y != null && x >= 0 && x < 10 && y >= 0 && y < 10) {
            return Coordinate(x, y);
          }
        }
      }
      print("Неверный ввод. Введите координаты в формате 'x y'.");
    }
  }

  void play() {
    bool playerTurn = true;
    Random rand = Random();

    while (!playerBoard.allShipsSunk() && !enemyBoard.allShipsSunk()) {
      playerBoard.printSideBySide(enemyBoard);

      print("Поле игрока 1${' ' * (playerBoard.size + 5)}Поле бота");

      if (playerTurn) {
        Coordinate shot = getUserCoordinate("Введите координаты для атаки:");
        bool hit = enemyBoard.fireAt(shot);
        print(hit ? "Попадание!" : "Промах!");

        if (enemyBoard.allShipsSunk()) {
          print("Вы победили!");
          return;
        }

        if (!hit) playerTurn = false;
      } else {
        Coordinate enemyShot;
        do {
          enemyShot = Coordinate(rand.nextInt(10), rand.nextInt(10));
        } while (!enemyShots.add(enemyShot));

        bool enemyHit = playerBoard.fireAt(enemyShot);
        print("Противник стреляет в ${enemyShot.toString()} и ${enemyHit ? "попал!" : "промахнулся."}");

        if (playerBoard.allShipsSunk()) {
          print("Вы проиграли!");
          return;
        }

        if (!enemyHit) playerTurn = true;
      }
    }
  }
}
