// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../controllers/quiz_controller.dart';
import '../../../server/apis.dart';
import '../../../styles/app_colors.dart';
import '../../form_widget copy.dart';

class TurnToTextSlide extends StatelessWidget {
  TurnToTextSlide(
      {super.key,
      required this.index,
      required this.testId,
      required this.context});
  BuildContext context;
  final String testId;
  final int index;
  final formKey = GlobalKey<FormState>();
  late TextEditingController currentQuestionController;
  FocusNode currentQuestionNode = FocusNode();
  @override
  Widget build(BuildContext cont) {
    return SlidableAction(
      onPressed: (context154) {
        currentQuestionController = TextEditingController(
          text: QuizController.questions[index]['data']['text_url'],
        );
        QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            title: 'Edit section',
            widget: Form(
              key: formKey,
              child: FormWidget(
                controller: currentQuestionController,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: MediaQuery.of(context).size,
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
            confirmBtnText: 'change',
            confirmBtnColor: Colors.amber,
            onConfirmBtnTap: () async {
              if (formKey.currentState!.validate()) {
                await Provider.of<Apis>(context, listen: false)
                    .changeCurrentQuestionToText(
                        mainQuestionId: QuizController.questions[index]
                                ['main_id']
                            .toString(),
                        currentQuestionId: QuizController.questions[index]
                                ['data']['id']
                            .toString(),
                        newText: currentQuestionController.text,
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
              }
            });
      },
      backgroundColor: AppColors.main,
      foregroundColor: Colors.white,
      icon: Icons.text_fields,
      label: 'text',
    );
  }
}
