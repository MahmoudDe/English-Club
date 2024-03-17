// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../controllers/quiz_controller.dart';
import '../../../server/apis.dart';
import '../../../styles/app_colors.dart';
import '../../form_widget copy.dart';

class UpdateSlide extends StatelessWidget {
  UpdateSlide(
      {super.key,
      required this.index,
      required this.testId,
      required this.context});
  final int index;
  final String testId;
  final BuildContext context;
  late TextEditingController currentQuestionMarkController;

  final formKey = GlobalKey<FormState>();

  FocusNode currentQuestionNode = FocusNode();

  FocusNode currentQuestionMarkNode = FocusNode();

  late String allOrNothing;
  void showUpdateDialog(BuildContext context, Size mediaQuery) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Edit current question',
        widget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: FormWidget(
                controller: currentQuestionMarkController,
                textInputType: TextInputType.number,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: mediaQuery,
                textInputAction: TextInputAction.done,
                labelText: 'mark',
                hintText: 'EX: 5',
                focusNode: currentQuestionMarkNode,
                nextNode: currentQuestionMarkNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return "you have to enter current question mark";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: mediaQuery.height / 60,
            ),
            CheckboxListTile(
              value: allOrNothing == '1' ? true : false,
              activeColor: Colors.amber,
              checkColor: Colors.white,
              onChanged: (value) {
                allOrNothing = '1';

                Navigator.pop(context);
                showUpdateDialog(context, mediaQuery);
              },
              title: Text(
                'AllOrNothing',
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 28),
              ),
            ),
            CheckboxListTile(
              value: allOrNothing == '0' ? true : false,
              activeColor: Colors.amber,
              checkColor: Colors.white,
              onChanged: (value) {
                allOrNothing = '0';

                Navigator.pop(context);
                showUpdateDialog(context, mediaQuery);
              },
              title: Text(
                'Normal',
                style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 28),
              ),
            ),
          ],
        ),
        confirmBtnText: 'update',
        confirmBtnColor: Colors.amber,
        onConfirmBtnTap: () async {
          if (formKey.currentState!.validate()) {
            await Provider.of<Apis>(context, listen: false)
                .updateCurrentQuestion(
                    allOrNothing: allOrNothing,
                    mainQuestionId:
                        QuizController.questions[index]['main_id'].toString(),
                    currentQuestionId: QuizController.questions[index]['data']
                            ['id']
                        .toString(),
                    mark: currentQuestionMarkController.text,
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
  }

  @override
  Widget build(BuildContext context1) {
    return SlidableAction(
      onPressed: (con) {
        currentQuestionMarkController = TextEditingController(
          text: QuizController.questions[index]['data']['mark'].toString(),
        );
        allOrNothing =
            QuizController.questions[index]['data']['allOrNothing'].toString();
        showUpdateDialog(context, MediaQuery.of(context).size);
      },
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: 'update',
    );
  }
}
