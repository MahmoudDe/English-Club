// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/create_account_screen/filter_section_levels_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
  FocusNode borrowNod = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode bronzeNod = FocusNode();
  FocusNode silverNod = FocusNode();
  FocusNode goldenNod = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String studentName = '';
  int classId = 0;
  int studentScore = 0;
  int borrowLimit = 0;
  int bronzeCoins = 0;
  int silverCoins = 0;
  int goldenCoins = 0;
  List progresses = [];

  List<String> allClassesInGrade = [];
  List filterStudents = [];
  List searchStudentList = [];

  String selectedGradeFilterValue = dataClass.grades[0]['name'];
  String selectedClassFilterValue = dataClass.grades[0]['classes'][0]['name'];

  List sections = [];

  @override
  void initState() {
    changeClasses();
    getSections();
    super.initState();
  }

  void getSections() {
    for (int i = 0; i < dataClass.sections.length; i++) {
      List<String> levels_parts = [];
      int levelId = 0;
      int supLevelId = 0;
      for (int j = 0; j < dataClass.sections[i]['data'].length; j++) {
        levels_parts.add(dataClass.sections[i]['data'][j]['name']);
      }
      print('The last section is => ${dataClass.sections.last}');
      print('The data we get is => $levels_parts');
      if (levels_parts.isNotEmpty) {
        String? startValue = levels_parts[0];
        sections.add({
          "drop_menu": levels_parts,
          "value": startValue,
          "grade_id": dataClass.sections[i]['section_id'],
        });
        levelId = dataClass.sections[i]['data'][0]['level_id'];
        supLevelId = dataClass.sections[i]['data'][0]['sub_level_id'];
        progresses.add({
          "section_id": dataClass.sections[i]['section_id'],
          "level_id": levelId,
          "sub_level_id": supLevelId,
          "finishedStories": []
        });
      }
    }
  }

  void changeSection({required index, required value}) {
    print(index);
    print(value);
    progresses.removeAt(index);
    print(dataClass.sections);

    int levelId = 0;
    int supLevelId = 0;
    for (int j = 0; j < dataClass.sections[index]['data'].length; j++) {
      if (dataClass.sections[index]['data'][j]['name'] == value) {
        levelId = dataClass.sections[index]['data'][j]['level_id'];
        supLevelId = dataClass.sections[index]['data'][j]['sub_level_id'];
        progresses.insert(index, {
          "section_id": dataClass.sections[index]['section_id'],
          "level_id": levelId,
          "sub_level_id": supLevelId,
          "finishedStories": []
        });
        // print(progresses);

        return;
      }
    }

    // print(progresses);
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

  Future<void> createStudentAccount() async {
    try {
      print("studentName => $studentName");
      print("classId => $classId");
      print("borrowLimit => $borrowLimit");
      print("studentScore => $studentScore");
      print("bronzeCoins => $bronzeCoins");
      print("silverCoins => $silverCoins");
      print("goldenCoins => $goldenCoins");
      print("progresses => $progresses");
      await Provider.of<Apis>(context, listen: false).createStudentAccount(
          borrowLimit: borrowLimit.toString(),
          name: studentName,
          g_class_id: classId,
          score: studentScore.toString(),
          golden_coins: goldenCoins.toString(),
          silver_coins: silverCoins.toString(),
          bronze_coins: bronzeCoins.toString(),
          progresses: progresses);

      Apis.statusResponse == 200
          ? QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              confirmBtnText: 'cancel',
              confirmBtnColor: Colors.green,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('user name :'),
                      SizedBox(
                        width: widget.mediaQuery.width / 15,
                      ),
                      Text(Apis.createStudent['username'])
                    ],
                  ),
                  SizedBox(
                    height: widget.mediaQuery.height / 80,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('password :'),
                      SizedBox(
                        width: widget.mediaQuery.width / 15,
                      ),
                      Text(Apis.createStudent['password'])
                    ],
                  ),
                ],
              ),
              text: Apis.createStudent[''],
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              })
          : QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              confirmBtnText: 'cancel',
              confirmBtnColor: Colors.amber,
              text: Apis.message,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
              },
            );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: widget.mediaQuery.height / 20),
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
                height: widget.mediaQuery.height / 90,
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
                      width: widget.mediaQuery.width / 2.3,
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
                              if (filterClassesOnGrade[0]['classes'][i]
                                      ['name'] ==
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
                      width: widget.mediaQuery.width / 2.3,
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
                height: widget.mediaQuery.height / 30,
              ),
              //Student score text filed
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: FormWidget(
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: widget.mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Student score',
                  hintText: 'Enter student score',
                  focusNode: scoreNod,
                  nextNode: borrowNod,
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
                height: widget.mediaQuery.height / 90,
              ),
              //Student limit book
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: FormWidget(
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: widget.mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Borrow limit',
                  hintText: 'limit of books student can borrow',
                  focusNode: borrowNod,
                  nextNode: bronzeNod,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You have to enter a number';
                    }
                    setState(() {
                      borrowLimit = int.parse(value);
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 90,
              ),
              //Bronze coins text filed
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: FormWidget(
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: widget.mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Bronze coins',
                  hintText: 'Enter student bronze coins',
                  focusNode: bronzeNod,
                  nextNode: silverNod,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You have to enter bronze coins';
                    }
                    setState(() {
                      bronzeCoins = int.parse(value);
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 90,
              ),
              //Silver coins text filed
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: FormWidget(
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: widget.mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Silver coins',
                  hintText: 'Enter student silver coins',
                  focusNode: silverNod,
                  nextNode: goldenNod,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You have to enter silver coins';
                    }
                    setState(() {
                      silverCoins = int.parse(value);
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 90,
              ),
              //Golden coins text filed
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 10),
                child: FormWidget(
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: widget.mediaQuery,
                  textInputAction: TextInputAction.done,
                  labelText: 'Golden coins',
                  hintText: 'Enter student golden coins',
                  focusNode: goldenNod,
                  nextNode: goldenNod,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'You have to enter golden coins';
                    }
                    setState(() {
                      goldenCoins = int.parse(value);
                    });
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  dataClass.sections.length,
                  (index) {
                    return dataClass.sections[index]['data'].isEmpty
                        ? const SizedBox()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilterSectionLevelsWidget(
                                  mediaQuery: widget.mediaQuery,
                                  value: sections[index]['value'],
                                  onChanged: (value) {
                                    setState(() {
                                      sections[index]['value'] = value!;
                                      changeSection(index: index, value: value);
                                    });
                                  },
                                  menu: sections[index]['drop_menu'],
                                  filterTitle: dataClass.sections[index]
                                      ['section_name']),
                              SizedBox(
                                height: widget.mediaQuery.height / 90,
                              )
                            ],
                          );
                  },
                ),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createStudentAccount();
                  }
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
      ),
    );
  }
}
