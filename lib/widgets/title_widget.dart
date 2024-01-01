import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {super.key,
      required this.mediaQuery,
      required this.title,
      required this.icon});
  final Size mediaQuery;
  final String title;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 20, vertical: mediaQuery.height / 200),
      decoration: BoxDecoration(color: AppColors.mainLight),
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: mediaQuery.width / 18,
                color: AppColors.whiteLight,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: mediaQuery.width / 40,
          ),
        ],
      ),
    );
  }
}
