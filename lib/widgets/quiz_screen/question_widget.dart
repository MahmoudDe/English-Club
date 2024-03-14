// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/quiz_screen/answers_widget.dart';
import 'package:bdh/widgets/quiz_screen/current_question_widget.dart';
import 'package:bdh/widgets/quiz_screen/main_question_widget.dart';
import 'package:bdh/widgets/quiz_screen/mian_question_menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../../styles/app_colors.dart';

class QuestionWidget extends StatelessWidget {
  QuestionWidget({
    super.key,
    required this.mediaQuery,
    required this.index,
    required this.testId,
  });
  final Size mediaQuery;
  final String testId;
  int newQuestionIndex = 0;
  int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<Apis>(
      builder: (context, value, child) => Container(
        // margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 100),
        height: mediaQuery.height / 1.3,
        width: mediaQuery.width / 1.1,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.amber, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              MainQuestionMenuWidget(
                mediaQuery: mediaQuery,
                index: index,
                testId: testId,
              ),
              SizedBox(
                height: mediaQuery.height / 100,
              ),
              MainQuestionWidget(index: index, mediaQuery: mediaQuery),
              SizedBox(
                height: mediaQuery.height / 40,
              ),
              CurrentQuestionWidget(index: index, mediaQuery: mediaQuery),
              SizedBox(
                height: mediaQuery.height / 40,
              ),
              AnswersWidget(index: index, mediaQuery: mediaQuery)
            ],
          ),
        ),
      ),
    );
  }
}
