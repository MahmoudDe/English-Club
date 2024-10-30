import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';

import '../../controllers/quiz_controller.dart';
import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class MainQuestionWidget extends StatelessWidget {
  MainQuestionWidget(
      {super.key,
      required this.index,
      required this.mediaQuery,
      required this.startIndex});
  final int index;
  final Size mediaQuery;
  int startIndex;

  @override
  Widget build(BuildContext context) {
    index == 0 ||
            QuizController.questions[index]['main_text_url'] ==
                QuizController.questions[index - 1]['main_text_url']
        ? QuizController.startIndex = QuizController.startIndex
        : QuizController.startIndex++;
    return SizedBox(
      width: mediaQuery.width / 1.1,
      child: QuizController.questions[index]['main_is_image'] == 0
          ? Text(
              '${QuizController.startIndex}.${QuizController.questions[index]['main_text_url']}',
              softWrap: true,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.main, fontWeight: FontWeight.bold),
            )
          : Image(
              image: NetworkImage(
                '${ImageUrl.imageUrl}${QuizController.questions[index]['main_text_url']}',
              ),
              fit: BoxFit.contain,
            ),
    );
  }
}
