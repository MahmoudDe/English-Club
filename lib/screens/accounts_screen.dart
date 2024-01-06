// ignore_for_file: avoid_print

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/accounts_screen/all_admins_widget.dart';
import 'package:bdh/widgets/all_student_screen/empty_data_widget.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late TabController? controller;

  void getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).getAllAdmins();
      setState(() {
        dataClass.admins = Apis.allAdmins;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
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
            body: dataClass.admins.isEmpty
                ? EmptyDataWidget(mediaQuery: mediaQuery)
                : Column(
                    children: [
                      TitleWidget(
                        mediaQuery: mediaQuery,
                        title: 'Accounts',
                        icon: Icon(
                          Icons.person,
                          color: AppColors.whiteLight,
                        ),
                      ),
                      Expanded(child: AllAdminsWidget(mediaQuery: mediaQuery)),
                    ],
                  ),
          );
  }
}
