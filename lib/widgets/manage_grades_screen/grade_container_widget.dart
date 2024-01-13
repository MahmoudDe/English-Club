import 'package:bdh/screens/manage_grades_screen.dart';
import 'package:bdh/widgets/manage_grades_screen/add_grade_class_btn_widget.dart';
import 'package:bdh/widgets/manage_grades_screen/class_item_widget.dart';
import 'package:bdh/widgets/manage_grades_screen/delete_grade_class.dart';
import 'package:bdh/widgets/manage_grades_screen/edit_grade_class.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class GradeContainerWidget extends StatelessWidget {
  const GradeContainerWidget(
      {super.key, required this.mediaQuery, required this.grade});
  final Size mediaQuery;
  final Map grade;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 30,
              vertical: mediaQuery.height / 60),
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 30,
              vertical: mediaQuery.height / 60),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.main),
            color: AppColors.whiteLight,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                addingTitle: 'Adding Class',
                labelText: 'Class name',
                hintText: 'EX: Class A',
                onTextFiledEmptyErrorText: 'You have to enter class name',
                dialogLabelText: Text(
                  grade['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                isGrade: false,
                gradeId: grade['id'],
                backgroundBtnColor: Colors.amber,
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  grade['classes'].length,
                  (index) => ClassItemWidget(
                      classItem: grade['classes'][index],
                      mediaQuery: mediaQuery),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            top: mediaQuery.height / 80,
            right: mediaQuery.width / 30,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                DeleteGradeClass().deleteGradeClass(
                    context: context,
                    mediaQuery: mediaQuery,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const ManageGradesScreen(),
                        ),
                      );
                    },
                    removingTitle: 'removing grade',
                    isGrade: true,
                    gradeId: grade['id'],
                    classId: 0,
                    name: 'grade',
                    warning:
                        'All student inside this grade will be without grade and class');
              },
            )),
        Positioned(
            top: mediaQuery.height / 80,
            left: mediaQuery.width / 30,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                EditGradeClass().editGradeClass(
                  mediaQuery: mediaQuery,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageGradesScreen(),
                        ));
                  },
                  labelText: 'grade new name',
                  hintText: 'EX: Grade 10',
                  onTextFiledEmptyErrorText: 'You have to enter grade name',
                  isGrade: true,
                  gradeId: grade['id'],
                  classId: 0,
                  EditingTitle: 'Editing grade name',
                  context: context,
                );
              },
            )),
      ],
    );
  }
}
