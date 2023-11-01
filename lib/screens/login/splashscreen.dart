import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import 'login.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkLoginStatus(context);
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    }
  }

}
