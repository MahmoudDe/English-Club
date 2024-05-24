import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/start_screen.dart';
import '../../server/home_provider.dart';
import '../../styles/app_colors.dart';

class GeneralNotificationWidget extends StatefulWidget {
  const GeneralNotificationWidget({
    super.key,
  });

  @override
  State<GeneralNotificationWidget> createState() =>
      _GeneralNotificationWidgetState();
}

class _GeneralNotificationWidgetState extends State<GeneralNotificationWidget> {
  List doneTasks = [];
  final scrollController = ScrollController();
  bool isGettingData = false;
  bool isLoading = false;
  int page = 0;
  bool isLoadingData = false;

  Future<void> getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<HomeProvider>(context, listen: false)
          .getAllNotifications(page: '0');
      setState(() {
        isLoading = false;
      });
      if (HomeProvider.isError) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          barrierDismissible: false,
          confirmBtnColor: Colors.red,
          text: 'Your session has expired.\n Please log in again.',
          confirmBtnText: 'LogIn',
          onConfirmBtnTap: () async {
            // call the logout function
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            Navigator.of(context).pushNamedAndRemoveUntil(
                StartScreen.routName, (Route<dynamic> route) => false);
          },
        );
      }
      doneTasks = doneTasks + HomeProvider.notifications;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  late TabController? controller;

  Future pagination() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      page++;
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<HomeProvider>(context, listen: false)
            .getAllNotifications(page: page.toString());

        setState(() {
          doneTasks = doneTasks + HomeProvider.notifications;
          isLoading = false;
        });
      } catch (e) {
        print(e);
      }
      print(page);
    }
  }

  @override
  void initState() {
    getData();
    scrollController.addListener(pagination);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isGettingData
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.main,
            ),
          )
        : SizedBox(
            height: mediaQuery.height / 1.4,
            child: ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: doneTasks.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == doneTasks.length) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: mediaQuery.height / 80),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.main,
                      ),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Row(
                            children: [
                              Text(
                                'Message',
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: mediaQuery.width / 15),
                              ),
                              const Icon(
                                Icons.message,
                                color: Colors.amber,
                              )
                            ],
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(doneTasks[index]['message']),
                                ListTile(
                                  title: Text(
                                    'Created at',
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.width / 40,
                                    ),
                                  ),
                                  trailing: Text(
                                    doneTasks[index]['created_at'],
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.width / 40,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        trailing: doneTasks[index]['read'] == 0
                            ? Container(
                                height: mediaQuery.height / 40,
                                width: mediaQuery.width / 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null,
                        leading: Container(
                          height: mediaQuery.height / 15,
                          width: mediaQuery.width / 9,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.main, width: 3),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.amber,
                          ),
                        ),
                        title: Text(
                          doneTasks[index]['title'],
                          style: TextStyle(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: SizedBox(
                          width: mediaQuery.width / 2,
                          child: Text(
                            doneTasks[index]['message'],
                            style: const TextStyle(
                              color: Colors.black45,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          );
  }
}
