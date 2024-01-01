import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SlidesForTabs extends StatelessWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
    required this.students,
    required this.admins,
  });

  final Size mediaQuery;
  final TabController? controller;
  final List students;
  final List admins;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.height / 1.5,
      child: TabBarView(
        controller: controller,
        children: [
          students.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/lotties/empty.json',
                  ),
                )
              : const Text('hello'),
          admins.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/lotties/empty.json',
                  ),
                )
              : const Text('goodbay'),
        ],
      ),
    );
  }
}
