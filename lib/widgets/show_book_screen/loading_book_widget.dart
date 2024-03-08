import 'package:bdh/controllers/show_book_controller.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../title_widget.dart';

class LoadingBookWidget extends StatelessWidget {
  const LoadingBookWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
      ),
      body: Column(
        children: [
          TitleWidget(
              mediaQuery: mediaQuery,
              title: showBookController.subLevelName,
              icon: const Icon(Icons.abc)),
          SizedBox(
            height: mediaQuery.height / 3,
          ),
          CircularProgressIndicator(
            color: AppColors.main,
          )
        ],
      ),
    );
  }
}
