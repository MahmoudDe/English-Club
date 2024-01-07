import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_student_screen/empty_data_widget.dart';
import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:bdh/widgets/all_student_screen/search_widgets.dart';
import 'package:bdh/widgets/all_student_screen/studnet_widget.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

  late String selectedGradeFilterValue;
  late String selectedClassFilterValue;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  late TabController? controller;

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).getAllStudents();
      setState(() {
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

  void filterData() {
    setState(() {
      filterStudents = dataClass.students
          .where((element) => element['name'] == selectedGradeFilterValue)
          .toList()[0]['classes']
          .where((e) => e['name'] == selectedClassFilterValue)
          .toList()[0]['students'];
      searchStudentList = [...filterStudents];
    });
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
                : Column(
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FilterWidget(
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
                              mediaQuery: mediaQuery,
                              menu: allGrades,
                              onChanged: (String? newValue) {
                                controllerAnimation!.reverse().whenComplete(() {
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
                          }),
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchStudentList.length,
                            itemBuilder: (context, index) => StudentWidget(
                                mediaQuery: mediaQuery,
                                searchStudentList: searchStudentList,
                                index: index)),
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
          );
  }
}
