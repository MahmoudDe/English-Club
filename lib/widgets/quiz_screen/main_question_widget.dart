import 'package:bdh/common/statics.dart';
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
    return SizedBox(
      width: Statics.isPlatformDesktop
          ? mediaQuery.width / 3
          : mediaQuery.width / 1.1,
      child: QuizController.questions[index]['main_is_image'] == 0
          ? Text(
              '${index + 1}.${QuizController.questions[index]['main_text_url']}',
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
