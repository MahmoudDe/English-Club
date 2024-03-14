import 'package:bdh/server/apis.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/quiz_controller.dart';
import '../widgets/quiz_screen/cancel_widget.dart';
import '../widgets/quiz_screen/change_question_widget.dart';
import '../widgets/quiz_screen/indicator_widget.dart';
import '../widgets/quiz_screen/question_widget.dart';

class AdminQuizScreen extends StatefulWidget {
  AdminQuizScreen({super.key, required this.testId});
  final String testId;

  @override
  State<AdminQuizScreen> createState() => _AdminQuizScreenState();
}

class _AdminQuizScreenState extends State<AdminQuizScreen> {
  final controller = CarouselController();
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false)
          .getAdminQuiz(quizId: widget.testId);
      print('..............................................');
      QuizController.questions;
      print('..............................................');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: CancelWidget(mediaQuery: mediaQuery),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: const Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image(
                    image: AssetImage('assets/images/test.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: CancelWidget(mediaQuery: mediaQuery),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Stack(
              children: [
                const SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image(
                    image: AssetImage('assets/images/test.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: mediaQuery.height / 10,
                      ),
                      CarouselSlider.builder(
                        options: CarouselOptions(
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            initialPage: 0,
                            height: mediaQuery.height / 1.3,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                QuizController.index = index;
                              });
                            },
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false),
                        carouselController: controller,
                        itemCount: QuizController.questions.length,
                        itemBuilder: (context, index, realIndex) {
                          return QuestionWidget(
                            testId: widget.testId,
                            index: index,
                            mediaQuery: mediaQuery,
                          );
                        },
                      ),
                      SizedBox(
                        height: mediaQuery.height / 100,
                      ),
                      IndicatorWidget(
                          controller: controller,
                          activeIndex: QuizController.index,
                          count: QuizController.questions.length),
                      SizedBox(
                        height: mediaQuery.height / 100,
                      ),
                      ChangeQuestionWidget(
                        controller: controller,
                        mediaQuery: mediaQuery,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
