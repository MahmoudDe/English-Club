import 'package:bdh/background/background.dart';
import 'package:bdh/screens/login/sign_in_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomPaint(
              size: Size(mediaQuery.width,(mediaQuery.width * 0.3).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
              painter: RPSCustomPainter(),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

