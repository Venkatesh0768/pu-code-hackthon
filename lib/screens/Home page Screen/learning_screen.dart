import 'package:flutter/material.dart';


class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  static const id = "learning_screen";

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Learning Screen'),
        ),
        body: const Center(
          child: Text('Homre Screen'),
        ),
      ),
    );
  }
}