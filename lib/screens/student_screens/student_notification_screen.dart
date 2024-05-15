// import 'package:bdh/server/apis.dart';
// import 'package:bdh/server/apis.dart';
import 'package:bdh/server/home_provider.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_sections_road/student_widget%20copy.dart';
// import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentNotiScreen extends StatefulWidget {
  const StudentNotiScreen({super.key});

  @override
  State<StudentNotiScreen> createState() => _StudentNotiScreenState();
}

class _StudentNotiScreenState extends State<StudentNotiScreen> {
  List doneTasks = [];
  final scrollController = ScrollController();
  bool isGettingData = false;
  bool isLoading = false;
  int page = 0;

  Future<void> getData() async {
    try {
      await Provider.of<HomeProvider>(context, listen: false)
          .getAllNotificationsStudent(page: '0');
      doneTasks = doneTasks + HomeProvider.notifications;
    } catch (e) {
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
            .getAllNotificationsStudent(page: page.toString());

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
      appBar: AppBar(
        backgroundColor: AppColors.main,
        title: StudentListTileWidget(
          mediaQuery: mediaQuery,
        ),
      ),
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
                        height: mediaQuery.height / 1.2,
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
                                            Text(doneTasks[index]['message']),
                                            ListTile(
                                              title: Text(
                                                'Created at',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      mediaQuery.width / 40,
                                                ),
                                              ),
                                              trailing: Text(
                                                doneTasks[index]['created_at'],
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.bold,
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
                                            color: AppColors.main, width: 3),
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
                  ),
      ),
    );
  }
}
