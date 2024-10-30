// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bdh/common/dialogs/dialogs.dart';
import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/screens/show_book_details_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/form_widget%20copy.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quickalert/quickalert.dart';

import '../../screens/english_club_settings_screen.dart';

class FloatButtonWidget extends StatelessWidget {
  FloatButtonWidget({
    super.key,
    required this.mediaQuery,
    required this.levelName,
    required this.testId,
    required this.subLevelName,
  });
  final String testId;
  final String levelName;
  final String subLevelName;
  final Size mediaQuery;
  FocusNode titleNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  FocusNode quantityNode = FocusNode();
  TextEditingController quantityController = TextEditingController();
  FocusNode borrowNode = FocusNode();
  TextEditingController borrowController = TextEditingController();

  FocusNode subQuestionsNode = FocusNode();
  TextEditingController subQuestionsController = TextEditingController();
  int isDeleteQuestion = 0;
  bool didSelectFile = false;
  String excelFileName = '';
  File? exclFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showDialogFun(BuildContext context) {
    showDialog(
      context: context,
      builder: (context1) => AlertDialog(
        backgroundColor: Colors.white54,
        title: const Text(
          'Edit sotry',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormWidget(
                    mediaQuery: mediaQuery,
                    labelText: 'title',
                    hintText: 'Enter title',
                    focusNode: titleNode,
                    nextNode: quantityNode,
                    validationFun: (value) {
                      if (value!.isEmpty) {
                        return 'You have to enter title';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    isNormal: true,
                    obscureText: false,
                    textInputType: TextInputType.name,
                    controller: titleController),
                SizedBox(
                  height: mediaQuery.height / 60,
                ),
                FormWidget(
                    mediaQuery: mediaQuery,
                    labelText: 'subQuestions',
                    hintText: 'Enter subQuestions',
                    focusNode: subQuestionsNode,
                    nextNode: quantityNode,
                    validationFun: (value) {
                      if (value!.isEmpty) {
                        return 'You have to enter number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    isNormal: true,
                    obscureText: false,
                    textInputType: TextInputType.number,
                    controller: subQuestionsController),
                SizedBox(
                  height: mediaQuery.height / 60,
                ),
                FormWidget(
                    mediaQuery: mediaQuery,
                    labelText: 'quantity',
                    hintText: 'Enter quantity',
                    focusNode: quantityNode,
                    nextNode: borrowNode,
                    validationFun: (value) {
                      if (value!.isEmpty) {
                        return 'You have to enter number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    isNormal: true,
                    obscureText: false,
                    textInputType: TextInputType.number,
                    controller: quantityController),
                SizedBox(
                  height: mediaQuery.height / 60,
                ),
                FormWidget(
                    mediaQuery: mediaQuery,
                    labelText: 'borrow',
                    hintText: 'Enter allow borrow days',
                    focusNode: borrowNode,
                    nextNode: borrowNode,
                    validationFun: (value) {
                      if (value!.isEmpty) {
                        return 'You have to enter number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    isNormal: true,
                    obscureText: false,
                    textInputType: TextInputType.number,
                    controller: borrowController),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        QuickAlert.show(
                            context: context,
                            type: QuickAlertType.loading,
                            barrierDismissible: false);
                        if (await Provider.of<Apis>(context, listen: false)
                            .updateStory(
                          storyId:
                              showBookController.bookData[0]['id'].toString(),
                          subLevelId: showBookController.bookData[0]
                                  ['sub_level_id']
                              .toString(),
                          title: titleController.text,
                          test_subQuestions_count: subQuestionsController.text,
                          allowed_borrow_days: borrowController.text,
                          quantity: quantityController.text,
                        )) {
                          Navigator.of(context).pop();
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: Apis.message,
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => ShowBookDetailsScreen(
                                    bookId: showBookController.bookData[0]['id']
                                        .toString(),
                                    subLevelId: showBookController.bookData[0]
                                            ['sub_level_id']
                                        .toString(),
                                    subLevelName: subLevelName,
                                    levelName: levelName),
                              ));
                            },
                          );
                        } else {
                          Navigator.pop(context);
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: Apis.message);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openFilePicker(BuildContext context) async {
    bool isOk = await Permission.storage.status.isGranted;
    if (!isOk) {
      await Permission.storage.request();
    }
    print('is ok = $isOk');
    print(await Permission.storage.status.isGranted);
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      exclFile = File(resultFile.files.single.path!);
      excelFileName = resultFile.names.toString();
      didSelectFile = true;
      Navigator.pop(context);
      showUploadExcel(context);
    }
  }

  Future<void> uploadDta(BuildContext context) async {
    try {
      await Provider.of<Apis>(context, listen: false).changeQuestion(
        exclFile: exclFile!,
        deletePreviousQuestions: isDeleteQuestion.toString(),
        testId: testId,
      );
      Navigator.pop(context);
      Navigator.pop(context);
      if (Apis.statusResponse == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: Apis.message,
          confirmBtnText: 'Ok',
        );
      } else if (Apis.statusResponse != 200) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: Apis.message,
            confirmBtnText: 'Cancel');
      } else {
        print('hello');
      }
    } catch (e) {
      print(e);
    }
  }

  void showUploadExcel(BuildContext context) {
    AwesomeDialog(
        context: context,
        body: Column(
          children: [
            CheckboxListTile(
              value: isDeleteQuestion == 0 ? false : true,
              title: Text(
                'delete previous questions',
                style: TextStyle(
                    color: AppColors.main, fontWeight: FontWeight.bold),
              ),
              onChanged: (value) {
                isDeleteQuestion == 0
                    ? isDeleteQuestion = 1
                    : isDeleteQuestion = 0;
                Navigator.pop(context);
                showUploadExcel(context);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    openFilePicker(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'excel file',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                didSelectFile
                    ? SizedBox(
                        width: mediaQuery.width / 30,
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                didSelectFile
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.width / 30,
                            vertical: mediaQuery.height / 100),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.main, width: 2),
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        child: Text(
                          excelFileName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ))
                    : const SizedBox(
                        width: 0,
                      )
              ],
            ),
            SizedBox(
              height: mediaQuery.height / 70,
            ),
            ElevatedButton(
              onPressed: () {
                uploadDta(context);
                loadingDialog(context: context, mediaQuery: mediaQuery);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 10,
                    vertical: mediaQuery.height / 40),
                child: Text(
                  'Upload data',
                  style: TextStyle(color: AppColors.main),
                ),
              ),
            ),
            SizedBox(
              height: mediaQuery.height / 70,
            ),
          ],
        )).show();
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      backgroundColor: AppColors.mainLight,
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          label: 'delete',
          backgroundColor: Colors.red,
          onTap: (() {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text: 'Do you want to delete this story?',
                confirmBtnColor: Colors.amber,
                confirmBtnText: 'Yes',
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                  if (showBookController().deleteStory() == false) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: showBookController.message,
                    );
                  } else {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: showBookController.message,
                        onConfirmBtnTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                const EnglishClubSettingsScreen(),
                          ));
                        });
                  }
                });
          }),
        ),
        SpeedDialChild(
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          label: 'edit',
          backgroundColor: Colors.amber,
          onTap: (() {
            titleController = TextEditingController(
                text: showBookController.bookData[0]['title'].toString());
            quantityController = TextEditingController(
                text: showBookController.bookData[0]['quantity'].toString());
            borrowController = TextEditingController(
                text: showBookController.bookData[0]['allowed_borrow_days']
                    .toString());

            showDialogFun(context);
          }),
        ),
        SpeedDialChild(
          onTap: () => showUploadExcel(context),
          child: const Icon(
            Icons.upload,
            color: Colors.white,
          ),
          label: 'upload',
          backgroundColor: Colors.amber,
        ),
      ],
    );
  }
}

// GestureDetector(
//       onTap: () {
      
//       },
//       child: Container(
//         height: mediaQuery.height / 10,
//         width: mediaQuery.width / 6,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.amber,
//         ),
//         child: const Icon(
//           Icons.edit,
//           color: Colors.white,
//         ),
//       ),
//     );
  
