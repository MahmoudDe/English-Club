import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_student_screen/empty_data_widget.dart';
import 'package:bdh/widgets/all_student_screen/filter_widget.dart';
import 'package:bdh/widgets/all_student_screen/search_widgets.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({
    super.key,
  });

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  List<String> allGrades = [];
  List<String> allClassesInGrade = [];
  List filterStudents = [];
  List searchStudentList = [];

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
    getData();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                                setState(() {
                                  selectedClassFilterValue = newValue!;
                                  filterData();
                                });
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
                                setState(() {
                                  selectedGradeFilterValue = newValue!;
                                  changeClasses();
                                  filterData();
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
                          itemBuilder: (context, index) => Card(
                            child: Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                extentRatio: 1 / 2,
                                dragDismissible: false,
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => print('hello'),
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (context) => print('hello'),
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    icon: Icons.person_off,
                                    label: 'disActive',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) => print('hello'),
                                    backgroundColor: Colors.brown,
                                    foregroundColor: Colors.white,
                                    icon: Iconsax.scan,
                                    label: 'borrow book',
                                  ),
                                ],
                              ),
                              child: ExpansionTile(
                                leading: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.orange,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/bdh_logo.jpeg'),
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.transparent,
                                    radius: 23,
                                  ),
                                ),
                                title: Text(
                                  searchStudentList[index]['name'],
                                  style: const TextStyle(fontSize: 18),
                                ),
                                children: [
                                  ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(
                                          left: mediaQuery.width / 5,
                                          bottom: mediaQuery.height / 80),
                                      child: const Text(
                                        '',
                                        style: TextStyle(fontFamily: 'Avenir'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }
}
