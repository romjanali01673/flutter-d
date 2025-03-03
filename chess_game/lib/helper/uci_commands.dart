import 'package:stockfish/stockfish.dart';

class UciCommands {
  static const String isReady = "isready";
  static const String goMoveTime = 'Go movetime';
  static const String goInfinite = 'go infinite';
  static const String stop = 'stop';
  static const String position = "position fen";
  static const String bestMove = "bestmove";
}