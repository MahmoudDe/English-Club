import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget(
      {super.key,
      required this.mediaQuery,
      required this.value,
      required this.onChanged,
      required this.menu,
      required this.filterTitle,
      required this.width});
  final String filterTitle;
  final Size mediaQuery;
  final double width;
  final String? value;
  final void Function(String?)? onChanged;
  final List<dynamic> menu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 50),
      height: mediaQuery.height / 20,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.main, width: 2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              filterTitle,
              style: TextStyle(fontSize: mediaQuery.width / 35),
            ),
            SizedBox(
              width: mediaQuery.width / 90,
            ),
            DropdownButton<String>(
              dropdownColor: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(3)),
              elevation: 10,
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
              value: value,
              onChanged: onChanged,
              items: menu.map(
                (value) {
                  return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: mediaQuery.width / 35),
                      ),
                      onTap: () async {});
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
