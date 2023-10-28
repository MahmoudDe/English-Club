import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        margin: EdgeInsets.symmetric(
            vertical: mediaQuery.height / 60,
            horizontal: mediaQuery.width / 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
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
            color: const Color.fromRGBO(50, 41, 16, 170),
            curve: Curves.easeInSine,
            activeColor: const Color.fromARGB(255, 50, 41, 16),
            tabBackgroundColor: const Color.fromRGBO(50, 41, 16, 220),
            gap: 8,
            padding: EdgeInsets.all(mediaQuery.height / 60),
            onTabChange: (value) {
              setState(() {
                Constants.index = value;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.book,
                text: 'Borrow',
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Constants.secreens[Constants.index],
        ],
      ),
    );
  }
}
