import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class appBarWidget {
  appBarWidget(
      {required this.animationController,
      required this.mediaQuery,
      required this.onPressed});
  AnimationController animationController;
  Size mediaQuery;
  void Function()? onPressed;

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
      title: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Center(
              child: Icon(
            Iconsax.security_user,
            color: AppColors.main,
          )),
        ),
        title: const Text(
          'Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'admin',
          style: TextStyle(color: AppColors.whiteLight),
        ),
      ),
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
                  value: 'English_Club',
                  child: TextButton.icon(
                    label: Text(
                      'English club',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.main),
                    ),
                    onPressed: () {
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
                      print('hello');
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
