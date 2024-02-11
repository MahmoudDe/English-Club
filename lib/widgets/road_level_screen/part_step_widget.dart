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
      required this.currentPart,
      required this.roadData,
      required this.i});
  final Size mediaQuery;
  final List aligmentList;
  final int counter;
  final Color color;
  final String currentPart;
  final Map roadData;
  final int i;

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
                        // width: mediaQuery.width / 1.2,
                        height: mediaQuery.height / 7,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: color,
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
                                        radius: 20,
                                        lineWidth: 5,
                                        center: const Text(
                                          '0%',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.white),
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
                color: color,
                // shape: BoxShape,
                boxShadow: [
                  BoxShadow(
                    color: _darkenColor(color, 0.7),
                    offset: const Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                      child: Image(
                    image: const AssetImage('assets/images/openbook.png'),
                    height: mediaQuery.height / 23,
                    width: mediaQuery.width / 4,
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
