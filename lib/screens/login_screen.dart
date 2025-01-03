import 'package:flutter/material.dart';
import 'package:sign_learn/components/rounded_button.dart';
import 'package:sign_learn/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sign_learn/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "LoginScreen";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  //Do something with the user input.
                  email = value;
                },
                decoration: kTextFleidDecoration.copyWith(
                    hintText: 'Enter your email address'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                decoration: kTextFleidDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Login',
                onpressed: () async {
                  setState(() {
                    showSpinner = true; // Show the spinner
                  });

                  try {
                    // Attempt to sign in the user
                    await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    // Navigate to the home screen on successful login
                    Navigator.pushNamed(context, HomeScreenController.id);
                  } on FirebaseAuthException catch (e) {
                    // Handle specific FirebaseAuth errors
                    String errorMessage;
                    switch (e.code) {
                      case 'user-not-found':
                        errorMessage = 'No user found for that email.';
                        break;
                      case 'wrong-password':
                        errorMessage = 'Wrong password provided.';
                        break;
                      default:
                        errorMessage =
                            'An unexpected error occurred. Please try again.';
                    }

                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } catch (e) {
                    // Handle general errors
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An unexpected error occurred.')),
                    );
                  } finally {
                    // Ensure spinner is hidden in all cases
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
                tag: 'login',
                color: Colors.lightBlueAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
