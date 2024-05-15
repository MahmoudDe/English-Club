// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../server/apis.dart';
import '../../server/image_url.dart';
import '../../styles/app_colors.dart';

class StudentListTileWidget extends StatelessWidget {
  StudentListTileWidget({
    super.key,
    required this.mediaQuery,
  });
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return  ListTile(
        leading: CircleAvatar(
          backgroundImage: Apis.studentModel!.profilePicture == null
              ? null
              : NetworkImage(
                  '${ImageUrl.imageUrl}${Apis.studentModel!.profilePicture}'),
          backgroundColor: Colors.white,
          child: Apis.studentModel!.profilePicture != null
              ? const SizedBox()
              : Center(
                  child: Icon(
                  Icons.person,
                  color: AppColors.main,
                )),
        ),
        title: Text(
          Apis.studentModel!.name!,
          style: TextStyle(
              color:
                  Apis.studentRoadMap.isEmpty ? AppColors.main : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      )
    ;
  }
}
