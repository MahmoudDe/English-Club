import 'dart:async';

import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/student_result_screen/final_result_widget.dart';
import 'package:bdh/widgets/student_result_screen/result_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StudentResultScreen extends StatefulWidget {
  const StudentResultScreen({super.key, required this.storyTitle});
  final String storyTitle;
  @override
  State<StudentResultScreen> createState() => _StudentResultScreenState();
}

class _StudentResultScreenState extends State<StudentResultScreen> {
  bool isPointTimeEnd = false;
  bool isNewScoreTimeStart = false;
  bool isFeedBackTimeStart = false;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isPointTimeEnd = true;
      });
    });
    Timer(const Duration(seconds: 4), () {
      setState(() {
        isNewScoreTimeStart = true;
      });
    });
    Timer(const Duration(seconds: 8), () {
      setState(() {
        isFeedBackTimeStart = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image(
              image: AssetImage('assets/images/test.png'),
              fit: BoxFit.fill,
            ),
          ),
          Apis.studentResultBookTest['evaluation'] != 'Fail'
              ? Lottie.asset('assets/lotties/celebrate.json')
              : const SizedBox(
                  width: 0,
                ),
          ResultTextWidget(
              isPointTimeEnd: isPointTimeEnd,
              mediaQuery: mediaQuery,
              result: Apis.studentResultBookTest['evaluation']),
          UserNewPointsWidget(
            storyTitle: widget.storyTitle,
            isNewScoreTimeStart: isNewScoreTimeStart,
            mediaQuery: mediaQuery,
            result: Apis.studentResultBookTest,
          )
        ],
      ),
    );
  }
}
