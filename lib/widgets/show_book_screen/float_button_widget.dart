// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/screens/show_book_details_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/form_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class FloatButtonWidget extends StatelessWidget {
  FloatButtonWidget({
    super.key,
    required this.mediaQuery,
    required this.levelName,
    required this.subLevelName,
  });
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
                          storyId: showBookController.bookData['story']['story']
                                  ['id']
                              .toString(),
                          subLevelId: showBookController.bookData['story']
                                  ['story']['sub_level_id']
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
                                    bookId: showBookController.bookData['story']
                                            ['story']['id']
                                        .toString(),
                                    subLevelId: showBookController
                                        .bookData['story']['story']
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
                      primary: Colors.amber,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        titleController = TextEditingController(
            text: showBookController.bookData['story']['story']['title']
                .toString());
        quantityController = TextEditingController(
            text: showBookController.bookData['story']['story']['quantity']
                .toString());
        borrowController = TextEditingController(
            text: showBookController.bookData['story']['story']
                    ['allowed_borrow_days']
                .toString());

        showDialogFun(context);
      },
      child: Container(
        height: mediaQuery.height / 10,
        width: mediaQuery.width / 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
    );
  }
}
