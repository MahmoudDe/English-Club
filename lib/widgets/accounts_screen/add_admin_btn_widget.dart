// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../styles/app_colors.dart';
import '../form_widget copy.dart';

// ignore: must_be_immutable
class AddAdminBtnWidget extends StatefulWidget {
  AddAdminBtnWidget(
      {super.key, required this.mediaQuery, required this.onPressed});
  Size mediaQuery;
  void Function()? onPressed;

  @override
  State<AddAdminBtnWidget> createState() => _AddAdminBtnWidgetState();
}

class _AddAdminBtnWidgetState extends State<AddAdminBtnWidget> {
  String newAdminName = '';
  FocusNode nameNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        TextEditingController controller = TextEditingController(text: '');
        QuickAlert.show(
            context: context,
            type: QuickAlertType.custom,
            title: 'Add new Admin',
            widget: Form(
              key: formKey,
              child: FormWidget(
                controller: controller,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.done,
                labelText: 'user name',
                hintText: 'EX: Majed abu jaib',
                focusNode: nameNode,
                nextNode: nameNode,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter name please";
                  } else if (value.length < 4) {
                    return 'You need to enter 4 character at least';
                  }
                  setState(() {
                    newAdminName = value;
                  });
                  return null;
                },
              ),
            ),
            confirmBtnText: 'Create',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: () async {
              if (formKey.currentState!.validate()) {
                await Provider.of<Apis>(context, listen: false)
                    .addNewAdmin(newAdminName);
                Navigator.of(context).pop();
                Apis.statusResponse == 200
                    ? QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        confirmBtnText: 'Cancel',
                        onConfirmBtnTap: widget.onPressed,
                        widget: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'user_name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: widget.mediaQuery.width / 10,
                                ),
                                Text(
                                  Apis.createAdmin['data']['account']
                                      ['username'],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: widget.mediaQuery.height / 50,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: widget.mediaQuery.width / 10,
                                ),
                                Text(
                                  Apis.createAdmin['data']['account']
                                      ['password'],
                                ),
                              ],
                            ),
                          ],
                        ))
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
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
      label: const Text(
        'Add admin',
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
