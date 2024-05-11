import 'package:flutter/material.dart';

import '../../server/apis.dart';
import '../../server/image_url.dart';
import '../../styles/app_colors.dart';

class StudentImageWidget extends StatelessWidget {
  const StudentImageWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQuery.width / 2,
      height: mediaQuery.height / 5,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.main),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Apis.studentModel!.profilePicture == null
          ? Center(
              child: Icon(
                Icons.person,
                color: AppColors.main,
                size: mediaQuery.width / 5,
              ),
            )
          : Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.main,
                  ),
                  CircleAvatar(
                    radius: mediaQuery.width / 5,
                    // minRadius: 0.4,
                    foregroundImage: NetworkImage(
                      '${ImageUrl.imageUrl}${Apis.studentModel!.profilePicture}',
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
