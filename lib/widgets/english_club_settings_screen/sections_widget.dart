// ignore_for_file: use_build_context_synchronously

import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../server/apis.dart';
import '../form_widget copy.dart';

class SectionsWidget extends StatelessWidget {
  SectionsWidget(
      {super.key,
      required this.mediaQuery,
      required this.nameNode,
      this.validationFun,
      this.onChangedFilter,
      required this.allSectionsNames,
      required this.selectedSection,
      required this.newSectionName,
      required this.sectionId,
      this.onConfirmBtnTap});
  final Size mediaQuery;
  final formKey = GlobalKey<FormState>();
  final FocusNode nameNode;
  final String? Function(String?)? validationFun;
  final void Function(String?)? onChangedFilter;
  final List<dynamic> allSectionsNames;
  final String selectedSection;
  final String newSectionName;
  final String sectionId;
  final Function()? onConfirmBtnTap;

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
          SlidableAction(
            onPressed: (context) {},
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
                  title: 'Edit section',
                  widget: Form(
                    key: formKey,
                    child: FormWidget(
                      textInputType: TextInputType.text,
                      isNormal: true,
                      obscureText: false,
                      togglePasswordVisibility: () {},
                      mediaQuery: mediaQuery,
                      textInputAction: TextInputAction.done,
                      labelText: 'new section name',
                      hintText: 'EX: national geographic',
                      focusNode: nameNode,
                      nextNode: nameNode,
                      validationFun: validationFun,
                    ),
                  ),
                  confirmBtnText: 'edit',
                  confirmBtnColor: Colors.amber,
                  onConfirmBtnTap: () async {
                    if (formKey.currentState!.validate()) {
                      await Provider.of<Apis>(context, listen: false)
                          .updateSection(
                              sectionId: sectionId,
                              sectionName: newSectionName);
                      Navigator.of(context).pop();
                      Apis.statusResponse == 200
                          ? QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              confirmBtnText: 'Ok',
                              onConfirmBtnTap: () {
                                // allSections.clear();
                                // allSectionsNames.clear();
                                // levels.clear();
                                // getData();
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
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'edit',
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 40),
        child: FilterWidget(
            mediaQuery: mediaQuery,
            value: selectedSection,
            onChanged: onChangedFilter,
            menu: allSectionsNames,
            filterTitle: 'sections',
            width: double.infinity),
      ),
    );
  }
}
