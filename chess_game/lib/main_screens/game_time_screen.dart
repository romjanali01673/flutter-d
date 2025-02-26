import 'package:chess_game/helper/helper_method.dart';
import 'package:flutter/material.dart';

class GameTimeScreen extends StatefulWidget {
  const GameTimeScreen({super.key});

  @override
  State<GameTimeScreen> createState() => _GameTimeScreenState();
}

class _GameTimeScreenState extends State<GameTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.orange,
        title: Text("Choose GameTime ", style: TextStyle(fontSize: 20, color:  Colors.white),),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5, //1. (height:width) => 1x : 1.5x //2. width = x*height
          ),
          itemBuilder: (context, index){

              // get the first word of game time 
              final String label = gameTimes[index].split(" ")[0];

              // get the second word of game time 
              final String gameTime = gameTimes[index].split(" ")[1];

            return buildGameType(
              label: label,
              ontap:(){
                print(gameTime);
              }, 
              gameTime: gameTime,
            );
          },
          itemCount: gameTimes.length,
        ),
      ),
    );
  }
}