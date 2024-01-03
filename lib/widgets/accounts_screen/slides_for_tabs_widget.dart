// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/accounts_screen/add_admin_btn_widget.dart';
import 'package:bdh/widgets/accounts_screen/admin_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SlidesForTabs extends StatefulWidget {
  SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
    required this.students,
  });

  final Size mediaQuery;
  final TabController? controller;
  final List students;

  @override
  State<SlidesForTabs> createState() => _SlidesForTabsState();
}

class _SlidesForTabsState extends State<SlidesForTabs> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.mediaQuery.height / 1.5,
      child: TabBarView(
        controller: widget.controller,
        children: [
          widget.students.isEmpty
              ? Center(
                  child: Lottie.asset(
                    'assets/lotties/empty.json',
                  ),
                )
              : const Text('hello'),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AddAdminBtnWidget(
                mediaQuery: widget.mediaQuery,
                onPressed: () {
                  setState(() {
                    dataClass.admins = Apis.allAdmins;
                  });
                  Navigator.pop(context);
                },
              ),
              dataClass.admins.isEmpty
                  ? Padding(
                      padding:
                          EdgeInsets.only(top: widget.mediaQuery.height / 6),
                      child: Center(
                        child: Lottie.asset(
                          'assets/lotties/empty.json',
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: dataClass.admins.length,
                        itemBuilder: (context, index) => AdminCardWidget(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Admin'),
                                  content: Text(
                                      'Are you sure you want to delete this admin (${dataClass.admins[index]['name']})'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Provider.of<Apis>(context,
                                                listen: false)
                                            .deleteAdmin(dataClass.admins[index]
                                                    ['id']
                                                .toString());
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Admin'),
                                            content: Text(Apis.message),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      dataClass.admins =
                                                          Apis.allAdmins;
                                                    });
                                                  },
                                                  child: const Text('Cancel'))
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Yes',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            mediaQuery: widget.mediaQuery,
                            adminName: dataClass.admins[index]['name']),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
