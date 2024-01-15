import 'dart:io';

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';

import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UploadExcelScreen extends StatefulWidget {
  const UploadExcelScreen({super.key});

  @override
  State<UploadExcelScreen> createState() => _UploadExcelScreenState();
}

class _UploadExcelScreenState extends State<UploadExcelScreen> {
  List gradesName = [];
  String selectedGradeFilterValue = '';
  int selectedGradeId = 0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool didSelectFile = false;
  String excelFileName = '';
  File? exclFile;
  bool isUploading = false;

  void getData() {
    setState(() {
      for (int i = 0; i < dataClass.grades.length; i++) {
        gradesName.add(dataClass.grades[i]['name']);
      }
      selectedGradeFilterValue = gradesName[0];
      selectedGradeId = dataClass.grades[0]['id'];
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> openFilePicker() async {
    bool isOk = await Permission.storage.status.isGranted;
    if (!isOk) {
      await Permission.storage.request();
    }
    print('is ok = $isOk');
    print(await Permission.storage.status.isGranted);
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        exclFile = File(resultFile.files.single.path!);
        excelFileName = resultFile.names.toString();
        didSelectFile = true;
      });
    }
  }

  Future<void> uploadDta() async {
    setState(() {
      isUploading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false)
          .uploadData(exclFile!, selectedGradeId);
      setState(() {
        isUploading = false;
        Navigator.pop(context);
        if (Apis.statusResponse == 200) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text:
                'You will find the response file in download file in your internal storage',
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
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Select grade',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FilterWidget(
                mediaQuery: mediaQuery,
                value: selectedGradeFilterValue,
                width: mediaQuery.width / 2.3,
                onChanged: (newValue) {
                  setState(() {
                    print(newValue);
                    selectedGradeFilterValue = newValue!;
                    print(selectedGradeFilterValue);
                    selectedGradeId = dataClass.grades
                        .where((element) => element['name'] == newValue)
                        .toList()[0]['id'];
                    print(selectedGradeId);
                  });
                },
                menu: gradesName,
                filterTitle: 'Grade'),
            SizedBox(
              height: mediaQuery.height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    openFilePicker();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
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
              height: mediaQuery.height / 30,
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (exclFile == null) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text:
                        'You have to pick an excel file before uploading data!',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  uploadDta();
                  if (isUploading) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.loading,
                      text: 'Uploading data...',
                      barrierDismissible: false,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(primary: AppColors.main),
              icon: const Icon(
                Icons.upload,
                color: Colors.white,
              ),
              label: const Text(
                'Upload excel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
