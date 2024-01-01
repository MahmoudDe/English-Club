import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/drawer/main_drawer.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.main,
        elevation: 0,
      ),
      body: Column(
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
          const HomeCard()
        ],
      ),
    );
  }
}
