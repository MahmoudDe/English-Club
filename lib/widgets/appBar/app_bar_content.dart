import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../styles/app_colors.dart';

class AppBarContent extends StatelessWidget {
  const AppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
