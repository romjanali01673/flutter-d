import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.orange,
        title: Text("Setting Screen", style: TextStyle(fontSize: 20, color:  Colors.white),),
      ),
      body: Center(
        child: Text("setting secrren"),
      ),
    );

  }
}