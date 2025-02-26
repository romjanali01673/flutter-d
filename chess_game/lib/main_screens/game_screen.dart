import 'dart:math';

import 'package:bishop/bishop.dart' as bishop;
import 'package:flutter/material.dart';
import 'package:square_bishop/square_bishop.dart';
import 'package:squares/squares.dart';

import 'package:chess_game/services/assets_manager.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;

  @override
  void initState() {
    _resetGame(false);
    super.initState();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  void _flipBoard() => setState(() => flipBoard = !flipBoard);

  void _onMove(Move move) async {
    // Player makes a move, and we check if it's valid
    bool result = game.makeSquaresMove(move);

    // If the move is valid, update the game state
    if (result) {
      setState(() => state = game.squaresState(player));
    }

    // Check if it's now the opponent's (AI's) turn and AI is not already thinking
    if (state.state == PlayState.theirTurn && !aiThinking) {
      // Set AI to thinking mode
      setState(() => aiThinking = true);

      // Simulate AI thinking time with a random delay (250ms to 5 seconds)
      await Future.delayed(Duration(milliseconds: Random().nextInt(4750) + 250));

      // AI makes a random move
      game.makeRandomMove();

      // Update game state after AI's move
      setState(() {
        aiThinking = false;  // AI is no longer thinking
        state = game.squaresState(player);  // Refresh the game state
      });
    }
  }


  @override
  Widget build(BuildContext context) {
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
            onPressed: _resetGame, 
            icon: const Icon(Icons.start ,color: Colors.white,),
          ),
          
          IconButton(
            onPressed: _flipBoard, 
            icon: const Icon(Icons.rotate_90_degrees_ccw ,color: Colors.white,),
          ),
          
        ],
      ),
      body: Column(
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
            trailing: Text("05:00")
          ),
      
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: BoardController(
              state: flipBoard ? state.board.flipped() : state.board,
              playState: state.state,
              pieceSet: PieceSet.merida(),
              theme: BoardTheme.brown,
              moves: state.moves,
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
            trailing: Text("05:00")
          ),
      
          const SizedBox(height: 32),
          // OutlinedButton(
          //   onPressed: _resetGame,
          //   child: const Text('New Game'),
          // ),
          // IconButton(
          //   onPressed: _flipBoard,
          //   icon: const Icon(Icons.rotate_left),
          // ),
        ],
      ),
    );
  }
}