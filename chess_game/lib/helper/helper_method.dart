import 'package:chess_game/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';

final List<String> gameTimes =[
  "Bullet 1+0",
  "Bullet 2+1",
  "Blitz 3+0",
  "Blitz 3+2",
  "Blitz 5+0",
  "Blitz 5+3",
  "Rapid 10+0",
  "Rapid 10+5",
  "Rapid 15+10",
  "Classical 30+0",
  "Classical 30+20",
  "Custom 60+0",
];


Widget buildGameType ({ required String label, IconData? icon, String? gameTime, required Function() ontap}){
  return InkWell(
    onTap:ontap,
    child: Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? Icon(icon, size: 50,): gameTime=="60+0"? SizedBox.shrink() : Text(gameTime!, style: TextStyle(fontSize: 16)),
          const SizedBox( height: 10,),
          Text(label, style: TextStyle(fontSize: 16),),
        ],
      ),
    ),
  );
}

String getTimerToDisplay({required GameProvider gameProvider, required bool isUser}){
  String timer='x';
  if(isUser){
    if(gameProvider.player==Squares.white){
      timer= gameProvider.whiteTime.toString().substring(2,7);
    }
    else{
      timer= gameProvider.blackTime.toString().substring(2,7);
    }
  }
  else{
    // other -Ai or Person
    if(gameProvider.player==Squares.white){
      timer= gameProvider.blackTime.toString().substring(2,7);
    }
    else{
      timer= gameProvider.whiteTime.toString().substring(2,7);
    }
  }
  return timer;
}