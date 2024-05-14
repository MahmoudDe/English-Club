// ignore_for_file: must_be_immutable

import 'package:bdh/model/user.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/start_screen.dart';
import '../../screens/student_screens/student_home_screen.dart';
import '../../server/apis.dart';
import '../../server/image_url.dart';
import '../../styles/app_colors.dart';

class StudentSettingsWidget extends StatelessWidget {
  StudentSettingsWidget(
      {super.key,
      required this.mediaQuery,
      required this.studentData,
      required this.studentId,
      required this.animationController});
  final Size mediaQuery;
  final Map studentData;
  final String studentId;
  AnimationController animationController;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mediaQuery.height / 27),
      child: ListTile(
        trailing: PopupMenuButton<String>(
          onOpened: _iconTab,
          onCanceled: _iconTab,
          offset: Offset(0, mediaQuery.height / 20),
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: animationController,
            size: mediaQuery.width / 15,
            color: Apis.studentRoadMap.isEmpty ? AppColors.main : Colors.white,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Add_students',
                child: TextButton.icon(
                  label: Text(
                    'Your profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.main),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentHomeScreen(studentId: studentId),
                      ),
                    );
                  },
                  icon: Icon(
                    Iconsax.user_cirlce_add,
                    color: AppColors.main,
                  ),
                ),
              ),
              User.userType != 'student'
                  ? const PopupMenuItem<String>(
                      value: 'logout', child: SizedBox())
                  : PopupMenuItem<String>(
                      value: 'logout',
                      child: TextButton.icon(
                        label: Text(
                          'Logout',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.main),
                        ),
                        onPressed: () async {
                          if (await Provider.of<Apis>(context, listen: false)
                              .logout()) {
                            // call the logout function
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.remove('token');
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                StartScreen.routName,
                                (Route<dynamic> route) => false);
                          }
                        },
                        icon: Icon(
                          Icons.logout,
                          color: AppColors.main,
                        ),
                      ),
                    ),
            ];
          },
        ),
        leading: CircleAvatar(
          backgroundImage: studentData['profile_picture'] == null
              ? null
              : NetworkImage(
                  '${ImageUrl.imageUrl}${studentData['profile_picture']}'),
          backgroundColor: Colors.white,
          child: studentData['profile_picture'] != null
              ? const SizedBox()
              : Center(
                  child: Icon(
                  Icons.person,
                  color: AppColors.main,
                )),
        ),
        title: Text(
          studentData['name'],
          style: TextStyle(
              color:
                  Apis.studentRoadMap.isEmpty ? AppColors.main : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
