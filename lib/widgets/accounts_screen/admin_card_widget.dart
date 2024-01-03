import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ignore: must_be_immutable
class AdminCardWidget extends StatelessWidget {
  AdminCardWidget(
      {super.key,
      required this.mediaQuery,
      required this.adminName,
      required this.onPressed});
  final Size mediaQuery;
  final String adminName;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.main,
            child: const Icon(Iconsax.security_user)),
        trailing: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            )),
        title: Text(
          adminName,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
