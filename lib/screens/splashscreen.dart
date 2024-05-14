// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:bdh/model/user.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../server/apis.dart';
import 'all_sections_map_roads_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    checkLoginStatus(
      context,
    );
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
            Color.fromRGBO(56, 14, 63, 1),
          ], begin: Alignment.bottomCenter, end: Alignment.topRight),
        ),
        child: const Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> checkLoginStatus(
    BuildContext context,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('------------------------------------stored token');
      print(token);
      print('------------------------------------------------');
      if (token != null) {
        print(token);
        User.userType = prefs.getString('type')!;
        if (User.userType == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavigationScreen()),
            (route) => false,
          );
        } else if (User.userType == 'student') {
          if (await Provider.of<Apis>(context, listen: false)
              .studentHomeScreen(id: '-1')) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AllSectionsMapRoadsScreen(
                    studentData: {
                      'profile_picture': Apis.studentModel!.profilePicture,
                      'name': Apis.studentModel!.name,
                      'id': '-1'
                    },
                    studentId: '-1',
                    allSections: [],
                    mediaQuery: MediaQuery.of(context).size),
              ),
              (route) => false,
            );
          }
        }
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
