import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/appBar/app_bar_content.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({super.key});

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
        ],
      ),
    );
  }
}
