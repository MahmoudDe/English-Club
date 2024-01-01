import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/create_account_screen.dart';
import '../../screens/start_screen.dart';
import 'head_profile_widget.dart';

Widget invisibleSubMenu(Size mediaQuery, BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: mediaQuery.width / 20),
    width: mediaQuery.width / 1.5,
    height: double.infinity,
    color: const Color.fromARGB(255, 79, 45, 137),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          GestureDetector(
            onTap: () {},
            child: headProfileWidget(
              name: 'Admin',
              subTitle: 'Admin',
              icon: const Icon(
                CupertinoIcons.person,
                size: 25,
              ),
              circleColor: Colors.white,
              screenHight: mediaQuery.width,
              screenWidth: mediaQuery.height,
              nameColor: Colors.white,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          InkWell(
            onTap: () {},
            child: circleIconWidget2(
              iconName: 'Home',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(254, 178, 91, 1),
              widget: const Icon(
                Iconsax.home,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 15,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateAccountScreen(),
              ));
            },
            child: circleIconWidget2(
              iconName: 'Crate user account',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(254, 91, 96, 1),
              widget: const Icon(
                Iconsax.user,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () {},
            child: circleIconWidget2(
              iconName: 'Settings',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(84, 179, 155, 1),
              widget: const Icon(
                Iconsax.setting,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 5,
          ),
          Container(
            margin: EdgeInsets.only(left: mediaQuery.width / 40),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Iconsax.info_circle,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: mediaQuery.width / 20,
                ),
                const Text(
                  'About us',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Euclid Circular A'),
                )
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: const Divider(
              color: Colors.white,
              height: 10,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () {},
            child: circleIconWidget2(
              iconName: 'Up load data',
              mediaQuery: mediaQuery,
              color: Colors.white,
              widget: Icon(
                Iconsax.document_upload,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () async {
              // call the logout function
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  StartScreen.routName, (Route<dynamic> route) => false);
            },
            child: circleIconWidget2(
              iconName: 'Log out',
              mediaQuery: mediaQuery,
              color: Colors.white,
              widget: Icon(
                Iconsax.logout,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: camel_case_types

// ignore: camel_case_types
class circleIconWidget2 extends StatelessWidget {
  const circleIconWidget2({
    super.key,
    required this.color,
    required this.widget,
    required this.mediaQuery,
    required this.iconName,
  });

  final Color color;
  final Widget widget;
  final Size mediaQuery;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(child: widget),
          ),
          SizedBox(
            width: mediaQuery.width / 20,
          ),
          Text(
            iconName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Euclid Circular A'),
          )
        ],
      ),
    );
  }
}
