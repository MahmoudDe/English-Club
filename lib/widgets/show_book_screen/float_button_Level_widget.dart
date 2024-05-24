// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:quickalert/quickalert.dart';

class FloatButtonLevelWidget extends StatelessWidget {
  FloatButtonLevelWidget({
    super.key,
    required this.mediaQuery,
    required this.testId,
  });
  final String testId;
  final Size mediaQuery;

  int isDeleteQuestion = 0;
  bool didSelectFile = false;
  String excelFileName = '';
  File? exclFile;

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
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 10,
                    vertical: mediaQuery.height / 40),
                child: const Text(
                  'Upload data',
                  style: TextStyle(color: Colors.white),
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
  
