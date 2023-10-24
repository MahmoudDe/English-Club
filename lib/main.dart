import 'package:bdh/screens/login/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        canvasColor: Colors.grey.shade200,
        secondaryHeaderColor: Colors.orange,
        fontFamily: 'Messiri',
      ),
      home: LoginPage(),
    );
  }
}
