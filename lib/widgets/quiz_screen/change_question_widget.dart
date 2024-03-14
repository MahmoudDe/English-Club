// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';

import '../../controllers/quiz_controller.dart';

class ChangeQuestionWidget extends StatelessWidget {
  ChangeQuestionWidget({
    super.key,
    required this.controller,
    required this.mediaQuery,
  });
  final CarouselController controller;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              controller.previousPage();
              print('..............................................');
              QuizController.test;
              print('..............................................');
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 20,
                  vertical: mediaQuery.height / 40),
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.nextPage();
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 20,
                  vertical: mediaQuery.height / 40),
              decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
