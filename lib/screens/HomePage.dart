// import 'package:bdh/server/apis.dart';
// import 'package:bdh/server/apis.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:bdh/screens/start_screen.dart';
import 'package:bdh/server/home_provider.dart';
import 'package:bdh/styles/app_colors.dart';
// import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, value, child) => HomeProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.main,
                ),
              )
            : HomeProvider.isError
                ? const Center(
                    child: Text('An error when getting data happened'),
                  )
                : isLoadingData
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppColors.main,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(
                            mediaQuery: mediaQuery,
                            title: 'Notifications',
                            icon: Icon(
                              Icons.notifications_active,
                              color: AppColors.whiteLight,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height / 1.3,
                            child: ListView.builder(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: doneTasks.length + (isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == doneTasks.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: mediaQuery.height / 80),
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
                                                    fontSize:
                                                        mediaQuery.width / 15),
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
                                                Text(doneTasks[index]
                                                    ['message']),
                                                ListTile(
                                                  title: Text(
                                                    'Created at',
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          mediaQuery.width / 40,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    doneTasks[index]
                                                        ['created_at'],
                                                    style: TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          mediaQuery.width / 40,
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
                                            border: Border.all(
                                                color: AppColors.main,
                                                width: 3),
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
                          )
                        ],
                      ).animate(delay: const Duration(seconds: 1)).slide(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                          duration: const Duration(
                            microseconds: 500,
                          ),
                        ),
      ),
    );
  }
}
