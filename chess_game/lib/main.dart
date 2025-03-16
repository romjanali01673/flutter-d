import 'dart:io';

import 'package:chess_game/authentication/landing_acreen.dart';
import 'package:chess_game/constants.dart';
import 'package:chess_game/main_screens/about_screen.dart';
import 'package:chess_game/main_screens/game_screen.dart';
import 'package:chess_game/main_screens/game_start_up_screen.dart';
import 'package:chess_game/main_screens/game_time_screen.dart';
import 'package:chess_game/main_screens/home_screen.dart';
import 'package:chess_game/main_screens/setting_screen.dart';
import 'package:chess_game/providers/authantication_provider.dart';
import 'package:chess_game/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/login_screen.dart';
import 'authentication/sign_up_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // mainx();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>GameProvider()),
        ChangeNotifierProvider(create: (_)=>AuthenticationProvider()),
      ],
      child:const MyApp(),
    )
  );
}
void mainx() async {
  // Path to Stockfish engine (update based on your OS)
  String stockfishPath = "assets/stockfish/stockfish.exe"; // Windows
  // String stockfishPath = "assets/stockfish/stockfish"; // macOS/Linux

  // Start Stockfish
  Process process = await Process.start(stockfishPath, []);

  // Send UCI command
  process.stdin.writeln("uci");

  // Listen for Stockfish output
  process.stdout.transform(SystemEncoding().decoder).listen((data) {
    print("Stockfish Output: $data");
  });

  // Stop the engine (Optional)
  // process.kill();
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const HomeScreen(),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
      initialRoute: Constants.landingScreen,
      routes: {
        Constants.homeScreen: (context)=>const HomeScreen(),
        Constants.gameScreen: (context)=>const GameScreen(),
        Constants.aboutScreen: (context)=>const AboutScreen(),
        Constants.settingScreen: (context)=>const SettingScreen(),
        Constants.gameTimeScreen: (context)=>const GameTimeScreen(),
        Constants.signInScreen: (context)=>const LoginScreen(),
        Constants.signUpScreen: (context)=>const SignUpScreen(),
        Constants.landingScreen: (context)=>const LandingScreen(),
      },
    );
  }
}

