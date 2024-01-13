// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

// ignore: must_be_immutable
class EditGradeClass {
  FocusNode nameNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  void editGradeClass({
    required BuildContext context,
    required Size mediaQuery,
    required Function()? onPressed,
    required String EditingTitle,
    required bool isGrade,
    required int gradeId,
    required int classId,
    required String labelText,
    required String hintText,
    required String onTextFiledEmptyErrorText,
  }) {
    String name = '';
    QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: EditingTitle,
        widget: Form(
          key: formKey,
          child: FormWidget(
            textInputType: TextInputType.text,
            isNormal: true,
            obscureText: false,
            togglePasswordVisibility: () {},
            mediaQuery: mediaQuery,
            textInputAction: TextInputAction.done,
            labelText: labelText,
            hintText: hintText,
            focusNode: nameNode,
            nextNode: nameNode,
            validationFun: (value) {
              if (value == null || value.isEmpty) {
                return onTextFiledEmptyErrorText;
              }
              name = value;
              return null;
            },
          ),
        ),
        confirmBtnText: 'Edit',
        confirmBtnColor: Colors.amber,
        onConfirmBtnTap: () async {
          if (formKey.currentState!.validate()) {
            isGrade
                ? await Provider.of<Apis>(context, listen: false)
                    .editGrade(newName: name, grade_id: gradeId.toString())
                : await Provider.of<Apis>(context, listen: false).editClass(
                    newName: name,
                    class_Id: classId.toString(),
                    grade_id: gradeId.toString());

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
          }
        });
  }
}
