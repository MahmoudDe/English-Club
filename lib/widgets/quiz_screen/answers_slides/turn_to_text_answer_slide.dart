// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../controllers/quiz_controller.dart';
import '../../../server/apis.dart';
import '../../../styles/app_colors.dart';
import '../../form_widget copy.dart';

class TurnToTextAnswerSlide extends StatefulWidget {
  TurnToTextAnswerSlide(
      {super.key,
      required this.index,
      required this.testId,
      required this.context,
      required this.answerIndex});
  BuildContext context;
  final int answerIndex;
  final String testId;
  final int index;

  @override
  State<TurnToTextAnswerSlide> createState() => _TurnToTextAnswerSlideState();
}

class _TurnToTextAnswerSlideState extends State<TurnToTextAnswerSlide> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController currentQuestionController;

  FocusNode currentQuestionNode = FocusNode();

  late int isCorrect;

  void showDialogTextAnswer() {
    QuickAlert.show(
        context: widget.context,
        type: QuickAlertType.custom,
        title: 'Edit section',
        widget: Column(
          children: [
            CheckboxListTile(
              value: isCorrect == 0 ? false : true,
              title: const Text(
                'Is the answer correct',
                style: TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                isCorrect == 0 ? isCorrect = 1 : isCorrect = 0;
                Navigator.pop(widget.context);
                showDialogTextAnswer();
              },
            ),
            Form(
              key: formKey,
              child: FormWidget(
                controller: currentQuestionController,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: MediaQuery.of(widget.context).size,
                textInputAction: TextInputAction.done,
                labelText: 'current question',
                hintText: 'EX: how are you?',
                focusNode: currentQuestionNode,
                nextNode: currentQuestionNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return "you have to enter current question";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        confirmBtnText: 'change',
        confirmBtnColor: Colors.amber,
        onConfirmBtnTap: () async {
          if (formKey.currentState!.validate()) {
            await Provider.of<Apis>(widget.context, listen: false)
                .changeAnswerToText(
              is_correct: isCorrect.toString(),
              answerId: QuizController.questions[widget.index]['data']
                      ['answers'][widget.answerIndex]['id']
                  .toString(),
              currentQuestionId: QuizController.questions[widget.index]['data']
                      ['id']
                  .toString(),
              newText: currentQuestionController.text,
              quizId: widget.testId,
            );
            Navigator.of(widget.context).pop();
            Apis.statusResponse == 200
                ? QuickAlert.show(
                    context: widget.context,
                    type: QuickAlertType.success,
                    confirmBtnText: 'Ok',
                    onConfirmBtnTap: () {
                      Navigator.pop(widget.context);
                    },
                    text: Apis.message,
                  )
                : QuickAlert.show(
                    context: widget.context,
                    type: QuickAlertType.error,
                    text: Apis.message,
                    confirmBtnText: 'Cancel',
                    confirmBtnColor: Colors.red,
                    onConfirmBtnTap: () {
                      Navigator.pop(widget.context);
                    });
          }
        });
  }

  @override
  Widget build(BuildContext cont) {
    return SlidableAction(
      onPressed: (context154) {
        currentQuestionController = TextEditingController(
          text: QuizController.questions[widget.index]['data']['answers']
              [widget.answerIndex]['text_url'],
        );
        isCorrect = QuizController.questions[widget.index]['data']['answers']
            [widget.answerIndex]['is_correct'];
        showDialogTextAnswer();
      },
      backgroundColor: AppColors.main,
      foregroundColor: Colors.white,
      icon: Icons.text_fields,
      label: 'text',
    );
  }
}
