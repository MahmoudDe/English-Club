import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../form_widget.dart';
import 'circle_image_picker.dart';

// ignore: must_be_immutable
class FormCreatAccountWidget extends StatefulWidget {
  FormCreatAccountWidget({super.key, required this.mediaQuery});
  Size mediaQuery;

  @override
  State<FormCreatAccountWidget> createState() => _FormCreatAccountWidgetState();
}

class _FormCreatAccountWidgetState extends State<FormCreatAccountWidget> {
  FocusNode passNode = FocusNode();
  FocusNode repassNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode cardNumberNode = FocusNode();
  FocusNode cardNameNode = FocusNode();
  FocusNode expireNode = FocusNode();
  FocusNode securityNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String repassword = '';
  File? userImagePath;
  String userNameOnCard = '';
  String userNumberOnCard = '';
  String userExpirdate = '';
  String userSecuritycode = '';

  bool obscureText = true;
  File? userImage;
  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleImagePicker(
                    mediaQuery: widget.mediaQuery,
                    userImage: userImage,
                    pickImageFromCamera: pickImageFromCamera,
                    pickImageFromGallery: pickImageFromGallery),
                Text(
                  'Create user account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 42, 24, 73),
                      fontSize: widget.mediaQuery.height / 40),
                ),
                SizedBox(
                  height: widget.mediaQuery.height / 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.mediaQuery.width / 10),
                  child: FormWidget(
                    textInputType: TextInputType.text,
                    isNormal: true,
                    obscureText: false,
                    togglePasswordVisibility: () {},
                    mediaQuery: widget.mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: 'User name',
                    hintText: 'user name',
                    focusNode: nameNode,
                    nextNode: passNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter user name';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: widget.mediaQuery.height / 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.mediaQuery.width / 10),
                  child: FormWidget(
                    textInputType: TextInputType.text,
                    isNormal: false,
                    obscureText: obscureText,
                    togglePasswordVisibility: _togglePasswordVisibility,
                    mediaQuery: widget.mediaQuery,
                    textInputAction: TextInputAction.next,
                    labelText: "Password",
                    hintText: 'password',
                    focusNode: passNode,
                    nextNode: repassNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      } else if (value.length < 3) {
                        return 'Password is too short';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: widget.mediaQuery.height / 40,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.mediaQuery.width / 10),
                  child: FormWidget(
                    textInputType: TextInputType.text,
                    isNormal: true,
                    obscureText: true,
                    togglePasswordVisibility: () {},
                    mediaQuery: widget.mediaQuery,
                    textInputAction: TextInputAction.done,
                    labelText: 'reEnter password',
                    hintText: 'reEnter password',
                    focusNode: repassNode,
                    nextNode: repassNode,
                    validationFun: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password again';
                      } else if (value != password) {
                        return 'Password don\'t match';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: widget.mediaQuery.height / 20,
                ),
                SizedBox(
                  height: widget.mediaQuery.height / 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 35, 19, 63),
                  ),
                  child: const Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      userImage = File(returndImage.path);
    });
  }

  Future pickImageFromCamera() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returndImage == null) return;
    setState(() {
      userImage = userImagePath = File(returndImage.path);
    });
  }
}
