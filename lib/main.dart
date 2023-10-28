import 'package:bdh/Provider/navigation_controller.dart';
import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/login/login.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          canvasColor: Colors.grey.shade200,
          secondaryHeaderColor: Colors.orange,
          fontFamily: 'Messiri',
        ),
        home: LoginPage(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomeScreen(),
          NavigationScreen.routeName: (context) => const NavigationScreen()
        },
      ),
    );
  }
}
