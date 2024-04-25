import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class TitleSubLevelWidget extends StatelessWidget {
  const TitleSubLevelWidget(
      {super.key,
      required this.title,
      required this.mediaQuery,
      required this.screenColor});
  final String title;
  final Size mediaQuery;
  final Color screenColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 20, vertical: mediaQuery.height / 200),
      decoration: BoxDecoration(color: screenColor),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: mediaQuery.width / 25,
            color: AppColors.whiteLight,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
