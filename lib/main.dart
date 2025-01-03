import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign_learn/firebase_options.dart';
import 'package:sign_learn/screens/Home%20page%20Screen/chat_screen.dart';
import 'package:sign_learn/screens/Home%20page%20Screen/text_to_isl/text_to_isl.dart';
// import 'package:sign_learn/screens/Home%20page%20Screen/quiz_screens/video_upload_screen.
import 'package:sign_learn/screens/dictionary_screens/dictionary_screen.dart';
import 'package:sign_learn/screens/Home page Screen/quiz_screens/quiz_screen.dart';
import 'package:sign_learn/screens/home_screen.dart';
import 'package:sign_learn/screens/login_screen.dart';
import 'package:sign_learn/screens/registration_screen.dart';
import 'package:sign_learn/screens/welcome_screen.dart';
// import 'package:sign_learn/screens/quiz_screens/video_upload_screen.dart';
void main()async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreenController(),
      initialRoute: HomeScreenController.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreenController.id: (context) => HomeScreenController(),
        DictionaryScreen.id: (context) => DictionaryScreen(),
        QuizScreen.id: (context) => QuizScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        TextToISLScreen.id: (context) => TextToISLScreen(),
        
        
        // ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}