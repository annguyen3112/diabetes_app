import 'package:diabetes_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
//import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      // routes: {
      //   '/chatbot': (context) => ChatbotScreen(),
      // },
    );
  }
}
