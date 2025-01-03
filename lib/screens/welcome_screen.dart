import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:sign_learn/components/rounded_button.dart';
import 'package:sign_learn/screens/login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static String id = "welcome_screen";

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    animation =
        ColorTween(begin: Colors.blue, end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(animatedTexts: [
                  TyperAnimatedText('Sign Bridge',
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w900,
                      )),
                ]),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(text: "LogIn", onpressed: (){
              // Navigator.pushNamed(context, 'login_screen');
              Navigator.pushNamed(context, LoginScreen.id);
            }, tag: 'login' , color: Colors.lightBlueAccent,),

            RoundedButton(text: "Register", onpressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, tag: 'registerButton', color: Colors.blueAccent,)
          ],
        ),
      ),


    );
  }
}


