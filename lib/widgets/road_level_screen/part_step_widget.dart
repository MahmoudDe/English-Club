import 'package:bdh/screens/sub_level_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PartStepWidget extends StatelessWidget {
  const PartStepWidget(
      {super.key,
      required this.mediaQuery,
      required this.aligmentList,
      required this.counter,
      required this.color,
      required this.isForStudent,
      required this.currentPart,
      required this.roadData,
      required this.studentId,
      required this.studentData,
      required this.i});
  final Size mediaQuery;
  final List aligmentList;
  final int counter;
  final Color color;
  final String currentPart;
  final Map roadData;
  final bool isForStudent;
  final int i;
  final String studentId;
  final Map studentData;
  Color _darkenColor(Color color, [double factor = 0.5]) {
    assert(factor >= 0 && factor <= 1);
    final int red = (color.red * factor).round();
    final int green = (color.green * factor).round();
    final int blue = (color.blue * factor).round();
    return Color.fromRGBO(red, green, blue, 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: mediaQuery.width / 2,
      child: Row(
        mainAxisAlignment: aligmentList[counter],
        children: [
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
                        height: mediaQuery.height / 6,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: roadData['data'][i]['status'] == null ||
                                  roadData['data'][i]['status'] == 'reached' ||
                                  roadData['data'][i]['status'] == 'done'
                              ? color
                              : Colors.grey,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Iconsax.lamp_on5,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: mediaQuery.width / 40,
                                      ),
                                      Text(
                                        currentPart,
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
                                  Text(
                                    roadData['data'][i]['name'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: mediaQuery.height / 200,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${roadData['data'][i]['stories_count']} Stories',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mediaQuery.width / 25,
                                        ),
                                      ),
                                      CircularPercentIndicator(
                                        radius: mediaQuery.width / 15,
                                        lineWidth: 5,
                                        progressColor: Colors.green,
                                        percent: roadData['data'][i]
                                                    ['status'] ==
                                                'reached'
                                            ? double.parse(
                                                roadData['data'][i]['progress'])
                                            : roadData['data'][i]['status'] ==
                                                    'done'
                                                ? 1.0
                                                : 0.0,
                                        center: Text(
                                          roadData['data'][i]['status'] ==
                                                  'reached'
                                              ? "${(double.parse(roadData['data'][i]['progress']) * 100).toString()}%"
                                              : roadData['data'][i]['status'] ==
                                                      'done'
                                                  ? '100%'
                                                  : '0%',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            isForStudent
                                                ? Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubLevelBooksScreen(
                                                      screenDarkColor: roadData[
                                                                          'data'][i][
                                                                      'status'] ==
                                                                  null ||
                                                              roadData['data']
                                                                          [i][
                                                                      'status'] ==
                                                                  'reached' ||
                                                              roadData['data']
                                                                          [i][
                                                                      'status'] ==
                                                                  'done'
                                                          ? color
                                                          : const Color
                                                              .fromARGB(
                                                              255, 99, 99, 99),
                                                      subLevelId: roadData[
                                                                  'data'][i]
                                                              ['sub_level_id']
                                                          .toString(),
                                                      studentId: studentId,
                                                      title: roadData['data'][i]
                                                          ['name'],
                                                      studentData: studentData,
                                                      screenColor: roadData['data']
                                                                          [i][
                                                                      'status'] ==
                                                                  null ||
                                                              roadData['data']
                                                                          [i][
                                                                      'status'] ==
                                                                  'reached' ||
                                                              roadData['data']
                                                                          [i][
                                                                      'status'] ==
                                                                  'done'
                                                          ? color
                                                          : Colors.grey,
                                                    ),
                                                  ))
                                                : null;
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: color,
                                          ))
                                    ],
                                  )
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
                color: roadData['data'][i]['status'] == null ||
                        roadData['data'][i]['status'] == 'reached' ||
                        roadData['data'][i]['status'] == 'done'
                    ? color
                    : Colors.grey,
                // shape: BoxShape,
                boxShadow: [
                  BoxShadow(
                    color: roadData['data'][i]['status'] == null ||
                            roadData['data'][i]['status'] == 'reached' ||
                            roadData['data'][i]['status'] == 'done'
                        ? _darkenColor(color, 0.7)
                        : const Color.fromARGB(255, 119, 119, 119),
                    offset: const Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                      child: roadData['data'][i]['status'] == null ||
                              roadData['data'][i]['status'] == 'reached' ||
                              roadData['data'][i]['status'] == 'done'
                          ? Image(
                              image: const AssetImage(
                                  'assets/images/openbook.png'),
                              height: mediaQuery.height / 23,
                              width: mediaQuery.width / 4,
                            )
                          : const Icon(
                              Iconsax.lock_15,
                              color: Colors.white,
                            )),
                  Container(
                    height: mediaQuery.height / 10,
                    width: mediaQuery.width / 3.5,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(360)),
                    ),
                    child: const ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(360)),
                      child: Image(
                        image: AssetImage(
                          'assets/images/circleBackground.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
