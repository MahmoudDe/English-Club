// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

// ignore: must_be_immutable
class DeleteGradeClass {
  void deleteGradeClass(
      {required BuildContext context,
      required Size mediaQuery,
      required Function()? onPressed,
      required String removingTitle,
      required bool isGrade,
      required int gradeId,
      required int classId,
      required String name,
      required String warning}) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: removingTitle,
        text: 'Are you sure you want to delete this $name\n$warning',
        confirmBtnText: 'Delete',
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: () async {
          isGrade
              ? await Provider.of<Apis>(context, listen: false)
                  .deleteGrade(grade_id: gradeId.toString())
              : await Provider.of<Apis>(context, listen: false)
                  .deleteClass(class_Id: classId.toString());

          Navigator.of(context).pop();
          Apis.statusResponse == 200
              ? QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  confirmBtnText: 'Cancel',
                  onConfirmBtnTap: onPressed,
                  text: Apis.message)
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
  }
}
