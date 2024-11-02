// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bdh/common/dialogs/dialogs.dart';
import 'package:bdh/model/user.dart';
import 'package:bdh/screens/all_sections_map_roads_screen.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/snack_bar_widget.dart';
import '../form_widget.dart';

// ignore: must_be_immutable
class FormStartWidget extends StatefulWidget {
  FormStartWidget(
      {super.key,
      required this.mediaQuery,
      required this.scrollController,
      required this.isMenuOpen});
  Size mediaQuery;
  ScrollController scrollController;
  bool isMenuOpen;

  @override
  State<FormStartWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormStartWidget> {
  FocusNode passNode = FocusNode();
  FocusNode nameNode = FocusNode();
  String enterdEmail = '';
  String enterdPass = '';
  final Uri whatsApp = Uri.parse('https://wa.me/+963967509515');
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future<void> submit(BuildContext context, Size mediaQuery) async {
    try {
      if (await Provider.of<Apis>(context, listen: false)
          .login(enterdEmail, enterdPass)) {
        if (User.userType == 'student') {
          if (await Provider.of<Apis>(context, listen: false)
              .studentHomeScreen(id: '-1')) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AllSectionsMapRoadsScreen(
                      studentData: {
                        'profile_picture': Apis.studentModel!.profilePicture,
                        'name': Apis.studentModel!.name,
                        'id': '-1',
                      },
                      studentId: '-1',
                      allSections: [],
                      mediaQuery: mediaQuery)),
              (route) => false,
            );
          }

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBarWidget(
                    title: 'Success',
                    message: 'Welcome to the English Club',
                    contentType: ContentType.success)
                .getSnakBar());
        } else if (User.userType == 'admin') {
          Navigator.pop(context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              NavigationScreen.routeName, (Route<dynamic> route) => false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBarWidget(
                    title: 'Success',
                    message: 'Welcome to your app',
                    contentType: ContentType.success)
                .getSnakBar());
        }
      } else {
        Navigator.pop(context);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBarWidget(
                  title: 'Ops',
                  message: 'User name or password is wrong',
                  contentType: ContentType.failure)
              .getSnakBar());
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SizedBox(
        height: mediaQuery.height,
        width: mediaQuery.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: mediaQuery.height / 60,
              ),
              GestureDetector(
                onTap: () {
                  widget.scrollController.animateTo(
                      widget.scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn);
                  setState(() {
                    widget.isMenuOpen = false;
                  });
                },
                child: Container(
                  width: mediaQuery.width / 3.5,
                  height: mediaQuery.height / 200,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: Colors.black38,
                  ),
                ),
              ),
              SizedBox(
                height: mediaQuery.height / 20,
              ),
              Text(
                'Sign In',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 20),
              ),
              SizedBox(
                height: mediaQuery.height / 20,
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
                  labelText: 'username',
                  hintText: 'EX: Ahmed Mohsen',
                  focusNode: nameNode,
                  nextNode: passNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return "you need to enter your account name";
                    } else if (value.length < 3) {
                      return 'this name is invalid';
                    }
                    setState(() {
                      enterdEmail = value;
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
                  textInputAction: TextInputAction.done,
                  labelText: 'password',
                  hintText: 'password',
                  focusNode: passNode,
                  nextNode: passNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your password';
                    } else if (value.length < 3) {
                      return 'your password is invalid';
                    }
                    setState(() {
                      enterdPass = value;
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 80,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();

                    submit(context, mediaQuery);
                    loadingDialog(
                        context: context,
                        mediaQuery: mediaQuery,
                        title: 'Loading');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                ),
                child: SizedBox(
                  width: widget.mediaQuery.width / 1.5,
                  child: const Text(
                    'Sign in',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 20,
              ),
              const Text(
                '______________________ or ______________________',
                style: TextStyle(color: Colors.black26),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 50,
              ),
              const Text(
                'If you don\'t have an account ',
                style: TextStyle(
                    fontWeight: FontWeight.w100, color: Colors.black45),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  launchUrl(whatsApp);
                },
                style: TextButton.styleFrom(backgroundColor: AppColors.main),
                icon: const Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                label: const Text(
                  'Contact with us',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
