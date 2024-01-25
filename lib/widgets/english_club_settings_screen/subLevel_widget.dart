// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/english_club_settings_screen/books_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../screens/english_club_settings_screen.dart';
import '../../styles/app_colors.dart';
import '../all_student_screen/filter_widget.dart';
import '../form_widget copy.dart';

// ignore: must_be_immutable
class subLevelWidget extends StatefulWidget {
  subLevelWidget({
    super.key,
    required this.levels,
    required this.index,
    required this.mediaQuery,
  });
  final List levels;
  final int index;
  final Size mediaQuery;

  @override
  State<subLevelWidget> createState() => _subLevelWidgetState();
}

class _subLevelWidgetState extends State<subLevelWidget> {
  List<String> levelsName = [];
  String selectedLevel = '';
  int selectedLevelId = 0;
  String newSubLevelName = '';
  FocusNode nameNode = FocusNode();
  late TextEditingController controller;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    for (int i = 0; i < widget.levels.length; i++) {
      levelsName.add(widget.levels[i]['name']);
    }
    selectedLevel = widget.levels[0]['name'];
    selectedLevelId = widget.levels[0]['id'];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Your code here, which will be executed when the dependencies change.
    // This can be useful for fetching data or performing other actions.
  }

  Future<void> deleteSubLevel(
    BuildContext context,
    int index1,
  ) async {
    try {
      await Provider.of<Apis>(context, listen: false).deleteSubLevel(
        levelId: widget.levels[widget.index]['id'].toString(),
        supLevelId:
            widget.levels[widget.index]['sub_levels'][index1]['id'].toString(),
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

  Future<void> upDateSubLevel(
    BuildContext context,
    int index1,
  ) async {
    try {
      await Provider.of<Apis>(context, listen: false).upDateSubLevel(
        levelId: widget.levels[widget.index]['id'].toString(),
        subLevelId:
            widget.levels[widget.index]['sub_levels'][index1]['id'].toString(),
        newSubLevelName: newSubLevelName,
        newLevelId: selectedLevelId.toString(),
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

  void showQuickDialog(Size mediaQuery, int index1) {
    controller = TextEditingController(
        text: widget.levels[widget.index]['sub_levels'][index1]['name']);
    QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Edit subLevel',
        widget: Column(
          children: [
            SizedBox(
              height: mediaQuery.height / 30,
            ),
            Form(
              key: formKey,
              child: FormWidget(
                controller: controller,
                textInputType: TextInputType.text,
                isNormal: true,
                obscureText: false,
                togglePasswordVisibility: () {},
                mediaQuery: mediaQuery,
                textInputAction: TextInputAction.done,
                labelText: 'new subLevel name',
                hintText: 'EX: national geographic',
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
            SizedBox(
              height: mediaQuery.height / 80,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 80),
              child: FilterWidget(
                  mediaQuery: mediaQuery,
                  value: selectedLevel,
                  onChanged: (newLevel) {
                    setState(() {
                      selectedLevel = newLevel!;
                      changeSelectedLevel(newLevel);
                      Navigator.pop(context);
                      showQuickDialog(mediaQuery, index1);
                    });
                  },
                  menu: levelsName,
                  filterTitle: 'change level to',
                  width: double.infinity),
            ),
          ],
        ),
        confirmBtnText: 'edit',
        confirmBtnColor: Colors.amber,
        onConfirmBtnTap: () async {
          if (formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            upDateSubLevel(context, index1);
            // print(selectedLevel);
            // print(selectedLevelId);
            // print(newSubLevelName);
          }
        });
  }

  void changeSelectedLevel(String newLevel) {
    for (int i = 0; i < widget.levels.length; i++) {
      if (widget.levels[i]['name'] == newLevel) {
        selectedLevelId = widget.levels[i]['id'];
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.levels[widget.index]['sub_levels'].length,
      itemBuilder: (context, index1) => Slidable(
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
                      'If you delete this subLevel all books inside it will be deleted as well\nAre you sure?',
                  confirmBtnText: 'yes',
                  cancelBtnText: 'cancel',
                  confirmBtnColor: Colors.blueGrey,
                  onConfirmBtnTap: () {
                    Navigator.pop(context);
                    print(widget.levels[widget.index]['id'].toString());
                    print(widget.levels[widget.index]['sub_levels'][index1]
                            ['id']
                        .toString());
                    deleteSubLevel(context, index1);
                  },
                );
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            SlidableAction(
              onPressed: (con) {
                setState(() {
                  selectedLevel = widget.levels[widget.index]['name'];
                  selectedLevelId = widget.levels[widget.index]['id'];
                  newSubLevelName =
                      widget.levels[widget.index]['sub_levels'][index1]['name'];
                });
                showQuickDialog(mediaQuery, index1);
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
            SlidableAction(
              onPressed: (con) {},
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.add_circle_outline,
              label: 'add story',
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 20,
              vertical: mediaQuery.height / 100),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: ExpansionTile(
              title: Text(
                widget.levels[widget.index]['sub_levels'][index1]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.main,
                ),
              ),
              children: [
                BooksWidget(
                    mediaQuery: mediaQuery,
                    index: widget.index,
                    index1: index1,
                    levels: widget.levels)
              ]),
        ),
      ),
    );
  }
}
