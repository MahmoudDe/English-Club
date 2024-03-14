// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../styles/app_colors.dart';
import '../form_widget copy.dart';

class MainQuestionMenuWidget extends StatelessWidget {
  MainQuestionMenuWidget(
      {super.key,
      required this.mediaQuery,
      required this.index,
      required this.testId});
  final Size mediaQuery;
  final int index;
  final String testId;
  late TextEditingController mainQuestionController;
  final formKey = GlobalKey<FormState>();
  static File? mainQuestionImage;

  FocusNode mainQuestionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton<String>(
          offset: Offset(0, mediaQuery.height / 20),
          icon: Icon(
            Icons.menu,
            color: AppColors.main,
          ),
          itemBuilder: (BuildContext context1) {
            return [
              PopupMenuItem<String>(
                value: 'text question',
                child: TextButton.icon(
                  label: Text(
                    'Text question',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.main),
                  ),
                  onPressed: () {
                    Navigator.pop(context1);
                    mainQuestionController = TextEditingController(
                      text: QuizController.questions[index]['main_text_url'],
                    );
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.custom,
                        title: 'Edit section',
                        widget: Form(
                          key: formKey,
                          child: FormWidget(
                            controller: mainQuestionController,
                            textInputType: TextInputType.text,
                            isNormal: true,
                            obscureText: false,
                            togglePasswordVisibility: () {},
                            mediaQuery: mediaQuery,
                            textInputAction: TextInputAction.done,
                            labelText: 'main question',
                            hintText: 'EX: how are you?',
                            focusNode: mainQuestionNode,
                            nextNode: mainQuestionNode,
                            validationFun: (value) {
                              if (value == null || value.isEmpty) {
                                return "you have to enter main question";
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
                                .changeMainQuestionToText(
                                    mainQuestionId: QuizController
                                        .questions[index]['main_id']
                                        .toString(),
                                    newText: mainQuestionController.text,
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
                  icon: Icon(
                    Icons.text_fields,
                    color: AppColors.main,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'Image question',
                child: TextButton.icon(
                  label: Text(
                    'Image question',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.main),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
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
                  },
                  icon: Icon(
                    Icons.image,
                    color: AppColors.main,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: TextButton.icon(
                  label: const Text(
                    'Delete question',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  onPressed: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.warning,
                        text: 'Do you want to delete this main question?',
                        confirmBtnText: 'delete',
                        confirmBtnColor: Colors.red,
                        onConfirmBtnTap: () async {
                          await Provider.of<Apis>(context, listen: false)
                              .deleteMainQuestion(
                                  mainQuestionId: QuizController
                                      .questions[index]['main_id']
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
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Future pickImageFromGallery(BuildContext context) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    mainQuestionImage = File(returnedImage.path);

    try {
      await Provider.of<Apis>(context, listen: false).changeMainQuestionToImage(
        questionImage: mainQuestionImage!,
        mainQuestionId: QuizController.questions[index]['main_id'].toString(),
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
    } catch (e) {
      print(e);
    }
  }

  Future pickImageFromCamera(BuildContext context) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    mainQuestionImage = File(returnedImage.path);

    try {
      await Provider.of<Apis>(context, listen: false).changeMainQuestionToImage(
        questionImage: mainQuestionImage!,
        mainQuestionId: QuizController.questions[index]['main_id'].toString(),
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
    } catch (e) {
      print(e);
    }
  }
}
