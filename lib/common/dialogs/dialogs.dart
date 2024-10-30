import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:quickalert/quickalert.dart';

import '../../styles/app_colors.dart';

void loadingDialog(
    {required BuildContext context,
    required Size mediaQuery,
    String title = ''}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: mediaQuery.width / 8,
          ),
          SizedBox(
            height: mediaQuery.height / 90,
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    ),
  );
}

void internetToast({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('No Internet'),
  ));
}

void serverToast({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Server is not responding'),
  ));
}

void errorDialog({
  required BuildContext context,
  required String text,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Error',
        style: const TextStyle(color: Colors.red),
      ),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.main.withOpacity(0.1),
            ),
          ),
          child: Text(
            'Ok',
            style: const TextStyle(color: AppColors.primaryColor),
            // style: textStyle,
          ),
        ),
      ],
    ),
  );
  // QuickAlert.show(
  //   context: context,
  //   type: QuickAlertType.error,
  //   text: text,
  //   confirmBtnColor: Colors.red,
  // );
}

void infoDialog({
  required BuildContext context,
  required String text,
}) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    text: text,
    confirmBtnColor: Colors.amber.shade400,
  );
}

void successDialog({
  required BuildContext context,
  required String text,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Success',
        style: const TextStyle(color: Colors.green),
      ),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.primaryColor.withOpacity(0.1),
            ),
          ),
          child: Text(
            'Ok',
            style: const TextStyle(color: AppColors.primaryColor),
            // style: textStyle,
          ),
        ),
      ],
    ),
  );
}

void showExpiredDialog({
  required BuildContext context,
  required void Function()? onConfirmBtnTap,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Session Expired',
        style: TextStyle(
            color: AppColors.primaryColor.withOpacity(0.9), fontSize: 18),
      ),
      // content: Text(S.of(context).expired),
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              AppColors.primaryColor.withOpacity(0.3),
            ),
          ),
          onPressed: onConfirmBtnTap,
          child: Text(
            'Login',
            style: const TextStyle(
                color: AppColors.primaryColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
  // QuickAlert.show(
  //     context: context,
  //     disableBackBtn: false,
  //     barrierDismissible: false,
  //     type: QuickAlertType.error,
  //     text:
  //         'Your session has expired due to inactivity.\nPlease log in again to continue.',
  //     confirmBtnText: 'ok',
  //     confirmBtnColor: Colors.red,
  //     onConfirmBtnTap: onConfirmBtnTap);
}

void loginErrorDialog({
  required BuildContext context,
  required String errorMessage,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox(); // We don't need this
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: anim1.value,
        child: Opacity(
          opacity: anim1.value,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.error_outline,
                      color: AppColors.primaryColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Login Failed',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Ok',
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
