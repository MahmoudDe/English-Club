import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/manage_grades_screen/add_grade_class_btn_widget.dart';
import 'package:bdh/widgets/manage_grades_screen/grade_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ManageGradesScreen extends StatefulWidget {
  const ManageGradesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ManageGradesScreenState createState() => _ManageGradesScreenState();
}

class _ManageGradesScreenState extends State<ManageGradesScreen> {
  List allGrades = [];
  bool isloading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> getData() async {
    setState(() {
      isloading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).getAllGrades1();
      setState(() {
        allGrades = Apis.allGrades['data'];
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isloading
        ? Scaffold(
            appBar: AppBar(backgroundColor: AppColors.main),
            body: Center(
                child: CircularProgressIndicator(
              color: AppColors.main,
            )),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AddGradeClassBtnWidget(
                    mediaQuery: mediaQuery,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageGradesScreen(),
                          ));
                    },
                    addingTitle: 'Adding Grade',
                    labelText: 'Grade name',
                    hintText: 'EX: Grade 10',
                    onTextFiledEmptyErrorText: 'You have to enter grade name',
                    dialogLabelText: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Add new Grade'),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                    isGrade: true,
                    gradeId: 0,
                    backgroundBtnColor: AppColors.main,
                  ),
                  allGrades.isEmpty
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: mediaQuery.height / 3,
                            ),
                            Center(
                              child: Lottie.asset(
                                'assets/lotties/empty.json',
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allGrades.length,
                          itemBuilder: (context, index) {
                            return GradeContainerWidget(
                                mediaQuery: mediaQuery,
                                grade: allGrades[index]);
                          },
                        ),
                ],
              ),
            ),
          );
  }
}
