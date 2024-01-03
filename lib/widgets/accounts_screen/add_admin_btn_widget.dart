// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Text(
                  'Add new Admin',
                  style: TextStyle(
                      color: AppColors.main, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Iconsax.security_user,
                  color: AppColors.main,
                )
              ],
            ),
            content: Form(
              key: formKey,
              child: FormWidget(
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
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await Provider.of<Apis>(context, listen: false)
                          .addNewAdmin(newAdminName);
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Admin'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'user_name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                          ),
                          actions: [
                            TextButton(
                                onPressed: widget.onPressed,
                                child: const Text('Cancel'))
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
      label: const Text('Add admin'),
      icon: const Icon(Icons.add),
    );
  }
}
