import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UpdateSlide extends StatelessWidget {
  const UpdateSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (con) {
        currentQuestionMarkController = TextEditingController(
          text:
              QuizController.questions[widget.index]['data']['mark'].toString(),
        );
        allOrNothing = QuizController.questions[widget.index]['data']
                ['allOrNothing']
            .toString();
        showUpdateDialog();
      },
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'update',
    );
  }
}
