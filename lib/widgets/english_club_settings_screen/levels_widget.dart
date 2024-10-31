// ignore_for_file: use_build_context_synchronously

import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/screens/view_edit_level_screen.dart';
import 'package:bdh/widgets/english_club_settings_screen/subLevel_widget.dart';
import 'package:bdh/widgets/form_widget%20copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../common/dialogs/dialogs.dart';
import '../../server/apis.dart';

// ignore: must_be_immutable
class LevelsWidget extends StatefulWidget {
  LevelsWidget(
      {super.key,
      required this.mediaQuery,
      required this.levels,
      required this.sectionId,
      required this.sectionName});
  final Size mediaQuery;
  final List levels;
  final String sectionId;
  final String sectionName;

  @override
  State<LevelsWidget> createState() => _LevelsWidgetState();
}

class _LevelsWidgetState extends State<LevelsWidget> {
  String newSubLevelName = '';
  TextEditingController controller = TextEditingController(text: '');
  FocusNode nameNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  Future<void> deleteLevel(
      {required int index, required BuildContext context}) async {
    try {
      await Provider.of<Apis>(context, listen: false).deleteLevel(
        levelId: widget.levels[index]['id'].toString(),
        sectionId: widget.sectionId,
      );
      Apis.statusResponse == 200
          ? QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              confirmBtnText: 'Ok',
              onConfirmBtnTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnglishClubSettingsScreen(),
                  ),
                );
              },
              text: Apis.message,
            )
          : QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: Apis.message,
              confirmBtnText: 'Cancel',
              confirmBtnColor: Colors.red,
              onConfirmBtnTap: () {
                Navigator.pop(context);
              });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context1) {
    return ListView.builder(
      itemCount: widget.levels.length,
      itemBuilder: (context, index) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              extentRatio: 1 / 2,
              dragDismissible: false,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context1) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text:
                          'Are you sure you want to delete this level ( ${widget.levels[index]['name']} )?',
                      confirmBtnText: 'yes',
                      cancelBtnText: 'cancel',
                      confirmBtnColor: Colors.blueGrey,
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        deleteLevel(context: context, index: index);
                      },
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (con) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.custom,
                        title: 'Add new subLevel',
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
                            labelText: 'subLevel name',
                            hintText: 'EX: subLevel(1)',
                            focusNode: nameNode,
                            nextNode: nameNode,
                            validationFun: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter subLevel name please";
                              } else if (value.length < 2) {
                                return 'You have to enter 2 character at least';
                              }
                              setState(() {
                                newSubLevelName = value;
                              });
                              return null;
                            },
                          ),
                        ),
                        confirmBtnText: 'Create',
                        confirmBtnColor:
                            const Color.fromARGB(255, 145, 229, 147),
                        onConfirmBtnTap: () async {
                          if (formKey.currentState!.validate()) {
                            loadingDialog(
                                context: context,
                                mediaQuery: widget.mediaQuery,
                                title: 'Loading...');

                            await Provider.of<Apis>(context, listen: false)
                                .createSupLevel(
                              levelId: widget.levels[index]['id'].toString(),
                              supLevelName: newSubLevelName,
                            );
                            Navigator.of(context).pop();

                            Navigator.of(context).pop();
                            Apis.statusResponse == 200
                                ? QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    confirmBtnText: 'Ok',
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EnglishClubSettingsScreen(),
                                        ),
                                      );
                                    },
                                    text: Apis.message,
                                  )
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
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.add_circle_outline,
                  label: 'add subLevel',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: (() {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ViewEditLevelScreen(
                      sectionId: widget.sectionId,
                      sectionName: widget.sectionName,
                      levelId: widget.levels[index]['id'].toString()),
                ));
              }),
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 30),
                height: widget.mediaQuery.height / 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Text(
                  widget.levels[index]['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          subLevelWidget(
              levels: widget.levels,
              index: index,
              mediaQuery: widget.mediaQuery),
        ],
      ),
    );
  }
}
