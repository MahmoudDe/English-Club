import 'package:bdh/data/data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../all_student_screen/filter_widget.dart';
import '../form_widget.dart';

// ignore: must_be_immutable
class FormCreatAccountWidget extends StatefulWidget {
  FormCreatAccountWidget({
    super.key,
    required this.mediaQuery,
  });
  Size mediaQuery;

  @override
  State<FormCreatAccountWidget> createState() => _FormCreatAccountWidgetState();
}

class _FormCreatAccountWidgetState extends State<FormCreatAccountWidget> {
  FocusNode scoreNod = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode bronzeNod = FocusNode();
  FocusNode silverNod = FocusNode();
  FocusNode goldenNod = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String studentName = '';
  int classId = 0;
  int studentScore = 0;
  int bronzeCoins = 0;
  int silverCoins = 0;
  int goldenCoins = 0;

  List<String> allClassesInGrade = [];
  List filterStudents = [];
  List searchStudentList = [];

  String selectedGradeFilterValue = dataClass.grades[0]['name'];
  String selectedClassFilterValue = dataClass.grades[0]['classes'][0]['name'];

  @override
  void initState() {
    changeClasses();
    super.initState();
  }

  void changeClasses() {
    final filterClassesOnGrade = dataClass.grades
        .where((element) => element['name'] == selectedGradeFilterValue)
        .toList();
    allClassesInGrade.clear();
    for (int i = 0; i < filterClassesOnGrade[0]['classes'].length; i++) {
      allClassesInGrade.add(filterClassesOnGrade[0]['classes'][i]['name']);
    }
    selectedClassFilterValue = filterClassesOnGrade[0]['classes'][0]['name'];
    classId = filterClassesOnGrade[0]['classes'][0]['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create Student account',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.main,
                  fontSize: widget.mediaQuery.height / 40),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 30,
            ),
            //Student name text filed
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
                labelText: 'Student name',
                hintText: 'EX: Ahmad mohsen',
                focusNode: nameNode,
                nextNode: scoreNod,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter student name name';
                  } else if (value.length < 4) {
                    return 'This name is too short';
                  }
                  setState(() {
                    studentName = value;
                  });
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 40,
            ),
            //grade and class filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilterWidget(
                    mediaQuery: widget.mediaQuery,
                    menu: allClassesInGrade,
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          selectedClassFilterValue = newValue!;
                          final filterClassesOnGrade = dataClass.grades
                              .where((element) =>
                                  element['name'] == selectedGradeFilterValue)
                              .toList();
                          for (int i = 0;
                              i < filterClassesOnGrade[0]['classes'].length;
                              i++) {
                            if (filterClassesOnGrade[0]['classes'][i]['name'] ==
                                newValue) {
                              classId =
                                  filterClassesOnGrade[0]['classes'][i]['id'];
                            }
                          }
                        },
                      );
                    },
                    value: selectedClassFilterValue,
                    filterTitle: 'Class',
                  ),
                  SizedBox(
                    width: widget.mediaQuery.width / 20,
                  ),
                  FilterWidget(
                    mediaQuery: widget.mediaQuery,
                    menu: dataClass.gradesName,
                    onChanged: (String? newValue) {
                      setState(
                        () {
                          selectedGradeFilterValue = newValue!;
                          changeClasses();
                        },
                      );
                    },
                    value: selectedGradeFilterValue,
                    filterTitle: 'Grade',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 40,
            ),
            //Student score text filed
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.mediaQuery.width / 10),
              child: FormWidget(
                textInputType: TextInputType.number,
                isNormal: true,
                obscureText: true,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.next,
                labelText: 'Student score',
                hintText: 'Enter student score',
                focusNode: scoreNod,
                nextNode: bronzeNod,
                validationFun: (value) {
                  if (value == null || value.isEmpty) {
                    return 'You have to enter score';
                  }
                  setState(() {
                    studentScore = int.parse(value);
                  });
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 40,
            ),
            //Bronze coins text filed
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.mediaQuery.width / 10),
              child: FormWidget(
                textInputType: TextInputType.number,
                isNormal: true,
                obscureText: true,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.next,
                labelText: 'Bronze coins',
                hintText: 'Enter student bronze coins',
                focusNode: bronzeNod,
                nextNode: silverNod,
                validationFun: (value) {
                  setState(() {
                    bronzeCoins = int.parse(value!);
                  });
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 40,
            ),
            //Silver coins text filed
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.mediaQuery.width / 10),
              child: FormWidget(
                textInputType: TextInputType.number,
                isNormal: true,
                obscureText: true,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.next,
                labelText: 'Silver coins',
                hintText: 'Enter student silver coins',
                focusNode: silverNod,
                nextNode: goldenNod,
                validationFun: (value) {
                  setState(() {
                    silverCoins = int.parse(value!);
                  });
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 40,
            ),
            //Golden coins text filed
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: widget.mediaQuery.width / 10),
              child: FormWidget(
                textInputType: TextInputType.number,
                isNormal: true,
                obscureText: true,
                togglePasswordVisibility: () {},
                mediaQuery: widget.mediaQuery,
                textInputAction: TextInputAction.done,
                labelText: 'Golden coins',
                hintText: 'Enter student golden coins',
                focusNode: goldenNod,
                nextNode: goldenNod,
                validationFun: (value) {
                  setState(() {
                    goldenCoins = int.parse(value!);
                  });
                  return null;
                },
              ),
            ),
            SizedBox(
              height: widget.mediaQuery.height / 20,
            ),
            ElevatedButton(
              onPressed: () {
                print("studentName => $studentName");
                print("classId => $classId");
                print("studentScore => $studentScore");
                print("bronzeCoins => $bronzeCoins");
                print("silverCoins => $silverCoins");
                print("goldenCoins => $goldenCoins");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
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
    );
  }
}
