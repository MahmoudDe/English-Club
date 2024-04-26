// ignore_for_file: use_build_context_synchronously

import 'package:bdh/model/user.dart';
import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class LevelStepWidget extends StatelessWidget {
  const LevelStepWidget(
      {super.key,
      required this.levelName,
      required this.mediaQuery,
      required this.aligmentList,
      required this.assetUrls,
      required this.showButton,
      required this.counter,
      required this.studentId,
      required this.levelId});
  final Size mediaQuery;
  final List aligmentList;
  final String levelName;
  final List assetUrls;
  final bool showButton;
  final int counter;
  final String studentId;
  final String levelId;

  Future<void> unlockTest(BuildContext context) async {
    try {
      if (await Provider.of<Apis>(context, listen: false)
          .unlockVocabTest(levelId: levelId, studentId: studentId)) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnText: 'Ok',
            text: Apis.message);
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnText: 'Ok',
            text: Apis.message);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQuery.width / 2,
      child: Row(
        mainAxisAlignment: aligmentList[counter],
        children: [
          aligmentList[counter] == MainAxisAlignment.end
              ? SizedBox(
                  height: mediaQuery.height / 7,
                  // width: mediaQuery.width / 3,
                  child: Lottie.asset(assetUrls[0], fit: BoxFit.contain),
                )
              : const SizedBox(),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    details.globalPosition.distance,
                    details.globalPosition.dy,
                    details.globalPosition.dx,
                    details.globalPosition.dy,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  items: [
                    PopupMenuItem(
                      child: Container(
                        height: User.userType == 'admin'
                            ? mediaQuery.height / 5
                            : mediaQuery.height / 6,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.amber,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset:
                                  Offset(0, 1), // changes position of shadow
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: mediaQuery.width / 20,
                                vertical: mediaQuery.height / 40),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Iconsax.star5,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: mediaQuery.width / 40,
                                      ),
                                      Text(
                                        levelName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: mediaQuery.width / 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: mediaQuery.height / 200,
                                  ),
                                  User.userType == 'admin'
                                      ? const Text(
                                          'Unlock the vocabulary test for this student',
                                          style: TextStyle(color: Colors.white),
                                        )
                                      : const Text(
                                          'You can ask the admin to unlock vocabulary test for you',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                  SizedBox(
                                    height: mediaQuery.height / 200,
                                  ),
                                  User.userType == 'admin' && showButton
                                      ? ElevatedButton(
                                          onPressed: () {
                                            unlockTest(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    mediaQuery.width / 8,
                                                vertical:
                                                    mediaQuery.height / 60),
                                          ),
                                          child: const Text(
                                            'unlock test',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontWeight: FontWeight.bold),
                                          ))
                                      : const SizedBox()
                                ]),
                          ),
                        ),
                      ),
                    )
                  ]);
            },
            child: Container(
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
          ),
          aligmentList[counter] != MainAxisAlignment.end
              ? SizedBox(
                  height: mediaQuery.height / 7,
                  // width: mediaQuery.width / 3,
                  child: Lottie.asset(assetUrls[0], fit: BoxFit.contain),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
