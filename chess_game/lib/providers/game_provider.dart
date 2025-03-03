import 'dart:async';

import 'package:chess_game/constants.dart';
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';
import 'package:bishop/bishop.dart' as bishop;
class GameProvider extends ChangeNotifier{

  late bishop.Game _game = bishop.Game(variant: bishop.Variant.standard());
  late SquaresState _state = SquaresState.initial(0);
  bool _aiThinking= false;
  bool _flipBoard = false;

  bool _vsComputer = false;
  bool _isLoading = false;

  Timer? _whitesTimer;
  Timer? _blacksTimer;
  int _whiteScore=0;
  int _blackScore=0;

  int _gameLevel =1;
  GameDificulty _gameDificulty = GameDificulty.easy;

  int _incremantalvalue = 0;
  int _player = Squares.white;
  PlayerColor _playerColor= PlayerColor.white;

  Duration _whiteTime = Duration.zero;
  Duration _blackTime = Duration.zero;
  
  Duration _savedWhiteTime = Duration.zero;
  Duration _savedBlackTime = Duration.zero;

  int get getIncremantalValue => _incremantalvalue;
  int get player => _player;
  PlayerColor get playerColor => _playerColor;

  Duration get whiteTime =>_whiteTime;
  Duration get blackTime =>_blackTime;

  Duration get savedWhiteTime =>_savedWhiteTime;
  Duration get savedBlackTime =>_savedBlackTime;

  bishop.Game get game =>_game;
  SquaresState get state => _state;
  bool get aiThinking =>_aiThinking; 
  bool get flipBoard =>_flipBoard; 

  int get whiteScore => _whiteScore;
  int get blackScore => _blackScore;

  // set game time
  Future<void>setGameTime({required String newSavedWhitesTime, required String newSavedBlacksTime})async{
     _savedWhiteTime = Duration(minutes: int.parse(newSavedWhitesTime));
     _savedBlackTime = Duration(minutes: int.parse(newSavedBlacksTime));
     notifyListeners();
     setWhitesTime(_savedWhiteTime);
     setBlacksTime(_savedBlackTime);
  }
  // set incremantal value
  void setIncremantalValue({required int value}){
    _incremantalvalue = value;
    notifyListeners();
  }
  void setWhitesTime(Duration time){
    _whiteTime =time;
    notifyListeners();
  }
  void setBlacksTime(Duration time){
    _blackTime =time;
    notifyListeners();
  }

// get method
  bool get vsComputer=>_vsComputer;
  bool get isLoading=>_isLoading;

  int get gameLevel=>_gameLevel;
  GameDificulty get gameDificulty=>_gameDificulty;

  // get position fen
  getPositionFen(){
    return game.fen;
  }
 
// set method
  void setVsComputer ({required bool value}){
    _vsComputer = value;
    notifyListeners();
  }
  void setIsLoading ({required bool value}){
    _isLoading = value;
    notifyListeners();
  }
  void setAiThinking({required bool value}){
    _aiThinking = value;
    notifyListeners();
  }

  // reset Game
  void resetGame({required bool newGame}){
    if(newGame){
      // check if the player white in the previous game 
      // change the player
      if(player==Squares.white){
        _player = Squares.black;
      }
      // reset game
      notifyListeners();
    }
    _game = bishop.Game(variant: bishop.Variant.standard());
    _state =game.squaresState(_player);
  }

  // make Square move
  bool makeSquaresMove(Move move){
    bool result = game.makeSquaresMove(move);
    notifyListeners();
    return result;
  }
  // set square State
  Future<void> setSquaresState()async{
    _state = game.squaresState(player);
      // print("State updated: $_state");  // Debugging
    notifyListeners();
  }

  // make danrom move
  void makeRandomMove(){
    game.makeRandomMove();
    notifyListeners();
  }

  void flipTheBoard(){
    _flipBoard = !flipBoard;
    notifyListeners();
  }

  void setPlayerColor({required int player}){
    _player = player;
    _playerColor = player==Squares.white? PlayerColor.white:PlayerColor.black;
    notifyListeners();
  }
  void setGameDificulty({required int level}){
    _gameLevel = level;
    _gameDificulty  = level==1
    ? GameDificulty.easy:
      level==2
        ? GameDificulty.medium : 
          GameDificulty.hard;
    notifyListeners();
  }

  void startWhitesTimer({
    required BuildContext context,
    required Function onNewGame,
    }){
    _whitesTimer = Timer.periodic(Duration(seconds: 1), (_){
      _whiteTime = _whiteTime -const Duration(seconds: 1);
      notifyListeners();

      if(_whiteTime<=Duration.zero){
        // white has lost  by timeout
        _whitesTimer!.cancel();
        notifyListeners();

        print(" white has lost");
        gameOverDialog(context: context, timeOut: true, whiteWon:false, onNewGame: (){});
      }
    });
  }
  void startBlacksTimer({
    required BuildContext context,
    required Function onNewGame,
    }){
    _blacksTimer = Timer.periodic(Duration(seconds: 1), (_){
      _blackTime = _blackTime-const Duration(seconds: 1);
      notifyListeners();

      if(_blackTime<=Duration.zero){
        // black has lost  by timeout
        _blacksTimer!.cancel();
        notifyListeners();

        print(" black has lost");
        gameOverDialog(context: context, timeOut: true, whiteWon: true, onNewGame: (){});
      }
    });
  }


  // stop whites timer 
  void pushWhitesTime(){
    if(_whitesTimer!=null){
      _whiteTime+=Duration(seconds: _incremantalvalue);
      _whitesTimer!.cancel();
      notifyListeners();
    }
  }
  // stop Blacks timer 
  void pushBlacksTime(){
    if(_blacksTimer!=null){
      _blackTime+=Duration(seconds: _incremantalvalue);
      _blacksTimer!.cancel();
      notifyListeners();
    }
  }

  void gameOverListener({required BuildContext context, required Function onNewGame}){
    if(game.gameOver){
      pushWhitesTime();
      pushBlacksTime();

      if(context.mounted){
        gameOverDialog(
          context: context,
          timeOut: false, 
          whiteWon: false, 
          onNewGame: onNewGame,
        );
      }
    }
  }

  void gameOverDialog({
    required BuildContext context,
    required bool timeOut,
    required bool whiteWon,
    required Function onNewGame,
  }){
    String resultToShow="";
    int whiteScoreToShow=0;
    int blackScoreToShow=0;
    if(timeOut){
      if(whiteWon){
        resultToShow = "White Won On Time";
        whiteScoreToShow=_whiteScore+1;
      }
      else{
       resultToShow = "Black Won On Time";
       blackScoreToShow=_blackScore+1;
      }
    }
    else{
      resultToShow = game.result!.readable;
      if(game.drawn){
      String whiteResults = game.result!.scoreString.split("-").first;
      String blackResults = game.result!.scoreString.split("-").last;
      whiteScoreToShow = _whiteScore + int.parse(whiteResults);
      blackScoreToShow = _blackScore + int.parse(blackResults);
      }
      else if(game.winner==0){
      String whiteResults = game.result!.scoreString.split("-").first;
      whiteScoreToShow = _whiteScore + int.parse(whiteResults);

      }
      else if(game.winner==1){
      String blackResults = game.result!.scoreString.split("-").last;
      blackScoreToShow = _blackScore + int.parse(blackResults);
        
      }
      else if(game.stalemate){
        whiteScoreToShow = whiteScore;
        blackScoreToShow = blackScore;
      }

    }
    showDialog(context: context, barrierDismissible: false, builder: (context)=> AlertDialog(
      title: Text("Game Over\n $whiteScoreToShow - $blackScoreToShow", textAlign: TextAlign.center,),
      content: Text(resultToShow, textAlign: TextAlign.center,),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, Constants.homeScreen, (route)=>false);
        }, child: Text("Cancel",style: TextStyle(color:  Colors.red,),)),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("New Game",style: TextStyle(color:  Colors.red,),)),
      ],
    ));
  }
  // String getResultToShow({
  //   required bool whiteWon,
  // }){
  //   if(whiteWon){
  //     return "White Won On Time";
  //   }
  //   else{
  //     return "Black Won On Time";
  //   }
  // }
}