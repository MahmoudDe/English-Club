import 'package:bdh/screens/add_students_screen.dart';
import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/screens/prizes_screen.dart';
import 'package:bdh/screens/toDo_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/appBar/app_bar_content.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class appBarWidget {
  appBarWidget(
      {required this.animationController,
      required this.mediaQuery,
      required this.onPressed,
      required this.onPressedList});
  AnimationController animationController;
  Size mediaQuery;
  void Function()? onPressed;
  void Function()? onPressedList;

  bool _isIconTabes = false;
  void _iconTab() {
    if (_isIconTabes) {
      animationController.reverse();
      _isIconTabes = false;
    } else {
      animationController.forward();
      _isIconTabes = true;
    }
  }

  PreferredSizeWidget? customAppBar() {
    return AppBar(
      backgroundColor: AppColors.main,
      title: const AppBarContent(),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 100,
              vertical: mediaQuery.height / 100),
          child: PopupMenuButton<String>(
            onOpened: _iconTab,
            onCanceled: _iconTab,
            offset: Offset(0, mediaQuery.height / 20),
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: animationController,
              size: mediaQuery.width / 15,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'prizes',
                  child: TextButton.icon(
                    label: Text(
                      'Students prizes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrizeScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.star_rate_rounded,
                      color: AppColors.main,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'ToDo list',
                  child: TextButton.icon(
                    label: Text(
                      'ToDo tasks',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ToDoScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.list_alt,
                      color: AppColors.main,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'English_Club',
                  child: TextButton.icon(
                    label: Text(
                      'English club',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const EnglishClubSettingsScreen(),
                        ),
                      );
                      print('hello');
                    },
                    icon: Icon(
                      Icons.settings_rounded,
                      color: AppColors.main,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Add_students',
                  child: TextButton.icon(
                    label: Text(
                      'Add students',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddStudentsScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Iconsax.user_cirlce_add,
                      color: AppColors.main,
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: TextButton.icon(
                    label: Text(
                      'Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.logout,
                      color: AppColors.main,
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }
}
