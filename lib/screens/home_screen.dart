import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_learn/screens/Home%20page%20Screen/chat_screen.dart';
import 'package:sign_learn/screens/dictionary_screens/dictionary_screen.dart';
import 'Home page Screen/quiz_screens/quiz_screen.dart';
import 'Home page Screen/text_to_isl/text_to_isl.dart';

class HomeScreenController extends StatefulWidget {
  const HomeScreenController({super.key});

  static const id = "home_screen";

  @override
  State<HomeScreenController> createState() => _HomeScreenControllerState();
}

class _HomeScreenControllerState extends State<HomeScreenController> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName ?? "venkatesh";
      });
    } else {
      setState(() {
        userName = "User not logged in";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Hey',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut().then((_) {
                Navigator.pop(context);
                return Future.value(null);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  SizedBoxHomeScreen(
                    color: Colors.green,
                    icon: Icons.menu_book,
                    label: 'Dictionary',
                    onPressed: () {
                     setState(() {
                        Navigator.pushNamed(context, DictionaryScreen.id);
                     });
                    },
                  ),
                 
                  SizedBoxHomeScreen(
                    color: Colors.red,
                    icon: Icons.video_call,
                    label: 'Video call',
                    onPressed: () {
                      // TODO: Navigate to Video Call Screen
                    },
                  ),
                  SizedBoxHomeScreen(
                      color: Colors.grey[300]!,
                      icon: Icons.chat,
                      label: 'Chats',
                      onPressed: () {
                         Navigator.pushNamed(context, ChatScreen.id);
                      }),
                  SizedBoxHomeScreen(
                    color: Colors.redAccent,
                    icon: Icons.quiz,
                    label: 'Quiz',
                    onPressed: () {
                      Navigator.pushNamed(context, QuizScreen.id);
                    },
                  ),
                  SizedBoxHomeScreen(
                    color: Colors.grey[300]!,
                    icon: Icons.add,
                    label: 'Stats',
                    onPressed: () {
                      Navigator.pushNamed(context, TextToISLScreen.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}



class SizedBoxHomeScreen extends StatelessWidget {
  const SizedBoxHomeScreen(
      {super.key,
      required this.color,
      required this.icon,
      required this.label,
      required this.onPressed});

  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.black,
            ),
            SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
