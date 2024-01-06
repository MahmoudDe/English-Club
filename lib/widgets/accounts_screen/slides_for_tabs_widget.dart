// ignore_for_file: use_build_context_synchronously

import 'package:bdh/widgets/accounts_screen/all_admins_slide.dart';
import 'package:bdh/widgets/accounts_screen/all_students_slide.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SlidesForTabs extends StatefulWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
  });

  final Size mediaQuery;
  final TabController? controller;

  @override
  State<SlidesForTabs> createState() => _SlidesForTabsState();
}

class _SlidesForTabsState extends State<SlidesForTabs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.mediaQuery.height / 1.38,
      child: TabBarView(
        controller: widget.controller,
        children: [
          AllStudentsSlide(mediaQuery: widget.mediaQuery),
          AllAdminsSlide(mediaQuery: widget.mediaQuery),
        ],
      ),
    );
  }
}
