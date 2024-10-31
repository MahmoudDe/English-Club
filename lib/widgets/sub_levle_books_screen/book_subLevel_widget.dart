import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bdh/common/dialogs/dialogs.dart';
import 'package:bdh/model/user.dart';
import 'package:bdh/screens/book_cover_screen.dart';
import 'package:bdh/screens/student_screens/student_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';

import '../../server/apis.dart';
import '../../server/image_url.dart';
import '../../styles/app_colors.dart';

class BookSubLevelWidget extends StatefulWidget {
  BookSubLevelWidget(
      {super.key,
      required this.index2,
      required this.mediaQuery,
      required this.studentId,
      required this.studentName,
      required this.screenColor});
  final int index2;
  final Size mediaQuery;
  final Color screenColor;
  final String studentName;
  final String studentId;

  @override
  State<BookSubLevelWidget> createState() => _BookSubLevelWidgetState();
}

class _BookSubLevelWidgetState extends State<BookSubLevelWidget> {
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
                      .endStoryCycle(
                          studentId: widget.studentId,
                          storyId: Apis.subLevelBooksList[widget.index2]['id']
                              .toString(),
                          date: DateFormat('yyyy-MM-dd').format(selectedDate!),
                          mark: markController.text)) {
                    Navigator.of(context).pop();
                    setState(() {
                      Apis.subLevelBooksList[widget.index2]['status'] =
                          'success';
                      Apis.subLevelBooksList[widget.index2]['mark'] =
                          markController.text;
                    });
                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: Apis.subLevelBooksList[widget.index2]['id'],
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookCoverScreen(
                  screenColor: widget.screenColor,
                  index2: widget.index2,
                ),
              ));
            },
            child: Container(
                height: widget.mediaQuery.height / 3,
                width: widget.mediaQuery.width / 2,
                foregroundDecoration:
                    Apis.subLevelBooksList[widget.index2]['status'] == ''
                        ? const BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                        : const BoxDecoration(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Apis.subLevelBooksList[widget.index2]['status'] ==
                              'success'
                          ? Colors.greenAccent.withOpacity(0.6)
                          : Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child:
                    Apis.subLevelBooksList[widget.index2]['cover_url'] != null
                        ? Image(
                            image: NetworkImage(
                              '${ImageUrl.imageUrl}${Apis.subLevelBooksList[widget.index2]['cover_url']}',
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          )
                        : const Image(
                            image: AssetImage('assets/images/bookCover.jpg'),
                            fit: BoxFit.cover,
                          )),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (User.userType == 'student') {
              Apis.subLevelBooksList[widget.index2]['status'] ==
                      'test_available'
                  ? QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      text:
                          'You are going to start story test \n Are you sure?',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        print(
                            'story data======================================');
                        print(Apis.subLevelBooksList[widget.index2]);
                        print('============================================');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StudentTestScreen(
                              storyTitle:
                                  '${Apis.subLevelBooksList[widget.index2]['title']} story',
                              testId: Apis.subLevelBooksList[widget.index2]
                                      ['id']
                                  .toString(),
                              subLevelId: Apis.subLevelBooksList[widget.index2]
                                      ['sub_level_id']
                                  .toString()),
                        ));
                        print('start');
                      },
                    )
                  : null;
            } else if (Apis.subLevelBooksList[widget.index2]['status'] !=
                'success') {
              AwesomeDialog(
                  context: context,
                  body: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.mediaQuery.width / 30),
                    child: Column(
                      children: [
                        Text(
                          'Do you want to end ${'${Apis.subLevelBooksList[widget.index2]['title']} story'} test for ${widget.studentName} student?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width / 30),
                        ),
                        SizedBox(
                          height: widget.mediaQuery.height / 50,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: widget.mediaQuery.width / 3,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  showDateMarkDialog(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widget.mediaQuery.width / 20,
                                    vertical: widget.mediaQuery.height / 80,
                                  ),
                                ),
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: widget.mediaQuery.width / 50,
                            ),
                            SizedBox(
                              width: widget.mediaQuery.width / 3,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: widget.mediaQuery.width / 20,
                                    vertical: widget.mediaQuery.height / 80,
                                  ),
                                ),
                                child: const Text(
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
                          height: widget.mediaQuery.height / 50,
                        ),
                      ],
                    ),
                  )).show();
            }
          },
          child: Container(
            height: widget.mediaQuery.height / 18,
            width: widget.mediaQuery.width / 2,
            alignment: Alignment.center,
            foregroundDecoration:
                Apis.subLevelBooksList[widget.index2]['status'] == ''
                    ? const BoxDecoration(
                        color: Colors.grey,
                        backgroundBlendMode: BlendMode.saturation,
                      )
                    : const BoxDecoration(),
            decoration: BoxDecoration(
              color: Apis.subLevelBooksList[widget.index2]['status'] ==
                      'borrowed'
                  ? widget.screenColor
                  : Apis.subLevelBooksList[widget.index2]['status'] == 'success'
                      ? Colors.greenAccent
                      : Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Apis.subLevelBooksList[widget.index2]['status'] ==
                          'success'
                      ? Colors.greenAccent.withOpacity(0.6)
                      : Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Apis.subLevelBooksList[widget.index2]['status'] == ''
                ? const Icon(
                    Iconsax.lock5,
                    color: Colors.white,
                  )
                : Apis.subLevelBooksList[widget.index2]['status'] == 'success'
                    ? Text(
                        '${Apis.subLevelBooksList[widget.index2]['status']}: ${Apis.subLevelBooksList[widget.index2]['mark']}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Apis.subLevelBooksList[widget.index2]['status'] ==
                                'test_available'
                            ? User.userType == 'student'
                                ? 'Start Test'
                                : 'Test available'
                            : Apis.subLevelBooksList[widget.index2]['status'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
          ),
        ),
      ],
    );
  }
}
