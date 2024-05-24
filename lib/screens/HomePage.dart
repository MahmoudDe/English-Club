// import 'package:bdh/server/apis.dart';
// import 'package:bdh/server/apis.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:bdh/server/home_provider.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/home_screen/general_notification_widget.dart';
import 'package:bdh/widgets/home_screen/students_notification_widget.dart';
// import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController? controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);

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
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.amber)),
                          child: Tabs(
                              controller: controller!, mediaQuery: mediaQuery)),
                      SlidesForTabs(
                        mediaQuery: mediaQuery,
                        controller: controller,
                      ),
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

class Tabs extends StatelessWidget {
  const Tabs({
    required this.controller,
    required this.mediaQuery,
  });
  final Size mediaQuery;
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      dividerColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 20),
      tabAlignment: TabAlignment.fill,
      tabs: const [
        Tab(
          text: 'General notifications',
        ),
        Tab(
          text: 'Students notifications',
        ),
      ],
    );
  }
}

class SlidesForTabs extends StatelessWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
  });

  final Size mediaQuery;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.height / 1.4,
      child: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          GeneralNotificationWidget(),
          StudentsNotificationWidget(),
        ],
      ),
    );
  }
}
