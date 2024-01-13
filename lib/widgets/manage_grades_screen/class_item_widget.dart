import 'package:bdh/widgets/manage_grades_screen/delete_grade_class.dart';
import 'package:bdh/widgets/manage_grades_screen/edit_grade_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../screens/manage_grades_screen.dart';

class ClassItemWidget extends StatelessWidget {
  const ClassItemWidget(
      {super.key, required this.mediaQuery, required this.classItem});
  final Size mediaQuery;
  final Map classItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        key: const ValueKey(0),
        startActionPane: ActionPane(
          extentRatio: 1 / 2,
          dragDismissible: false,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context1) {
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
                    removingTitle: 'removing class',
                    isGrade: false,
                    gradeId: 0,
                    classId: classItem['id'],
                    name: 'class',
                    warning:
                        'All student inside this class will be without any class');

                print(classItem['id']);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (con) {
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
                  labelText: 'class new name',
                  hintText: 'EX: Class A',
                  onTextFiledEmptyErrorText: 'You have to enter class name',
                  isGrade: false,
                  gradeId: classItem['grade_id'],
                  classId: classItem['id'],
                  EditingTitle: 'Editing class name',
                  context: context,
                );
              },
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'edit name',
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            classItem['name'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
