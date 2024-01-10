import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.mediaQuery,
      required this.onTap,
      required this.icon,
      required this.title});
  final Size mediaQuery;
  final void Function()? onTap;
  final Widget icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 10),
      height: mediaQuery.height / 10,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: mediaQuery.height / 40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            SizedBox(
              width: mediaQuery.width / 30,
            ),
            Text(
              title,
              style: TextStyle(
                  color: AppColors.main,
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.width / 30),
            ),
          ],
        ),
      ),
    );
  }
}
