import 'package:bdh/styles/app_colors.dart';
// import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
          ElevatedButton(onPressed: () {}, child: const Text('Send message'))
        ],
      ),
    );
  }
}
