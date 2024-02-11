import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelStepWidget extends StatelessWidget {
  const LevelStepWidget(
      {super.key,
      required this.mediaQuery,
      required this.aligmentList,
      required this.counter});
  final Size mediaQuery;
  final List aligmentList;
  final int counter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQuery.width / 2,
      child: Row(
        mainAxisAlignment: aligmentList[counter],
        children: [
          Container(
            height: mediaQuery.height / 10,
            width: mediaQuery.width / 3.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(360)),
              color: Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(179, 136, 7, 1),
                  offset: Offset(0, 10), // changes position of shadow
                ),
              ],
            ),
            child: Center(
                child: Icon(
              Icons.star_rate_rounded,
              color: Colors.white,
              size: mediaQuery.width / 10,
            )),
          )
              .animate(
                autoPlay: true,
                // onPlay: (controller) => controller.repeat(),
                onComplete: (controller) {
                  controller.repeat(reverse: true, min: 0.9, max: 1.0);
                },
              )
              .scale(
                duration: const Duration(
                  milliseconds: 500,
                ),
              ),
        ],
      ),
    );
  }
}
