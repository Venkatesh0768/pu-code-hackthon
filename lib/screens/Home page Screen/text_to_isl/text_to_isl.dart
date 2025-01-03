import 'package:flutter/material.dart';

class TextToISLScreen extends StatefulWidget {
  const TextToISLScreen({super.key});

  static const id = "text_to_isl";

  @override
  _TextToISLScreenState createState() => _TextToISLScreenState();
}

class _TextToISLScreenState extends State<TextToISLScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _gifPaths = [];
  String _inputText = '';

  // Function to map text to GIF paths
  void _convertTextToISL(String text) {
    _gifPaths.clear();
    _inputText = text; // Store the input text for display

    for (var char in text.toLowerCase().characters) {
      if (RegExp(r'[a-z0-9]').hasMatch(char)) {
        _gifPaths.add('assets/gifs/alphabets/$char.gif');
      } else if (char == ' ') {
        _gifPaths.add('space'); // Add a placeholder for space
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text to Indian Sign Language'),
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
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter Text',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _convertTextToISL(_textController.text);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _gifPaths.isEmpty
                    ? const Center(
                        child: Text(
                          'Enter text to see the ISL sequence!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Word: $_inputText',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: _gifPaths.map((path) {
                                if (path == 'space') {
                                  return const SizedBox(width: 20); // Add space
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Image.asset(
                                    path,
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        'Missing GIF',
                                        style: TextStyle(color: Colors.red),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
