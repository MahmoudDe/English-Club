import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/accounts_screen/slides_for_tabs_widget.dart';
import '../widgets/accounts_screen/tabs_info_widget.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late TabController? controller;
  List students = [];

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
              elevation: 0,
            ),
            body: Column(
              children: [
                TitleWidget(
                    mediaQuery: mediaQuery,
                    title: 'Accounts',
                    icon: const SizedBox(
                      width: 0,
                    )),
                SizedBox(
                  height: mediaQuery.height / 3,
                ),
                CircularProgressIndicator(
                  color: AppColors.main,
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.main,
              elevation: 0,
            ),
            body: Column(
              children: [
                TitleWidget(
                  mediaQuery: mediaQuery,
                  title: 'Accounts',
                  icon: Icon(
                    Icons.person,
                    color: AppColors.whiteLight,
                  ),
                ),
                TabsTeamInfo(controller: controller, mediaQuery: mediaQuery),
                SlidesForTabs(
                  mediaQuery: mediaQuery,
                  controller: controller,
                  admins: [],
                  students: [],
                ),
              ],
            ),
          );
  }
}
