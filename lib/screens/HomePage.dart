import 'package:bdh/screens/statics/appBar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Text(' Home Screen!'),
      ),
    );
  }
}
