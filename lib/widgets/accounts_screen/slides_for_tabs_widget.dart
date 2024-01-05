// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/widgets/accounts_screen/all_admins_slide.dart';
import 'package:bdh/widgets/accounts_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class SlidesForTabs extends StatefulWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
  });

  final Size mediaQuery;
  final TabController? controller;

  @override
  State<SlidesForTabs> createState() => _SlidesForTabsState();
}

class _SlidesForTabsState extends State<SlidesForTabs> {
  List<String> allGrades = [];
  List<String> allClassesInGrade = [];
  List filterdStudents = [];
  List _filterData = [];

  late String selectedGradeFilterValue;
  late String selectedClassFilterValue;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    for (int i = 0; i < dataClass.students.length; i++) {
      allGrades.add(dataClass.students[i]['name']);
    }
    for (int i = 0; i < dataClass.students[0]['classes'].length; i++) {
      allClassesInGrade.add(dataClass.students[0]['classes'][i]['name']);
    }
    selectedGradeFilterValue = dataClass.students[0]['name'];
    selectedClassFilterValue = dataClass.students[0]['classes'][0]['name'];
    print(selectedClassFilterValue);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    filterdStudents = dataClass.students
        .where((element) => element['name'] == selectedGradeFilterValue)
        .toList()[0]['classes']
        .where((e) => e['name'] == selectedClassFilterValue)
        .toList();
    _filterData = [...filterdStudents[0]['students']];

    return SizedBox(
      width: double.infinity,
      height: widget.mediaQuery.height / 1.5,
      child: TabBarView(
        controller: widget.controller,
        children: [
          dataClass.students.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/lotties/empty.json',
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilterWidget(
                            mediaQuery: widget.mediaQuery,
                            menu: allClassesInGrade,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedClassFilterValue = newValue!;
                              });
                            },
                            value: selectedClassFilterValue,
                            filterTitle: 'Class',
                          ),
                          SizedBox(
                            width: widget.mediaQuery.width / 20,
                          ),
                          FilterWidget(
                            mediaQuery: widget.mediaQuery,
                            menu: allGrades,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGradeFilterValue = newValue!;
                              });
                              List selectedGrade = [];
                              setState(
                                () {
                                  selectedGrade = dataClass.students
                                      .where((element) =>
                                          element['name'] == newValue)
                                      .toList();
                                  allClassesInGrade.clear();
                                  selectedClassFilterValue =
                                      selectedGrade[0]['classes'][0]['name'];
                                  for (int i = 0;
                                      i < selectedGrade[0]['classes'].length;
                                      i++) {
                                    allClassesInGrade.add(
                                        selectedGrade[0]['classes'][i]['name']);
                                  }
                                },
                              );
                            },
                            value: selectedGradeFilterValue,
                            filterTitle: 'Grade',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: widget.mediaQuery.width / 25),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          print(_filterData);
                          print('/////////////////');
                          print(filterdStudents);
                          filterData();
                        },
                        decoration: InputDecoration(
                          labelText: 'Search',
                          fillColor: Colors.white.withOpacity(0.5),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Change this to your desired radius
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filterData.length,
                        itemBuilder: (context, index) => Card(
                          child: ExpansionTile(
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.orange,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/bdh_logo.jpeg'),
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.transparent,
                                radius: 23,
                              ),
                            ),
                            title: Text(
                              _filterData[index]['name'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            children: [
                              ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(
                                      left: widget.mediaQuery.width / 5,
                                      bottom: widget.mediaQuery.height / 80),
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
                  ],
                ),
          AllAdminsSlide(mediaQuery: widget.mediaQuery),
        ],
      ),
    );
  }

  void filterData() {
    String searchQuery = _searchController.text.toLowerCase();
    print(searchQuery);
    setState(() {
      _filterData = filterdStudents[0]['students']
          .where((item) => item['name'].toLowerCase().contains(searchQuery))
          .toList();
    });
  }
}
