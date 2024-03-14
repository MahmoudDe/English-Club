import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CancelWidget extends StatelessWidget {
  const CancelWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text:
              'If you exit the test, all your answers will disappear.\nAre you sure?',
          cancelBtnText: 'no',
          confirmBtnColor: Colors.red,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnglishClubSettingsScreen(),
                ));
          },
        );
      },
      icon: Icon(
        Icons.cancel_outlined,
        color: Colors.white,
        size: mediaQuery.width / 15,
      ),
    );
  }
}
