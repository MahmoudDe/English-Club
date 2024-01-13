// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../form_widget copy.dart';

// ignore: must_be_immutable
class AddGradeClassBtnWidget extends StatefulWidget {
  AddGradeClassBtnWidget(
      {super.key,
      required this.mediaQuery,
      required this.onPressed,
      required this.addingTitle,
      required this.labelText,
      required this.hintText,
      required this.onTextFiledEmptyErrorText,
      required this.dialogLabelText,
      required this.isGrade,
      required this.gradeId,
      required this.backgroundBtnColor});
  Size mediaQuery;
  void Function()? onPressed;
  final String addingTitle;
  final String labelText;
  final String hintText;
  final String onTextFiledEmptyErrorText;
  final Widget dialogLabelText;
  final bool isGrade;
  final int gradeId;
  final Color? backgroundBtnColor;
  @override
  State<AddGradeClassBtnWidget> createState() => _AddGradeClassBtnWidgetState();
}

class _AddGradeClassBtnWidgetState extends State<AddGradeClassBtnWidget> {
  String name = '';
  FocusNode nameNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            title: widget.addingTitle,
            widget: Form(
              key: formKey,
              child: FormWidget(
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.done,
                labelText: widget.labelText,
                hintText: widget.hintText,
                focusNode: nameNode,
                nextNode: nameNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.onTextFiledEmptyErrorText;
                  }
                  setState(() {
                    name = value;
                  });
                  return null;
                },
              ),
            ),
            confirmBtnText: 'Create',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: () async {
              if (formKey.currentState!.validate()) {
                widget.isGrade
                    ? await Provider.of<Apis>(context, listen: false)
                        .addNewGrade(name: name)
                    : await Provider.of<Apis>(context, listen: false)
                        .addNewClass(
                            name: name, grade_id: widget.gradeId.toString());

                Navigator.of(context).pop();
                Apis.statusResponse == 200
                    ? QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        confirmBtnText: 'Cancel',
                        onConfirmBtnTap: widget.onPressed,
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
      },
      style:
          ElevatedButton.styleFrom(backgroundColor: widget.backgroundBtnColor),
      child: widget.dialogLabelText,
    );
  }
}
