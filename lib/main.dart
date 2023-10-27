import 'package:bdh/Provider/navigation_controller.dart';
import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/SearchPage.dart';
import 'screens/Settings.dart';
import 'screens/statics/navBar.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          canvasColor: Colors.grey.shade200,
          secondaryHeaderColor: Colors.orange,
          fontFamily: 'Messiri',
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => Consumer<NavigationController>(
            builder: (context, navigationController, child) {
              return Scaffold(
                body: IndexedStack(
                  index: navigationController.currentIndex,
                  children: <Widget>[
                    HomeScreen(),
                    SearchScreen(),
                    SettingsScreen(),
                  ],
                ),
                bottomNavigationBar: NavBar(
                    navigationController.changePage, navigationController.currentIndex),
              );
            },
          ),
        },
      ),
    );
  }
}
