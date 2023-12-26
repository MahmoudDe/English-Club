import 'package:bdh/Provider/navigation_controller.dart';
import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromRGBO(56, 14, 63, 1),
          canvasColor: Colors.grey.shade200,
          fontFamily: 'Avenir',
        ),
        home: const StartScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          NavigationScreen.routeName: (context) => const NavigationScreen()
        },
      ),
    );
  }
}
