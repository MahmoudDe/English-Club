// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bdh/common/dialogs/dialogs.dart';
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
import 'package:intl/intl.dart';

import '../../styles/app_colors.dart';

class LevelStepWidget extends StatefulWidget {
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

  @override
  State<LevelStepWidget> createState() => _LevelStepWidgetState();
}

class _LevelStepWidgetState extends State<LevelStepWidget> {
  DateTime? selectedDate;

  final TextEditingController markController = TextEditingController();

  Future<void> showDateMarkDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Cheat settings',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: markController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Student Mark'),
              ),
              SizedBox(height: widget.mediaQuery.height / 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate == null
                        ? 'No Date Chosen!'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main),
                    onPressed: () async {
                      selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        Navigator.pop(context);
                        showDateMarkDialog(context);
                      }
                    },
                    child: Text(
                      'Pick Date',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                if (selectedDate != null && markController.text.isNotEmpty) {
                  // Navigator.of(context).pop();
                  // Process the selected date and entered mark
                  loadingDialog(
                      context: context,
                      mediaQuery: widget.mediaQuery,
                      title: 'Loading...');
                  if (await Provider.of<Apis>(context, listen: false)
                      .endVocabCycle(
                          studentId: widget.studentId,
                          vocabId: widget.levelId.toString(),
                          date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                          mark: markController.text)) {
                    Navigator.of(context).pop();
                    if (Apis.evaluation == 'Fail') {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          confirmBtnText: 'Ok',
                          text: 'You entered a fail mark');
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AllSectionsMapRoadsScreen(
                            allSections: [],
                            mediaQuery: widget.mediaQuery,
                            studentData: widget.studentData,
                            studentId: widget.studentId.toString()),
                      ));
                    }
                  } else {
                    Navigator.of(context).pop();
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        confirmBtnText: 'Ok',
                        text: Apis.message);
                  }
                } else {
                  // Show error if date or mark is missing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Please select a date and enter a mark')),
                  );
                }
              },
              child: Text('Submit',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> unlockTest(BuildContext context) async {
    try {
      print(widget.levelId);
      loadingDialog(
          context: context, mediaQuery: widget.mediaQuery, title: 'Loading...');
      if (await Provider.of<Apis>(context, listen: false).unlockVocabTest(
          levelId: widget.levelId, studentId: widget.studentId)) {
        Navigator.pop(context);
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        print('student id => ${widget.studentId}');
        print('student data => ${widget.studentData}');
        print('all sections => ${widget.allSections}');
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AllSectionsMapRoadsScreen(
              allSections: [],
              mediaQuery: widget.mediaQuery,
              studentData: widget.studentData,
              studentId: widget.studentId.toString()),
        ));
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            confirmBtnText: 'Ok',
            text: 'Success');
      } else {
        Navigator.pop(context);
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
      print(widget.levelId);
      if (await Provider.of<Apis>(context, listen: false).lockVocabTest(
          levelId: widget.levelId, studentId: widget.studentId)) {
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
        print('student id => ${widget.studentId}');
        print('student data => ${widget.studentData}');
        print('all sections => ${widget.allSections}');
        print('asdffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');

        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AllSectionsMapRoadsScreen(
              allSections: [],
              mediaQuery: widget.mediaQuery,
              studentData: widget.studentData,
              studentId: widget.studentId.toString()),
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
      width: widget.mediaQuery.width / 2,
      child: Row(
        mainAxisAlignment: widget.aligmentList[widget.counter],
        children: [
          widget.aligmentList[widget.counter] == MainAxisAlignment.end
              ? SizedBox(
                  height: widget.mediaQuery.height / 7,
                  // width: mediaQuery.width / 3,
                  child: Lottie.asset(widget.assetUrls[0], fit: BoxFit.contain),
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
                            ? widget.mediaQuery.height / 5
                            : widget.mediaQuery.height / 6,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: widget.isLocked
                              ? Colors.grey
                              : widget.levelAvailableData['state'] ==
                                      'available'
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
                                horizontal: widget.mediaQuery.width / 20,
                                vertical: widget.mediaQuery.height / 40),
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
                                        width: widget.mediaQuery.width / 40,
                                      ),
                                      Text(
                                        widget.levelName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                widget.mediaQuery.width / 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: widget.mediaQuery.height / 200,
                                  ),
                                  User.userType == 'admin'
                                      ? widget.isLocked
                                          ? const Text(
                                              'The student did\'t not reach to this level test yet',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : widget.levelAvailableData[
                                                      'state'] ==
                                                  'locked'
                                              ? const Text(
                                                  'You can now unlock the vocabulary test.',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : widget.levelAvailableData[
                                                          'state'] ==
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
                                                        widget
                                                            .levelAvailableData[
                                                                'mark']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )
                                      : widget.isLocked
                                          ? const Text(
                                              'You did\'t not reached to this level test yet',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          : widget.levelAvailableData[
                                                      'state'] ==
                                                  'locked'
                                              ? const Text(
                                                  'You can ask the admin to unlock this test for you',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              : widget.levelAvailableData[
                                                          'state'] ==
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
                                                        widget
                                                            .levelAvailableData[
                                                                'mark']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                  SizedBox(
                                    height: widget.mediaQuery.height / 200,
                                  ),
                                  User.userType == 'admin' &&
                                          widget.showButton &&
                                          !widget.isLocked
                                      ? widget.levelAvailableData['state'] ==
                                              'locked'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      unlockTest(context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: widget
                                                                      .mediaQuery
                                                                      .width /
                                                                  20,
                                                              vertical: widget
                                                                      .mediaQuery
                                                                      .height /
                                                                  60),
                                                    ),
                                                    child: const Text(
                                                      'unlock test',
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                SizedBox(
                                                  width:
                                                      widget.mediaQuery.width /
                                                          90,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      AwesomeDialog(
                                                          context: context,
                                                          body: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: widget
                                                                        .mediaQuery
                                                                        .width /
                                                                    30),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  'Do you want to end ${widget.levelName} test for ${widget.studentData['name']} student?',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .main,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width /
                                                                              30),
                                                                ),
                                                                SizedBox(
                                                                  height: widget
                                                                          .mediaQuery
                                                                          .height /
                                                                      50,
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: widget
                                                                              .mediaQuery
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.pop(
                                                                              context);
                                                                          showDateMarkDialog(
                                                                              context);
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.green,
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                widget.mediaQuery.width / 20,
                                                                            vertical:
                                                                                widget.mediaQuery.height / 80,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Yes',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: widget
                                                                              .mediaQuery
                                                                              .width /
                                                                          50,
                                                                    ),
                                                                    SizedBox(
                                                                      width: widget
                                                                              .mediaQuery
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                widget.mediaQuery.width / 20,
                                                                            vertical:
                                                                                widget.mediaQuery.height / 80,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Cancel',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: widget
                                                                          .mediaQuery
                                                                          .height /
                                                                      50,
                                                                ),
                                                              ],
                                                            ),
                                                          )).show();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.white,
                                                      padding: EdgeInsets
                                                          .symmetric(
                                                              horizontal: widget
                                                                      .mediaQuery
                                                                      .width /
                                                                  20,
                                                              vertical: widget
                                                                      .mediaQuery
                                                                      .height /
                                                                  60),
                                                    ),
                                                    child: const Text(
                                                      'Give Mark',
                                                      style: TextStyle(
                                                          color: Colors.amber,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                              ],
                                            )
                                          : widget
                                                          .levelAvailableData[
                                                      'state'] ==
                                                  'available'
                                              ? ElevatedButton(
                                                  onPressed: () {
                                                    lockTest(context);
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: widget
                                                                    .mediaQuery
                                                                    .width /
                                                                8,
                                                            vertical: widget
                                                                    .mediaQuery
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
                                      : User
                                                      .userType ==
                                                  'admin' &&
                                              widget.showButton &&
                                              widget.isLocked
                                          ? const SizedBox()
                                          : !widget
                                                      .isLocked &&
                                                  User.userType == 'student'
                                              ? widget.levelAvailableData[
                                                          'state'] ==
                                                      'locked'
                                                  ? const SizedBox()
                                                  : widget.levelAvailableData[
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
                                                                          widget
                                                                              .levelId,
                                                                      sectionId:
                                                                          widget
                                                                              .sectionId),
                                                            ));
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: widget
                                                                        .mediaQuery
                                                                        .width /
                                                                    8,
                                                                vertical: widget
                                                                        .mediaQuery
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
              height: widget.mediaQuery.height / 10,
              width: widget.mediaQuery.width / 3.5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(360)),
                color: widget.isLocked
                    ? Colors.grey
                    : widget.levelAvailableData['state'] == 'available'
                        ? Colors.red
                        : Colors.amber,
                boxShadow: [
                  BoxShadow(
                    color: widget.isLocked
                        ? Color.fromARGB(255, 113, 113, 113)
                        : widget.levelAvailableData['state'] == 'available'
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
                size: widget.mediaQuery.width / 10,
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
          widget.aligmentList[widget.counter] != MainAxisAlignment.end
              ? SizedBox(
                  height: widget.mediaQuery.height / 7,
                  // width: mediaQuery.width / 3,
                  child: Lottie.asset(widget.assetUrls[0], fit: BoxFit.contain),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
