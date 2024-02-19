// ignore_for_file: use_build_context_synchronously

import 'package:bdh/screens/create_new_level_screen.dart';
import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../screens/english_club_settings_screen.dart';
import '../../server/apis.dart';
import '../form_widget copy.dart';

class SectionsWidget extends StatefulWidget {
  SectionsWidget(
      {super.key,
      required this.mediaQuery,
      this.onChangedFilter,
      required this.allSectionsNames,
      required this.selectedSection,
      required this.sectionId,
      this.onConfirmBtnTap,
      required this.allSections});
  final Size mediaQuery;
  final void Function(String?)? onChangedFilter;
  final List<dynamic> allSectionsNames;
  final List<dynamic> allSections;
  final String selectedSection;
  final String sectionId;
  final Function()? onConfirmBtnTap;

  @override
  State<SectionsWidget> createState() => _SectionsWidgetState();
}

class _SectionsWidgetState extends State<SectionsWidget> {
  final formKey = GlobalKey<FormState>();
  String newSectionName = '';
  FocusNode nameNode = FocusNode();
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.selectedSection);
    super.initState();
  }

  @override
  void dispose() {
    nameNode.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> deleteSection({required BuildContext context}) async {
    try {
      await Provider.of<Apis>(context, listen: false).deleteSection(
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

  Future<void> activateSection({
    required BuildContext context,
  }) async {
    try {
      await Provider.of<Apis>(context, listen: false).makeSectionReady(
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
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        extentRatio: 1 / 2,
        dragDismissible: false,
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),
        children: [
          //delete section slide
          SlidableAction(
            onPressed: (context1) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.warning,
                text:
                    'Are you sure you want to delete this section ( ${widget.selectedSection} )?',
                confirmBtnText: 'yes',
                cancelBtnText: 'cancel',
                confirmBtnColor: Colors.blueGrey,
                onConfirmBtnTap: () {
                  Navigator.pop(context);
                  deleteSection(
                    context: context,
                  );
                },
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          //edit section slide
          SlidableAction(
            onPressed: (con) {
              controller = TextEditingController(text: widget.selectedSection);
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.custom,
                  title: 'Edit section',
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
                      labelText: 'new section name',
                      hintText: 'EX: national geographic',
                      focusNode: nameNode,
                      nextNode: nameNode,
                      validationFun: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter section name please";
                        } else if (value.length < 2) {
                          return 'You have to enter 2 character at least';
                        }
                        setState(() {
                          newSectionName = value;
                        });
                        return null;
                      },
                    ),
                  ),
                  confirmBtnText: 'edit',
                  confirmBtnColor: Colors.amber,
                  onConfirmBtnTap: () async {
                    if (formKey.currentState!.validate()) {
                      await Provider.of<Apis>(context, listen: false)
                          .updateSection(
                              sectionId: widget.sectionId,
                              sectionName: newSectionName);
                      Navigator.of(context).pop();
                      Apis.statusResponse == 200
                          ? QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              confirmBtnText: 'Ok',
                              onConfirmBtnTap: widget.onConfirmBtnTap,
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
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          //add level slide
          SlidableAction(
            onPressed: (context) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateNewLevelScreen(
                    sectionId: widget.sectionId,
                    sectionName: widget.selectedSection),
              ));
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.add_circle_outline,
            label: 'add level',
          ),
          //Active || inActive section
          if (Apis.sectionInfo['ready'] == 0)
            SlidableAction(
              onPressed: (context1) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.warning,
                  text:
                      'Are you sure you want to activate this section ( ${widget.selectedSection} )? \n Activate this section if you end adding levels, subLevels and stories',
                  confirmBtnText: 'yes',
                  cancelBtnText: 'cancel',
                  confirmBtnColor: Colors.blueGrey,
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    activateSection(
                      context: context,
                    );
                  },
                );
              },
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              icon: Icons.star_rounded,
              label: 'active',
            ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.mediaQuery.width / 40),
        child: Column(
          children: [
            Apis.sectionInfo['ready'] == 0
                ? const Text(
                    'This section is not activated  yet',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            FilterWidget(
                mediaQuery: widget.mediaQuery,
                value: widget.selectedSection,
                onChanged: widget.onChangedFilter,
                menu: widget.allSectionsNames,
                filterTitle: 'sections',
                width: double.infinity),
          ],
        ),
      ),
    );
  }
}
