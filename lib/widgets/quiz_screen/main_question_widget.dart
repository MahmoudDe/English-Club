import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';

import '../../controllers/quiz_controller.dart';
import '../../styles/app_colors.dart';

class MainQuestionWidget extends StatelessWidget {
  const MainQuestionWidget(
      {super.key, required this.index, required this.mediaQuery});
  final int index;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQuery.width / 1.1,
      child: QuizController.questions[index]['main_is_image'] == 0
          ? Text(
              QuizController.questions[index]['main_text_url'],
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
