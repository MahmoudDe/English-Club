import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

// ignore: must_be_immutable
class SearchWidget extends StatelessWidget {
  SearchWidget(
      {super.key,
      required this.controller,
      required this.mediaQuery,
      required this.onChanged});
  void Function(String)? onChanged;
  TextEditingController? controller;
  Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 25, vertical: mediaQuery.height / 80),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: AppColors.main,
        decoration: InputDecoration(
          labelText: 'Search',
          fillColor: Colors.white.withOpacity(0.5),
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.main),
            borderRadius: BorderRadius.circular(
                30.0), // Change this to your desired radius
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
