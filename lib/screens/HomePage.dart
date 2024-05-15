// import 'package:bdh/server/apis.dart';
// import 'package:bdh/server/apis.dart';
import 'package:bdh/server/home_provider.dart';
import 'package:bdh/styles/app_colors.dart';
// import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getData() async {
    try {
      await Provider.of<HomeProvider>(context, listen: false)
          .getAllNotifications(page: '0');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
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
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: HomeProvider.notifications.length,
                          itemBuilder: (context, index) {
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
                                          Text(HomeProvider.notifications[index]
                                              ['message']),
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
                                              HomeProvider.notifications[index]
                                                  ['created_at'],
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
                                  trailing: HomeProvider.notifications[index]
                                              ['read'] ==
                                          0
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
                                    HomeProvider.notifications[index]['title'],
                                    style: TextStyle(
                                        color: AppColors.main,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: SizedBox(
                                    width: mediaQuery.width / 2,
                                    child: Text(
                                      HomeProvider.notifications[index]
                                          ['message'],
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
