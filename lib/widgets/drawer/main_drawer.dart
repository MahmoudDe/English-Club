import 'package:bdh/widgets/drawer/start_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'invisble_sub_menu.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      // width: screenWidth / 2,
      child: row(mediaQuery),
    );
  }

  Widget row(Size mediaQuery) {
    return Row(
      children: [
        !isExpanded
            ? startMenuIcon(mediaQuery, context, () {
                setState(() {
                  isExpanded = true;
                });
              })
            : invisibleSubMenu(mediaQuery, context),
      ],
    );
  }
}
