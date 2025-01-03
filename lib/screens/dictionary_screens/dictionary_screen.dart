import 'package:flutter/material.dart';
import 'home_screen.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  static String id = "dictionary_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },  
        ),
        title: Text('Dictionary'),
        backgroundColor: Colors.teal.shade400,
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
          
          ]


      ),
      body: HomeScreen(), // Replace with your home screen widget
    );
  }
}
