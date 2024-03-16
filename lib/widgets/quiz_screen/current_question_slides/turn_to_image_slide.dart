// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../controllers/quiz_controller.dart';
import '../../../server/apis.dart';
import '../../../styles/app_colors.dart';

class TurnToImageSlide extends StatelessWidget {
  TurnToImageSlide(
      {super.key,
      required this.index,
      required this.testId,
      required this.mediaQuery});
  final String testId;
  final Size mediaQuery;
  final int index;
  static File? currentQuestionImage;

  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      onPressed: (context1) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: mediaQuery.height / 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 5),
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
                            padding: EdgeInsets.all(mediaQuery.height / 80),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.main),
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
                            padding: EdgeInsets.all(mediaQuery.height / 80),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.main),
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
      backgroundColor: Colors.amber,
      foregroundColor: Colors.white,
      icon: Icons.image,
      label: 'image',
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
        mainQuestionId: QuizController.questions[index]['main_id'].toString(),
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
        mainQuestionId: QuizController.questions[index]['main_id'].toString(),
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
    } catch (e) {
      print(e);
    }
  }
}
