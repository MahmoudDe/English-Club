import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      required this.isMenuOpen,
      required this.mediaQuery,
      required this.animation});
  final bool isMenuOpen;
  final Size mediaQuery;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return isMenuOpen
        ? const SizedBox(
            width: 0,
          )
        : Positioned(
            left: mediaQuery.width / 15,
            bottom: mediaQuery.height / 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Swipe up',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: mediaQuery.width / 10),
                ),
                Text(
                  'To signIn to the english world',
                  style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: mediaQuery.width / 15),
                ),
              ],
            ),
          );
  }
}
