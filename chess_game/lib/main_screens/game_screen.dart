import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:chess_game/helper/helper_method.dart';
import 'package:chess_game/helper/uci_commands.dart';
import 'package:chess_game/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

import 'package:chess_game/services/assets_manager.dart';
import 'package:stockfish/stockfish.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Stockfish stockFish;

  @override
  void initState() {
    stockFish = Stockfish();
    final gameProvider = context.read<GameProvider>();
    gameProvider.resetGame(newGame: false); 
    if(mounted){
      letOtherPlayerPlayFirst();
    }
    super.initState();
  }

  void letOtherPlayerPlayFirst(){
    // wait for widget to rebuild
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final gameProvider = context.read<GameProvider>();
      if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
        // Set AI to thinking mode
        gameProvider.setAiThinking(value:true);
        // Simulate AI thinking time with a random delay (250ms to 5 seconds)
        await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));
        // AI makes a random move
        gameProvider.game.makeRandomMove();
        // Update game state after AI's move
        gameProvider.setAiThinking(value: false);
        gameProvider.setSquaresState().whenComplete((){
          gameProvider.pushWhitesTime();
          startTimer(isWhiteTimer: false, onNewGame: (){});
          print("first");
        });
      }
    });
  }
  
  void startTimer({
      required bool isWhiteTimer,
      required Function onNewGame,
    }){
    final gameProvider = context.read<GameProvider>();
    if(isWhiteTimer){
      // start white timer
      gameProvider.startWhitesTimer(context: context, onNewGame:onNewGame);
    }
    else{
      // start black timer
      gameProvider.startBlacksTimer(context: context, onNewGame: onNewGame);
    }
  }


  Future<void> waitUintilStockfishIsReady()async{
    while(stockFish.state.value!=StockfishState.ready){
        print("is Ready: ${stockFish.state.value}");
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void _onMove(Move move) async {
    final gameProvider = context.read<GameProvider>();
    print("move: $move");
    print("move: ${gameProvider.whiteTime}");
    print("move: ${gameProvider.blackTime}");
    // Player makes a move, and we check if it's valid
    bool result = gameProvider.makeSquaresMove(move);
    // If the move is valid, update the game state
    if (result) {
      gameProvider.setSquaresState().whenComplete((){
        if(gameProvider.player==Squares.white){
          gameProvider.pushWhitesTime();
          startTimer(isWhiteTimer: false, onNewGame: (){});
        }
        else{
          gameProvider.pushBlacksTime();
          startTimer(isWhiteTimer: true, onNewGame: (){});
        }
      });
    }
    // Check if it's now the opponent's (AI's) turn and AI is not already thinking
    if (gameProvider.state.state == PlayState.theirTurn && !gameProvider.aiThinking) {
      // Set AI to thinking modefgs d
      gameProvider.setAiThinking(value:true);
      //  wait until stockfish is ready 
      await waitUintilStockfishIsReady();

      // get the current position of the board sent to stockfish
      stockFish.stdin= "${UciCommands.position} ${gameProvider.getPositionFen()}";
      // set StockFish Level
      stockFish.stdin ="${UciCommands.goMoveTime} ${gameProvider.gameLevel*1000}";
      stockFish.stdout.listen((event){
        print("Event: $event");
      });

      // // Simulate AI thinking time with a random delay (250ms to 5 seconds)
      // await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));
      // // AI makes a random move
      // gameProvider.game.makeRandomMove();

      // // Update game state after AI's move
      // gameProvider.setAiThinking(value: false);
      // gameProvider.setSquaresState().whenComplete((){
      //   if(gameProvider.player==Squares.white){
      //     gameProvider.pushBlacksTime();
      //     startTimer(isWhiteTimer: true, onNewGame: (){});
      //   }
      //   else{
      //     gameProvider.pushWhitesTime();
      //     startTimer(isWhiteTimer: false, onNewGame: (){});
      //   }
      // }
      // );
    }
    // listen if game over
    checkGameOverListener();
  }
  void checkGameOverListener(){
    final gameProvider = context.read<GameProvider>();        
    gameProvider.gameOverListener(context: context, onNewGame: (){
      // start new game

    });

  }


  // void _onMove(Move move) async {
  //   // Player makes a move, and we check if it's valid
  //   bool result = game.makeSquaresMove(move);

  //   // If the move is valid, update the game state
  //   if (result) {
  //     setState(() => state = game.squaresState(player));
  //   }

  //   // Check if it's now the opponent's (AI's) turn and AI is not already thinking
  //   if (state.state == PlayState.theirTurn && !aiThinking) {
  //     // Set AI to thinking mode
  //     setState(() => aiThinking = true);

  //     // Simulate AI thinking time with a random delay (250ms to 5 seconds)
  //     await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));

  //     // AI makes a random move
  //     game.makeRandomMove();

  //     // Update game state after AI's move
  //     setState(() {
  //       aiThinking = false;  // AI is no longer thinking
  //       state = game.squaresState(player);  // Refresh the game state
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final gameProvider = context.read<GameProvider>();
  print("whites time : ${gameProvider.whiteTime}");
  print("blacks time : ${gameProvider.blackTime}");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
         icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            // show dialog if sure

            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.orange,
        title: Text("romjan developer!"),
        actions: [
          IconButton(
            onPressed: (){
              gameProvider.resetGame(newGame: true);
            }, 
            icon: const Icon(Icons.start ,color: Colors.white,),
          ),
          
          IconButton(
            onPressed: (){
              gameProvider.flipTheBoard();
            }, 
            icon: const Icon(Icons.rotate_90_degrees_ccw ,color: Colors.white,),
          ),
          
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child){

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            // opponents data
            ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(AssetsManager.stockfishIcon),
                backgroundColor: Colors.green,
              ),
              title: Text("stockfish"),
              subtitle: Text("rating: 1200"),
              trailing: Text(getTimerToDisplay(gameProvider: gameProvider, isUser: false), style: TextStyle(fontSize: 16),),
            ),
        
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BoardController(
                state: gameProvider.flipBoard ? gameProvider.state.board.flipped() : gameProvider.state.board,
                playState: gameProvider.state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.brown,
                moves: gameProvider.state.moves,
                onMove: _onMove,
                onPremove: _onMove,
                markerTheme: MarkerTheme(
                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),
            // our data
            ListTile(
              leading: CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage(AssetsManager.stockfishIcon),
                backgroundColor: Colors.green,
              ),
              title: Text("romjanali01673"),
              subtitle: Text("rating: 2000"),
              trailing: Text(getTimerToDisplay(gameProvider: gameProvider, isUser: true), style: TextStyle(fontSize: 16),),
            ),
        
            const SizedBox(height: 32),
          ],
        );
        },
      ),
    );
  }
}