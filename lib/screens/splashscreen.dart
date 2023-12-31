// ignore_for_file: unnecessary_null_comparison

import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLoginStatus(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 97, 25, 112),
            const Color.fromRGBO(56, 14, 63, 1),
          ], begin: Alignment.bottomCenter, end: Alignment.topRight),
        ),
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? false;
      if (token != null) {
        print(token);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NavigationScreen()),
          (route) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StartScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
