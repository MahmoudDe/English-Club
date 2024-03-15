// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:bdh/server/image_url.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/delete_slide.dart';
import 'package:bdh/widgets/quiz_screen/current_question_slides/update_slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../controllers/quiz_controller.dart';
import '../../server/apis.dart';
import '../../styles/app_colors.dart';
import '../form_widget copy.dart';

class CurrentQuestionWidget extends StatefulWidget {
  CurrentQuestionWidget(
      {super.key,
      required this.index,
      required this.mediaQuery,
      required this.testId});
  final String testId;
  final int index;
  final Size mediaQuery;

  @override
  State<CurrentQuestionWidget> createState() => _CurrentQuestionWidgetState();
}

class _CurrentQuestionWidgetState extends State<CurrentQuestionWidget> {
  late TextEditingController currentQuestionController;
  static File? currentQuestionImage;

  final formKey = GlobalKey<FormState>();

  FocusNode currentQuestionNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 1 / 2,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          DeleteSlide(index: widget.index, testId: widget.testId),
          UpdateSlide(
            testId: widget.testId,
            index: widget.index,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context1) {
              currentQuestionController = TextEditingController(
                text: QuizController.questions[widget.index]['data']
                    ['text_url'],
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
                      mediaQuery: widget.mediaQuery,
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
                              mainQuestionId: QuizController
                                  .questions[widget.index]['main_id']
                                  .toString(),
                              currentQuestionId: QuizController
                                  .questions[widget.index]['data']['id']
                                  .toString(),
                              newText: currentQuestionController.text,
                              quizId: widget.testId);
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
          ),
          SlidableAction(
            onPressed: (context1) {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: widget.mediaQuery.height / 5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 5),
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
                                      widget.mediaQuery.height / 80),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.main),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera,
                                    color: AppColors.main,
                                    size: widget.mediaQuery.height / 15,
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
                                      widget.mediaQuery.height / 80),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.main),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    color: AppColors.main,
                                    size: widget.mediaQuery.height / 15,
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
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: Icons.image,
            label: 'image',
          ),
        ],
      ),
      child: Container(
          width: widget.mediaQuery.width / 1.1,
          padding: EdgeInsets.symmetric(
              horizontal: widget.mediaQuery.width / 30,
              vertical: widget.mediaQuery.height / 40),
          margin:
              EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 30),
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              border: Border.all(color: Colors.amber, width: 2)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QuizController.questions[widget.index]['data']['is_image'] == 0
                  ? Text(
                      QuizController.questions[widget.index]['data']
                          ['text_url'],
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.main, fontWeight: FontWeight.bold),
                    )
                  : Image(
                      image: NetworkImage(
                        '${ImageUrl.imageUrl}${QuizController.questions[widget.index]['data']['text_url']}',
                      ),
                      fit: BoxFit.contain,
                    ),
              SizedBox(
                height: widget.mediaQuery.height / 70,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      QuizController.questions[widget.index]['data']
                                  ['allOrNothing'] ==
                              1
                          ? 'All or nothing'
                          : 'Normal',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: widget.mediaQuery.width / 50,
                    ),
                    Text(
                      '(${QuizController.questions[widget.index]['data']['mark'].toString()} marks)',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future pickImageFromGallery(BuildContext context) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    currentQuestionImage = File(returnedImage.path);

    try {
      await Provider.of<Apis>(context, listen: false)
          .changeCurrentQuestionToImage(
        questionImage: currentQuestionImage!,
        mainQuestionId:
            QuizController.questions[widget.index]['main_id'].toString(),
        currentQuestionId:
            QuizController.questions[widget.index]['data']['id'].toString(),
        quizId: widget.testId,
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
    currentQuestionImage = File(returnedImage.path);

    try {
      await Provider.of<Apis>(context, listen: false)
          .changeCurrentQuestionToImage(
        questionImage: currentQuestionImage!,
        mainQuestionId:
            QuizController.questions[widget.index]['main_id'].toString(),
        currentQuestionId:
            QuizController.questions[widget.index]['data']['id'].toString(),
        quizId: widget.testId,
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
