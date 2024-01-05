// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/accounts_screen/add_admin_btn_widget.dart';
import 'package:bdh/widgets/accounts_screen/admin_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class AllAdminsSlide extends StatefulWidget {
  const AllAdminsSlide({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<AllAdminsSlide> createState() => _AllAdminsSlideState();
}

class _AllAdminsSlideState extends State<AllAdminsSlide> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                padding: EdgeInsets.only(top: widget.mediaQuery.height / 6),
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
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.info,
                          confirmBtnText: 'delete',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.red,
                          onCancelBtnTap: () {
                            Navigator.pop(context);
                          },
                          text:
                              'Are you sure you want to delete this admin (${dataClass.admins[index]['name']})',
                          onConfirmBtnTap: () async {
                            await Provider.of<Apis>(context, listen: false)
                                .deleteAdmin(
                                    dataClass.admins[index]['id'].toString());
                            Navigator.pop(context);
                            Apis.statusResponse == 200
                                ? QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    confirmBtnText: 'cancel',
                                    confirmBtnColor: Colors.green,
                                    text: Apis.message,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        dataClass.admins = Apis.allAdmins;
                                      });
                                    })
                                : QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    confirmBtnText: 'cancel',
                                    confirmBtnColor: Colors.amber,
                                    text: Apis.message,
                                    onConfirmBtnTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                          },
                        );
                      },
                      mediaQuery: widget.mediaQuery,
                      adminName: dataClass.admins[index]['name']),
                ),
              ),
      ],
    );
  }
}
