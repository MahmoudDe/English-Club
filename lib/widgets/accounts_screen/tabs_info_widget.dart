import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

class TabsTeamInfo extends StatefulWidget {
  const TabsTeamInfo({
    super.key,
    required this.controller,
    required this.mediaQuery,
  });
  final Size mediaQuery;

  final TabController? controller;

  @override
  State<TabsTeamInfo> createState() => _TabsTeamInfoState();
}

class _TabsTeamInfoState extends State<TabsTeamInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widget.mediaQuery.width / 30,
          vertical: widget.mediaQuery.height / 40),
      height: widget.mediaQuery.height / 20,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TabBar(
        controller: widget.controller,
        tabs: [
          Tab(
            child: Text(
              'Students',
              style: TextStyle(color: AppColors.main),
            ),
          ),
          Tab(
            child: Text(
              'admins',
              style: TextStyle(color: AppColors.main),
            ),
          ),
        ],
      ),
    );
  }
}
