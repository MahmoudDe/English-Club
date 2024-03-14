import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';

import '../../controllers/quiz_controller.dart';
import '../../styles/app_colors.dart';

class CurrentQuestionWidget extends StatelessWidget {
  const CurrentQuestionWidget(
      {super.key, required this.index, required this.mediaQuery});
  final int index;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQuery.width / 1.1,
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 30, vertical: mediaQuery.height / 40),
      margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 30),
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.amber, width: 2)),
      child: QuizController.questions[index]['data']['is_image'] == 0
          ? Text(
              QuizController.questions[index]['data']['text_url'],
              softWrap: true,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.main, fontWeight: FontWeight.bold),
            )
          : Image(
              image: NetworkImage(
                '${ImageUrl.imageUrl}${QuizController.questions[index]['data']['text_url']}',
              ),
              fit: BoxFit.contain,
            ),
    );
  }
}
