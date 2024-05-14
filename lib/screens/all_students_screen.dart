// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_student_screen/empty_data_widget.dart';
import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:bdh/widgets/all_student_screen/search_widgets.dart';
import 'package:bdh/widgets/all_student_screen/studnet_widget.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quickalert/quickalert.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({
    super.key,
  });

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen>
    with TickerProviderStateMixin {
  List<String> allGrades = [];
  List<String> allClassesInGrade = [];
  List filterStudents = [];
  List searchStudentList = [];
  late AnimationController? controllerAnimation;
  String startDate = '';
  String endDate = '';
  String sortValue = 'No filter';
  bool selectedOption = false;

  late String selectedGradeFilterValue;
  late String selectedClassFilterValue;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  late TabController? controller;

  List sortOptions = [
    'No filter',
    'score',
    'golden_coins',
    'silver_coins',
    'bronze_coins',
    'finished stories',
    'finished levels'
  ];

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (startDate.isEmpty && endDate.isEmpty) {
        await Provider.of<Apis>(context, listen: false).getAllStudents();
      } else {
        await Provider.of<Apis>(context, listen: false)
            .getAllStudentsWithFilter(startDate, endDate);
      }
      setState(() {
        allGrades.clear();
        allClassesInGrade.clear();
        filterStudents.clear();
        searchStudentList.clear();
        dataClass.students = Apis.allStudents['data'];
        _isLoading = false;
      });
      for (int i = 0; i < dataClass.students.length; i++) {
        allGrades.add(dataClass.students[i]['name']);
      }
      selectedGradeFilterValue = dataClass.students[0]['name'];
      changeClasses();
      filterData();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    controllerAnimation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    getData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    controllerAnimation!.dispose();
    super.dispose();
  }

  void changeClasses() {
    final filterClassesOnGrade = dataClass.students
        .where((element) => element['name'] == selectedGradeFilterValue)
        .toList();
    allClassesInGrade.clear();
    for (int i = 0; i < filterClassesOnGrade[0]['classes'].length; i++) {
      allClassesInGrade.add(filterClassesOnGrade[0]['classes'][i]['name']);
    }
    selectedClassFilterValue = filterClassesOnGrade[0]['classes'][0]['name'];
  }

  void search() {
    String searchQuery = _searchController.text.toLowerCase();
    List<dynamic> finalData = [];
    setState(() {
      for (int i = 0; i < filterStudents.length; i++) {
        if (filterStudents[i]['name'].toLowerCase().contains(searchQuery)) {
          finalData.add(filterStudents[i]);
        }
      }
      searchStudentList = finalData;
    });
  }

  Future<void> deleteStudent(int index) async {
    try {
      await Provider.of<Apis>(context, listen: false)
          .deleteStudent(searchStudentList[index]['id'].toString());
      if (Apis.statusResponse == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: Apis.message,
          confirmBtnText: 'ok',
          onConfirmBtnTap: () => setState(
            () {
              dataClass.students.clear();
              getData();
              Navigator.pop(context);
            },
          ),
        );
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: Apis.message,
            confirmBtnText: 'cancel');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeActiveStudentState(String activeState, int index) async {
    try {
      await Provider.of<Apis>(context, listen: false).activeStudent(
          studentId: searchStudentList[index]['id'].toString(),
          activeState: activeState);
      if (Apis.statusResponse == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: Apis.message,
          confirmBtnText: 'ok',
          onConfirmBtnTap: () => setState(
            () {
              dataClass.students.clear();
              dataClass.students = Apis.allStudents['data'];
              getData();
              Navigator.pop(context);
            },
          ),
        );
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: Apis.message,
            confirmBtnText: 'cancel');
      }
    } catch (e) {
      print(e);
    }
  }

  void filterData() {
    // filterStudents.clear();
    searchStudentList.clear();
    setState(() {
      filterStudents = dataClass.students
          .where((element) => element['name'] == selectedGradeFilterValue)
          .toList()[0]['classes']
          .where((e) => e['name'] == selectedClassFilterValue)
          .toList()[0]['students'];
      if (selectedOption) {
        searchStudentList = [...filterStudents];
      } else {
        for (int i = 0; i < filterStudents.length; i++) {
          if (filterStudents[i]['inactive'] == 1) {
            searchStudentList.add(filterStudents[i]);
          }
        }
      }
      if (sortValue == 'No filter' || sortValue.isEmpty) {
        print('no thing to sort');
      } else {
        searchStudentList.sort(
          (a, b) => b[sortValue].compareTo(a[sortValue]),
        );
      }
    });
  }

  Future<void> _showFilterDialog(BuildContext context, Size mediaQuery) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black45,
          title: const Text(
            'Filter student',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 30,
                          vertical: mediaQuery.height / 90),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: Colors.amber)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Start Date: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.width / 40,
                                color: Colors.black45),
                          ),
                          Text(
                            startDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.width / 40),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: mediaQuery.width / 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 30,
                          vertical: mediaQuery.height / 90),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: Colors.amber)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'end Date: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.width / 40,
                                color: Colors.black45),
                          ),
                          Text(
                            endDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.width / 40),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      currentDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      print(DateFormat('yyyy-MM-dd').format(picked.start));
                      print(DateFormat('yyyy-MM-dd').format(picked.end));
                      setState(() {
                        startDate =
                            DateFormat('yyyy-MM-dd').format(picked.start);
                        endDate = DateFormat('yyyy-MM-dd').format(picked.end);
                        Navigator.pop(context);
                        _showFilterDialog(context, mediaQuery);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "change date",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              SizedBox(
                height: mediaQuery.height / 60,
              ),
              FilterWidget(
                mediaQuery: mediaQuery,
                menu: sortOptions,
                width: double.infinity,
                onChanged: (String? newValue) {
                  setState(
                    () {
                      if (newValue == 'finished stories') {
                        sortValue = 'finishedStoriesCount';
                      } else if (newValue == 'finished levels') {
                        sortValue = 'finishedLevelsCount';
                      } else {
                        sortValue = newValue!;
                      }
                      print(sortValue);
                      Navigator.pop(context);
                      _showFilterDialog(context, mediaQuery);
                    },
                  );
                },
                value: sortValue,
                filterTitle: 'sort by  ',
              ),
              SizedBox(
                height: mediaQuery.height / 60,
              ),
              CheckboxListTile(
                value: selectedOption,
                activeColor: Colors.amber,
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    selectedOption = !selectedOption;
                    Navigator.pop(context);
                    _showFilterDialog(context, mediaQuery);
                  });
                },
                title: Text(
                  'Show inActive student ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: mediaQuery.width / 28),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                print('start date => $startDate');
                print('end date => $endDate');
                print('show inActive => $selectedOption');
                Navigator.of(context).pop();
                getData();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
              ),
              child: const Text(
                'filter',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            body: Column(
              children: [
                TitleWidget(
                    mediaQuery: mediaQuery,
                    title: 'search',
                    icon: const SizedBox(
                      width: 0,
                    )),
                SizedBox(
                  height: mediaQuery.height / 3,
                ),
                CircularProgressIndicator(
                  color: AppColors.main,
                ),
              ],
            ),
          )
        : Scaffold(
            body: dataClass.students.isEmpty
                ? EmptyDataWidget(mediaQuery: mediaQuery)
                : Consumer<Apis>(
                    builder: (context, value, child) => Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TitleWidget(
                            mediaQuery: mediaQuery,
                            title: 'search',
                            icon: const SizedBox(
                              width: 0,
                            )),
                        SizedBox(
                          height: mediaQuery.height / 80,
                        ),
                        //filter grade and class
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FilterWidget(
                                width: mediaQuery.width / 2.3,
                                mediaQuery: mediaQuery,
                                menu: allClassesInGrade,
                                onChanged: (String? newValue) {
                                  controllerAnimation!.reverse().whenComplete(
                                    () {
                                      setState(
                                        () {
                                          selectedClassFilterValue = newValue!;
                                          filterData();
                                        },
                                      );
                                      controllerAnimation!.forward();
                                    },
                                  );
                                },
                                value: selectedClassFilterValue,
                                filterTitle: 'Class',
                              ),
                              SizedBox(
                                width: mediaQuery.width / 20,
                              ),
                              FilterWidget(
                                width: mediaQuery.width / 2.3,
                                mediaQuery: mediaQuery,
                                menu: allGrades,
                                onChanged: (String? newValue) {
                                  controllerAnimation!
                                      .reverse()
                                      .whenComplete(() {
                                    setState(
                                      () {
                                        selectedGradeFilterValue = newValue!;
                                        changeClasses();
                                        filterData();
                                      },
                                    );
                                    controllerAnimation!.forward();
                                  });
                                },
                                value: selectedGradeFilterValue,
                                filterTitle: 'Grade',
                              ),
                            ],
                          ),
                        ),
                        SearchWidget(
                          controller: _searchController,
                          mediaQuery: mediaQuery,
                          onChanged: (value) {
                            search();
                          },
                          onFilterPressed: () {
                            _showFilterDialog(context, mediaQuery);
                          },
                        ),
                        //students
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchStudentList.length,
                              itemBuilder: (context, index) => Consumer<Apis>(
                                    builder: (context, value, child) =>
                                        StudentWidget(
                                            allClassesInGrade:
                                                allClassesInGrade,
                                            allGrades: allGrades,
                                            selectedClassFilterValue:
                                                selectedClassFilterValue,
                                            selectedGradeFilterValue:
                                                selectedGradeFilterValue,
                                            onPressedActive: (p0) {
                                              changeActiveStudentState(
                                                  //now
                                                  //InActive = 0 mean it's inActive
                                                  //InActive = 1 mean it's Active

                                                  //before
                                                  //InActive = 0 mean it's Active                  to inActive send 1
                                                  //InActive = 1 mean it's InActive                to active send 0
                                                  searchStudentList[index]
                                                              ['inactive'] ==
                                                          0
                                                      ? '1'
                                                      : '0',
                                                  index);
                                            },
                                            onPressedDelete: (p0) {
                                              deleteStudent(index);
                                            },
                                            getData: filterData,
                                            refreshData: getData,
                                            mediaQuery: mediaQuery,
                                            searchStudentList:
                                                searchStudentList,
                                            index: index),
                                  )),
                        )
                            .animate(
                              controller: controllerAnimation,
                            )
                            .fade(
                                duration: const Duration(
                                  milliseconds: 200,
                                ),
                                curve: Curves.easeIn),
                      ],
                    ),
                  ),
          );
  }
}
