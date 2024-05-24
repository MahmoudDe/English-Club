// ignore_for_file: use_build_context_synchronously

import 'package:bdh/model/user.dart';
import 'package:bdh/screens/all_sections_map_roads_screen.dart';
import 'package:bdh/screens/student_screens/student_vocab_test_screen.dart';
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
      required this.isLocked,
      required this.sectionId,
      required this.levelId,
      required this.allSections,
      required this.studentData,
      required this.levelAvailableData});
  final bool isLocked;
  final Size mediaQuery;
  final List aligmentList;
  final String levelName;
  final List assetUrls;
  final bool showButton;
  final int counter;
  final String studentId;
  final String levelId;
  final String sectionId;
  final List<dynamic> allSections;
  final Map<dynamic, dynamic> studentData;
  final Map<dynamic, dynamic> levelAvailableData;

  Future<void> unlockTest(BuildContext context) async {
    try {
      print(levelId);
      if (await Provider.of<Apis>(context, listen: false)
          .unlockVocabTest(levelId: levelId, studentId: studentId)) {
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        print('student id => $studentId');
        print('student data => $studentData');
        print('all sections => $allSections');
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AllSectionsMapRoadsScreen(
              allSections: [],
              mediaQuery: mediaQuery,
              studentData: studentData,
              studentId: studentId.toString()),
        ));
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnText: 'Ok',
            text: 'Success');
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnText: 'Ok',
            text: 'Unlock test failed');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> lockTest(BuildContext context) async {
    try {
      print(levelId);
      if (await Provider.of<Apis>(context, listen: false)
          .lockVocabTest(levelId: levelId, studentId: studentId)) {
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        print('student id => $studentId');
        print('student data => $studentData');
        print('all sections => $allSections');
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AllSectionsMapRoadsScreen(
              allSections: [],
              mediaQuery: mediaQuery,
              studentData: studentData,
              studentId: studentId.toString()),
        ));
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnText: 'Ok',
            text: 'success');
      } else {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            confirmBtnText: 'Ok',
            text: 'lock test failed');
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
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: isLocked
                              ? Colors.grey
                              : levelAvailableData['state'] == 'available'
                                  ? Colors.red
                                  : Colors.amber,
                          boxShadow: const [
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
                                      ? isLocked
                                          ? const Text(
                                              'The student did\'t not reached to this level test yet',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : levelAvailableData['state'] ==
                                                  'locked'
                                              ? const Text(
                                                  'You can now unlock the vocabulary test.',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : levelAvailableData['state'] ==
                                                      'available'
                                                  ? const Text(
                                                      'Vocabulary test has started.remember to end it when the student finishes',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : ListTile(
                                                      title: const Text(
                                                        'Mark',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      trailing: Text(
                                                        levelAvailableData[
                                                                'mark']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                      : isLocked
                                          ? const Text(
                                              'You did\'t not reached to this level test yet',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : levelAvailableData['state'] ==
                                                  'locked'
                                              ? const Text(
                                                  'You can ask the admin to unlock the test for you',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : levelAvailableData['state'] ==
                                                      'available'
                                                  ? const Text(
                                                      'You are ready to start the vocabulary test. Good luck!',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : ListTile(
                                                      title: const Text(
                                                        'Mark',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      trailing: Text(
                                                        levelAvailableData[
                                                                'mark']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                  SizedBox(
                                    height: mediaQuery.height / 200,
                                  ),
                                  User.userType == 'admin' &&
                                          showButton &&
                                          !isLocked
                                      ? levelAvailableData['state'] == 'locked'
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                          : levelAvailableData['state'] ==
                                                  'available'
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    lockTest(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                mediaQuery
                                                                        .width /
                                                                    8,
                                                            vertical: mediaQuery
                                                                    .height /
                                                                60),
                                                  ),
                                                  child: const Text(
                                                    'lock test',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                              : const SizedBox()
                                      : User.userType == 'admin' &&
                                              showButton &&
                                              isLocked
                                          ? const SizedBox()
                                          : !isLocked &&
                                                  User.userType == 'student'
                                              ? levelAvailableData['state'] ==
                                                      'locked'
                                                  ? const SizedBox()
                                                  : levelAvailableData[
                                                              'state'] ==
                                                          'available'
                                                      ? ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StudentVocabTestScreen(
                                                                      levelId:
                                                                          levelId,
                                                                      sectionId:
                                                                          sectionId),
                                                            ));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal:
                                                                    mediaQuery
                                                                            .width /
                                                                        8,
                                                                vertical: mediaQuery
                                                                        .height /
                                                                    60),
                                                          ),
                                                          child: const Text(
                                                            'Start',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ))
                                                      : const SizedBox()
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(360)),
                color: isLocked
                    ? Colors.grey
                    : levelAvailableData['state'] == 'available'
                        ? Colors.red
                        : Colors.amber,
                boxShadow: [
                  BoxShadow(
                    color: isLocked
                        ? Color.fromARGB(255, 113, 113, 113)
                        : levelAvailableData['state'] == 'available'
                            ? const Color.fromARGB(255, 127, 28, 21)
                            : const Color.fromARGB(255, 135, 103, 7),
                    offset: const Offset(0, 10), // changes position of shadow
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
