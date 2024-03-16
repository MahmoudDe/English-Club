// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../controllers/quiz_controller.dart';
import '../../server/apis.dart';
import '../../styles/app_colors.dart';
import '../form_widget copy.dart';

class AddNewAnswerButtonWidget extends StatelessWidget {
  AddNewAnswerButtonWidget(
      {super.key,
      required this.mediaQuery,
      required this.testId,
      required this.index});
  final String testId;
  final int index;
  final Size mediaQuery;
  TextEditingController newAnswerController = TextEditingController();
  FocusNode newAnswerNode = FocusNode();
  int isImage = 0;
  int isCorrect = 0;
  final formKey = GlobalKey<FormState>();
  File? answerImage;

  void answerDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      body: Column(
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
              Navigator.pop(context);
              answerDialog(context);
            },
          ),
          isImage == 0
              ? Form(
                  key: formKey,
                  child: FormWidget(
                    controller: newAnswerController,
                    textInputType: TextInputType.text,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: mediaQuery,
                    textInputAction: TextInputAction.done,
                    labelText: 'new answer',
                    hintText: 'EX: first answer',
                    focusNode: newAnswerNode,
                    nextNode: newAnswerNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return "you have to enter answer";
                      }
                      return null;
                    },
                  ),
                )
              : GestureDetector(
                  onTap: (() {
                    showModalBottomSheet(
                      context: context,
                      builder: (context1) {
                        return SizedBox(
                          height: mediaQuery.height / 5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.width / 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    pickImageFromCamera(context);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            mediaQuery.height / 80),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: AppColors.main),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera,
                                          color: AppColors.main,
                                          size: mediaQuery.height / 15,
                                        ),
                                      ),
                                      Text(
                                        'Camera',
                                        style: TextStyle(
                                            color: AppColors.main,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pickImageFromGallery(context);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(
                                            mediaQuery.height / 80),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: AppColors.main),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          color: AppColors.main,
                                          size: mediaQuery.height / 15,
                                        ),
                                      ),
                                      Text(
                                        'Gallery',
                                        style: TextStyle(
                                            color: AppColors.main,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  child: Container(
                    margin: EdgeInsets.only(left: mediaQuery.width / 40),
                    alignment: Alignment.center,
                    height: mediaQuery.height / 3.5,
                    width: mediaQuery.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Colors.white,
                      border: Border.all(color: Colors.amber, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: answerImage != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            child: Image.file(
                              answerImage!,
                              fit: BoxFit.fill,
                            ),
                          )
                        : const Center(
                            child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.amber,
                              ),
                              Text(
                                'Add an image',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                  ),
                ),
          SizedBox(
            height: mediaQuery.height / 50,
          ),
          ElevatedButton(
            onPressed: () async {
              if (isImage == 0) {
                if (formKey.currentState!.validate()) {
                  await Provider.of<Apis>(context, listen: false)
                      .addNewTextAnswer(
                          currentQuestionId: QuizController.questions[index]
                                  ['data']['id']
                              .toString(),
                          is_correct: isCorrect.toString(),
                          is_image: '0',
                          text: newAnswerController.text,
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
              } else {
                await Provider.of<Apis>(context, listen: false)
                    .addNewImageAnswer(
                  is_image: '1',
                  is_correct: isCorrect.toString(),
                  answerImage: answerImage!,
                  currentQuestionId:
                      QuizController.questions[index]['data']['id'].toString(),
                  quizId: testId,
                );
                Navigator.pop(context);
                if (Apis.statusResponse != 200) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: Apis.message,
                  );
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: Apis.message,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 8,
                  vertical: mediaQuery.height / 60),
            ),
            child: const Text(
              'add answer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 70,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 6,
                  vertical: mediaQuery.height / 60),
            ),
            child: const Text(
              'cancel',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ).show();
  }

  void showAnswerTypeDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              isImage = 1;
              Navigator.pop(context);
              answerDialog(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 5,
                  vertical: mediaQuery.height / 60),
            ),
            child: const Text(
              'Image answer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          ElevatedButton(
            onPressed: () {
              isImage = 0;
              Navigator.pop(context);
              answerDialog(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 5,
                  vertical: mediaQuery.height / 60),
            ),
            child: const Text(
              'Text answer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
        ],
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAnswerTypeDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.width / 5, vertical: mediaQuery.height / 60),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: AppColors.main,
        ),
        child: const Text(
          'Add new answer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> pickImageFromGallery(BuildContext context2) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    answerImage = File(returnedImage.path);
    Navigator.pop(context2);
    Navigator.pop(context2);
    answerDialog(context2);
  }

  Future<void> pickImageFromCamera(BuildContext context2) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    answerImage = File(returnedImage.path);
    Navigator.pop(context2);
    Navigator.pop(context2);
    answerDialog(context2);
  }
}
