import 'package:flutter/material.dart';

import '../../server/image_url.dart';
import '../../styles/app_colors.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({super.key, required this.studentData});
  final Map studentData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: studentData['profile_picture'] == null
            ? null
            : NetworkImage(
                '${ImageUrl.imageUrl}${studentData['profile_picture']}'),
        backgroundColor: Colors.white,
        child: Center(
            child: Icon(
          Icons.person,
          color: AppColors.main,
        )),
      ),
      title: Text(
        studentData['name'],
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
