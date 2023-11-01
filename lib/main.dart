import 'package:bdh/Provider/navigation_controller.dart';
import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/login/login.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  runApp(MyApp(
    initialRoute: token == null ? '/login' : NavigationScreen.routeName,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

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
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomeScreen(),
          NavigationScreen.routeName: (context) => const NavigationScreen()
        },
      ),
    );
  }
}
