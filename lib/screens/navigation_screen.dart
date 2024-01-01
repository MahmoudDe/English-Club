import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../model/constants.dart';

class NavigationScreen extends StatefulWidget {
  static const String routeName = '/navigation-screen';
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 15,
              vertical: mediaQuery.height / 200),
          child: GNav(
            color: Colors.white,
            curve: Curves.easeInSine,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.white10,
            gap: 8,
            padding: EdgeInsets.all(mediaQuery.height / 60),
            onTabChange: (value) {
              setState(() {
                Constants.index = value;
              });
            },
            tabs: const [
              GButton(
                icon: Iconsax.home,
                text: 'Home',
              ),
              GButton(
                icon: Iconsax.search_normal_1,
                text: 'Search',
              ),
              GButton(
                icon: Iconsax.book_1,
                text: 'Borrow',
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Constants.screens[Constants.index],
        ],
      ),
    );
  }
}
