import 'package:bdh/screens/book_cover_screen.dart';
import 'package:bdh/screens/student_screens/student_test_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quickalert/quickalert.dart';

import '../../server/apis.dart';
import '../../server/image_url.dart';

class BookSubLevelWidget extends StatelessWidget {
  const BookSubLevelWidget(
      {super.key,
      required this.index2,
      required this.mediaQuery,
      required this.screenColor});
  final int index2;
  final Size mediaQuery;
  final Color screenColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: Apis.subLevelBooksList[index2]['id'],
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BookCoverScreen(
                  screenColor: screenColor,
                  index2: index2,
                ),
              ));
            },
            child: Container(
                height: mediaQuery.height / 3,
                width: mediaQuery.width / 2,
                foregroundDecoration:
                    Apis.subLevelBooksList[index2]['status'] == ''
                        ? const BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                        : const BoxDecoration(),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:
                          Apis.subLevelBooksList[index2]['status'] == 'success'
                              ? Colors.greenAccent.withOpacity(0.6)
                              : Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Apis.subLevelBooksList[index2]['cover_url'] != null
                    ? Image(
                        image: NetworkImage(
                          '${ImageUrl.imageUrl}${Apis.subLevelBooksList[index2]['cover_url']}',
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
            Apis.subLevelBooksList[index2]['status'] == 'test_available'
                ? QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    text: 'You are going to start story test \n Are you sure?',
                    onConfirmBtnTap: () {
                      Navigator.pop(context);
                      print('story data======================================');
                      print(Apis.subLevelBooksList[index2]);
                      print('============================================');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StudentTestScreen(
                            testId:
                                Apis.subLevelBooksList[index2]['id'].toString(),
                            subLevelId: Apis.subLevelBooksList[index2]
                                    ['sub_level_id']
                                .toString()),
                      ));
                      print('start');
                    },
                  )
                : null;
          },
          child: Container(
            height: mediaQuery.height / 18,
            width: mediaQuery.width / 2,
            alignment: Alignment.center,
            foregroundDecoration: Apis.subLevelBooksList[index2]['status'] == ''
                ? const BoxDecoration(
                    color: Colors.grey,
                    backgroundBlendMode: BlendMode.saturation,
                  )
                : const BoxDecoration(),
            decoration: BoxDecoration(
              color: Apis.subLevelBooksList[index2]['status'] == 'borrowed'
                  ? screenColor
                  : Apis.subLevelBooksList[index2]['status'] == 'success'
                      ? Colors.greenAccent
                      : Colors.amber,
              boxShadow: [
                BoxShadow(
                  color: Apis.subLevelBooksList[index2]['status'] == 'success'
                      ? Colors.greenAccent.withOpacity(0.6)
                      : Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Apis.subLevelBooksList[index2]['status'] == ''
                ? const Icon(
                    Iconsax.lock5,
                    color: Colors.white,
                  )
                : Apis.subLevelBooksList[index2]['status'] == 'success'
                    ? Text(
                        '${Apis.subLevelBooksList[index2]['status']}: ${Apis.subLevelBooksList[index2]['mark']}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : Text(
                        Apis.subLevelBooksList[index2]['status'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
          ),
        ),
      ],
    );
  }
}
