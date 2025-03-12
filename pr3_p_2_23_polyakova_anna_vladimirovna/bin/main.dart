import 'game.dart';

void main() {
  Game game = Game(10);
  game.playerBoard.randomizeShips([4, 3, 3, 2, 2, 2, 1, 1, 1, 1]);
  game.enemyBoard.randomizeShips([4, 3, 3, 2, 2, 2, 1, 1, 1, 1]);
  game.play();
}
