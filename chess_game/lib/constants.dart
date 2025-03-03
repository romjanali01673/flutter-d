import 'package:chess_game/main_screens/game_time_screen.dart';
import 'package:chess_game/main_screens/home_screen.dart';

class Constants {
  static const custom = "Custom";

  static const homeScreen = "/homeScreen";
  static const gameScreen = "gameScreen";
  static const settingScreen = "settingScreen";
  static const aboutScreen = "aboutScreen";
  static const gameStartUpScreen = "gameStartUpScreen";
  static const gameTimeScreen = "gameTimeScreen";
}

enum PlayerColor{
  white, black,
}
enum GameDificulty{
  easy, medium, hard,
}