import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quickalert/quickalert.dart';

import '../../model/constants.dart';

class StartStepWidget extends StatelessWidget {
  const StartStepWidget(
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
      child: Row(
        mainAxisAlignment: aligmentList[counter],
        children: [
          GestureDetector(
            onTap: () {
              final Random random = Random();
              final int randomIndex = random.nextInt(Constants.wisdoms.length);
              QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                title: 'Wisdom',
                text: Constants.wisdoms[randomIndex],
                confirmBtnColor: Colors.amber,
              );
            },
            child: Container(
              height: mediaQuery.height / 10,
              width: mediaQuery.width / 3.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(360)),
                color: Colors.amber,
                // shape: BoxShape,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(179, 136, 7, 1),
                    offset: Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Start',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: mediaQuery.width / 25),
                ),
              ),
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
          ),
        ],
      ),
    );
  }
}
