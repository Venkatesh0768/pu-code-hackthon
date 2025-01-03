import 'package:flutter/material.dart';

class PhraseDetailScreen extends StatelessWidget {
  final String phrase;
  final String gifPath;

  PhraseDetailScreen({required this.phrase, required this.gifPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phrase: $phrase'),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign for "$phrase"',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(gifPath),
            ],
          ),
        ),
      ),
    );
  }
}
