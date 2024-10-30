// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:bdh/model/user.dart';
import 'package:bdh/screens/student_screens/student_result_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../controllers/quiz_controller.dart';

class ChangeQuestionWidget extends StatelessWidget {
  ChangeQuestionWidget(
      {super.key,
      required this.controller,
      required this.mediaQuery,
      required this.controllerNumber,
      required this.storyId,
      required this.subLevelId,
      required this.isLevelTest,
      required this.scrollController,
      required this.levelId,
      required this.activeIndex,
      required this.sectionId});
  final bool isLevelTest;
  final int activeIndex;
  final carousel_slider.CarouselSliderController controller;
  final carousel_slider.CarouselSliderController controllerNumber;
  final ScrollController scrollController;
  final Size mediaQuery;
  final String storyId;
  final String subLevelId;
  final String levelId;
  final String sectionId;

  Future<void> submit(BuildContext context) async {
    try {
      print(subLevelId);
      print(storyId);
      print(QuizController.studentAnswer.length);
      print(QuizController.studentAnswer);
      for (int i = 0; i < QuizController.studentAnswer.length; i++) {
        print('question number $i');
        print(QuizController.studentAnswer[i]);
        print('................................');
      }
      if (isLevelTest) {
        if (await Provider.of<Apis>(context, listen: false)
            .studentSubmitTestLevel(
                sectionId: sectionId,
                levelId: levelId,
                answers: QuizController.studentAnswer)) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentResultScreen(),
              ));
        } else {
          Navigator.pop(context);
          QuickAlert.show(
              context: context, type: QuickAlertType.error, text: Apis.message);
        }
      } else {
        if (await Provider.of<Apis>(context, listen: false).studentSubmitTest(
            subLevelId: subLevelId,
            storyID: storyId,
            answers: QuizController.studentAnswer)) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const StudentResultScreen(),
              ));
        } else {
          Navigator.pop(context);
          QuickAlert.show(
              context: context, type: QuickAlertType.error, text: Apis.message);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();

              scrollController.animateTo(
                  (activeIndex - 1) * MediaQuery.of(context).size.width / 7,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              controller.previousPage();
              controllerNumber.previousPage();
              // controller.
              // QuizController.index++ ;
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
          User.userType != 'student'
              ? const SizedBox()
              : GestureDetector(
                  onTap: () {
                    QuizController.index != QuizController.questions.length - 1
                        ? null
                        : QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            text: 'Do you want to submit your answers ?',
                            onConfirmBtnTap: (() {
                              print('submit');
                              print(QuizController.studentAnswer);

                              Navigator.pop(context);
                              QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.loading,
                                  barrierDismissible: false);
                              submit(context);
                            }));
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 20,
                          vertical: mediaQuery.height / 40),
                      width: mediaQuery.width / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: QuizController.index !=
                                  QuizController.questions.length - 1
                              ? Colors.grey
                              : Colors.blueAccent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              scrollController.animateTo(
                  (activeIndex + 1) * MediaQuery.of(context).size.width / 7,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
              controller.nextPage();
              controllerNumber.nextPage();
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
