import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:bdh/screens/toDo_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/snack_bar_widget.dart';
import '../model/constants.dart';
import '../server/apis.dart';
import '../widgets/appBar/app_bar_widget.dart';

class NavigationScreen extends StatefulWidget {
  static const String routeName = '/navigation-screen';
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    FirebaseMessaging.onMessage.listen((event) {
      print('WE HAVE NEW EVENT ');
      print(event.from);
      print(event.category);
      print(event.data);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBarWidget(
                title: event.notification!.title.toString(),
                message: event.notification!.body.toString(),
                contentType: ContentType.help)
            .getSnakBar());
    });

    super.initState();
  }

  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarWidget(
          onPressedList: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ToDoScreen(),
            ));
          },
          animationController: _animationController,
          mediaQuery: mediaQuery,
          onPressed: () async {
            await Provider.of<Apis>(context, listen: false).logout();
            // call the logout function
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('token');
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamedAndRemoveUntil(
                StartScreen.routName, (Route<dynamic> route) => false);
          }).customAppBar(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                controller.animateToPage(value,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCirc);
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
                icon: Iconsax.security_user,
                text: 'Accounts',
              ),
            ],
          ),
        ),
      ),
      body: PageView(
          controller: controller,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          pageSnapping: true,
          allowImplicitScrolling: false,
          onPageChanged: null,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Constants.screens[0],
            Constants.screens[1],
            Constants.screens[2],
          ]),
    );
  }
}
