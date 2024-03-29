// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/screens/create_student_account_screen.dart';
import 'package:bdh/screens/manage_grades_screen.dart';
import 'package:bdh/screens/upload_excel_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/add_students_screen/button_widget.dart';
import 'package:bdh/widgets/appBar/app_bar_content.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../server/apis.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  bool _isLoading = false;
  // List gradesName = [];
  String selectedGradeFilterValue = '';
  int selectedGradeId = 0;

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).getAllGrades();
      await Provider.of<Apis>(context, listen: false).getAllSections();
      setState(() {
        dataClass.grades = Apis.allGrades['data'];
        dataClass.sections = Apis.sectionsData;
      });

      setState(() {
        for (int i = 0; i < dataClass.grades.length; i++) {
          dataClass.gradesName.add(dataClass.grades[i]['name']);
        }
        selectedGradeFilterValue = dataClass.gradesName[0];
        _isLoading = false;
      });
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
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
              title: const AppBarContent(),
            ),
            body: Column(
              children: [
                TitleWidget(
                  mediaQuery: mediaQuery,
                  title: 'add students account',
                  icon: Icon(
                    Icons.add_circle_sharp,
                    color: AppColors.whiteLight,
                  ),
                ),
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
            appBar: AppBar(
              backgroundColor: AppColors.main,
              title: const AppBarContent(),
            ),
            body: Column(
              children: [
                TitleWidget(
                  mediaQuery: mediaQuery,
                  title: 'add students account',
                  icon: Icon(
                    Icons.add_circle_sharp,
                    color: AppColors.whiteLight,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 5,
                ),
                ButtonWidget(
                  title: 'Add students by excel',
                  mediaQuery: mediaQuery,
                  onTap: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text:
                          'All students that you will upload via Excel will be uploaded without any achievements!',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const UploadExcelScreen(),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Iconsax.document_upload5,
                    color: AppColors.main,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 20,
                ),
                ButtonWidget(
                  title: 'Add students manually',
                  mediaQuery: mediaQuery,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreateStudentAccountScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Iconsax.user_cirlce_add,
                    color: AppColors.main,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 20,
                ),
                ButtonWidget(
                  title: 'Manage grades and classes',
                  mediaQuery: mediaQuery,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageGradesScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Iconsax.setting,
                    color: AppColors.main,
                  ),
                ),
              ],
            ),
          );
  }
}
