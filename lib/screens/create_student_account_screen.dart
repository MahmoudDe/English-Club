import 'package:bdh/data/data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/create_account_screen/form_widget.dart';

// import 'package:provider/provider.dart';

// ignore: camel_case_types
class CreateStudentAccountScreen extends StatefulWidget {
  const CreateStudentAccountScreen({super.key});

  @override
  State<CreateStudentAccountScreen> createState() =>
      _CreateStudentAccountScreenState();
}

// ignore: camel_case_types
class _CreateStudentAccountScreenState
    extends State<CreateStudentAccountScreen> {
  bool isLoading = false;

  void initState() {
    print(dataClass.gradesName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
            ),
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.main,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
            ),
            body: Stack(
              children: [
                FormCreatAccountWidget(
                  mediaQuery: mediaQuery,
                ),
              ],
            ),
          );
  }
}
