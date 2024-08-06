import 'package:diabetes_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
// import 'database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      // routes: {
      //   '/chatbot': (context) => ChatbotScreen(),
      // },
    );
  }
}
