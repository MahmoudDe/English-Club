// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../controllers/quiz_controller.dart';
import '../../../server/apis.dart';

class DeleteSlide extends StatelessWidget {
  const DeleteSlide({super.key, required this.index, required this.testId});
  final int index;
  final String testId;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (context1) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Do you want to delete this current question?',
            confirmBtnText: 'delete',
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: () async {
              await Provider.of<Apis>(context, listen: false)
                  .deleteCurrentQuestion(
                      mainQuestionId:
                          QuizController.questions[index]['main_id'].toString(),
                      currentQuestionId: QuizController.questions[index]['data']
                              ['id']
                          .toString(),
                      quizId: testId);
              Navigator.of(context).pop();
              Apis.statusResponse == 200
                  ? QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      confirmBtnText: 'Ok',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      },
                      text: Apis.message,
                    )
                  : QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: Apis.message,
                      confirmBtnText: 'Cancel',
                      confirmBtnColor: Colors.red,
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                      });
            });
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: 'Delete',
    );
  }
}
