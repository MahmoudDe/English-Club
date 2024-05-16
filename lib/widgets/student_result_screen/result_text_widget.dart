import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResultTextWidget extends StatelessWidget {
  const ResultTextWidget(
      {super.key,
      required this.isPointTimeEnd,
      required this.mediaQuery,
      required this.result});
  final bool isPointTimeEnd;
  final Size mediaQuery;
  final String result;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isPointTimeEnd ? 0.0 : 1.0,
      duration: const Duration(seconds: 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            result,
            style: TextStyle(
              color: Colors.white,
              fontSize: mediaQuery.width / 10,
              shadows: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ).animate().scale(duration: const Duration(seconds: 1)),
    );
  }
}
