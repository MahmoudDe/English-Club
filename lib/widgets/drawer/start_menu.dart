import 'package:bdh/screens/create_account_screen.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget startMenuIcon(
    Size mediaQuery, BuildContext context, void Function() expanded) {
  return Container(
    width: mediaQuery.width / 5,
    height: double.infinity,
    color: const Color.fromARGB(255, 79, 45, 137),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          IconButton(
              onPressed: expanded,
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.white,
                size: 35,
              )),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          InkWell(
            onTap: () {},
            child: const circleIconWidget(
              color: Color.fromRGBO(254, 178, 91, 1),
              widget: Icon(
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
            child: const circleIconWidget(
              color: Color.fromRGBO(254, 91, 96, 1),
              widget: Icon(
                Iconsax.user,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () {},
            child: const circleIconWidget(
              color: Color.fromRGBO(84, 179, 155, 1),
              widget: Icon(
                Iconsax.setting,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 5,
          ),
          GestureDetector(
            child: const Icon(
              Iconsax.info_circle,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
            child: circleIconWidget(
              color: Colors.white,
              widget: Icon(
                Iconsax.document_upload,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () async {
              await Provider.of<Apis>(context, listen: false).logout();
              // call the logout function
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  StartScreen.routName, (Route<dynamic> route) => false);
            },
            child: circleIconWidget(
              color: Colors.white,
              widget: Icon(
                Iconsax.logout,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ignore: camel_case_types
class circleIconWidget extends StatelessWidget {
  const circleIconWidget({
    super.key,
    required this.color,
    required this.widget,
  });

  final Color color;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(child: widget),
    );
  }
}
