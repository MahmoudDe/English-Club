import 'package:bdh/data/data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/accounts_screen/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AllStudentsSlide extends StatefulWidget {
  const AllStudentsSlide({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<AllStudentsSlide> createState() => _AllStudentsSlideState();
}

class _AllStudentsSlideState extends State<AllStudentsSlide> {
  List<String> allGrades = [];
  List<String> allClassesInGrade = [];
  List filterStudents = [];
  List searchStudentList = [];

  late String selectedGradeFilterValue;
  late String selectedClassFilterValue;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    for (int i = 0; i < dataClass.students.length; i++) {
      allGrades.add(dataClass.students[i]['name']);
    }
    selectedGradeFilterValue = dataClass.students[0]['name'];
    changeClasses();
    filterData();
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
    return dataClass.students.isEmpty
        ? Center(
            child: Lottie.asset(
              'assets/lotties/empty.json',
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
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
                          filterData();
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.mediaQuery.width / 25,
                    vertical: widget.mediaQuery.height / 80),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    search();
                  },
                  cursorColor: AppColors.main,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    fillColor: Colors.white.withOpacity(0.5),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.main),
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
                  itemCount: searchStudentList.length,
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
                        searchStudentList[index]['name'],
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
          );
  }
}
