import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoadLevelsScreen extends StatefulWidget {
  const RoadLevelsScreen(
      {super.key, required this.roadData, required this.mediaQuery});
  final Map roadData;
  final Size mediaQuery;
  @override
  State<RoadLevelsScreen> createState() => _RoadLevelsScreenState();
}

class _RoadLevelsScreenState extends State<RoadLevelsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    print(widget.roadData);
    addSteps(widget.mediaQuery);
    super.initState();
  }

  String tempLevel = '';

  void addSteps(Size mediaQuery) {
    setState(() {
      isLoading = true;
    });

    int counter;
    for (int i = 0; i < widget.roadData['data'].length; i++) {
      if (partPosition == 3) {
        isForwarding = false;
      }
      if (partPosition == -1) {
        isForwarding = true;
      }
      counter = partPosition == -1
          ? 0
          : partPosition == 3
              ? 2
              : partPosition;
      if (counter == 0 || counter == 2) {
        steps.add(SizedBox(
          height: mediaQuery.height / 50,
        ));
      }
      if (isForwarding) {
        partPosition += 1;
      }
      if (!isForwarding) {
        partPosition -= 1;
      }

      //adding start step
      if (tempLevel == '') {
        steps.add(Row(
          mainAxisAlignment: aligmentList[counter],
          children: [
            SizedBox(
              height: mediaQuery.height / 7.5,
              width: mediaQuery.width / 3.5,
              child: const Stack(
                // fit: StackFit.expand,
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/circle.png',
                    ),
                  ),
                  Center(
                    child: Text(
                      'Start',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
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
        ));
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 30,
          ));
        }
        tempLevel = widget.roadData['data'][i]['name']
            .substring(0, widget.roadData['data'][i]['name'].indexOf('/'));
      }

      String currentLevel = widget.roadData['data'][i]['name']
          .substring(0, widget.roadData['data'][i]['name'].indexOf('/'));

      //when end all part add uniq step
      if (currentLevel != tempLevel) {
        steps.add(
          Row(
            mainAxisAlignment: aligmentList[counter],
            children: [
              SizedBox(
                height: mediaQuery.height / 7.5,
                width: mediaQuery.width / 3.5,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    const Center(
                      child: Image(
                        image: AssetImage(
                          'assets/images/circle.png',
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to the selected level
                          print('Level 1 selected!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width / 15,
                              vertical: mediaQuery.height /
                                  20), // Adjust padding for size
                        ),
                        child: Text(
                          tempLevel.substring(0,
                              widget.roadData['data'][i]['name'].indexOf('/')),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: mediaQuery.width / 25),
                        ),
                      ),
                    )
                  ],
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
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 30,
          ));
        }
        tempLevel = currentLevel;
      }

      //adding steps for each level
      steps.add(
        Row(
          mainAxisAlignment: aligmentList[counter],
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the selected level
                print('Level 1 selected!');
              },
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(
                    side: BorderSide(
                        color: Colors.amber.shade200)), // Circular shape
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 15,
                    vertical:
                        mediaQuery.height / 20), // Adjust padding for size
              ),
              child: Text(
                widget.roadData['data'][i]['name'].substring(
                    0, widget.roadData['data'][i]['name'].indexOf('/')),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: mediaQuery.width / 25),
              ),
            ),
          ],
        ),
      );

      if (counter == 0 || counter == 2) {
        steps.add(SizedBox(
          height: mediaQuery.height / 30,
        ));
      }

      //add final level step
      if (i == widget.roadData['data'].length - 1) {
        if (partPosition == 3) {
          isForwarding = false;
        }
        if (partPosition == -1) {
          isForwarding = true;
        }
        counter = partPosition == -1
            ? 0
            : partPosition == 3
                ? 2
                : partPosition;
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 50,
          ));
        }
        if (isForwarding) {
          partPosition += 1;
        }
        if (!isForwarding) {
          partPosition -= 1;
        }

        steps.add(
          Row(
            mainAxisAlignment: aligmentList[counter],
            children: [
              SizedBox(
                height: mediaQuery.height / 7.5,
                width: mediaQuery.width / 3.5,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Center(
                      child: Image(
                        image: const AssetImage(
                          'assets/images/circle.png',
                        ),
                        height: mediaQuery.height / 7.5,
                        width: mediaQuery.width / 3.5,
                      ),
                    ),
                    Center(
                      child: Text(
                        tempLevel,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
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
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 50,
          ));
        }
        tempLevel = currentLevel;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  final steps = <Widget>[];
  bool isLoading = false;

  int partPosition = -1;
  bool isForwarding = true;
  List<MainAxisAlignment> aligmentList = [
    MainAxisAlignment.start,
    // MainAxisAlignment.start,
    MainAxisAlignment.center,
    MainAxisAlignment.end,
    // MainAxisAlignment.end,
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Positioned(
                    // right: 1,
                    top: 0,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image(
                        image: const AssetImage(
                          'assets/images/readImage2.png',
                        ),
                        height: mediaQuery.height / 1.1,
                        fit: BoxFit.cover,
                        width: mediaQuery.width,
                      ),
                    )),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: mediaQuery.height / 30,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: mediaQuery.height / 50),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 10,
                          vertical: mediaQuery.height / 70,
                        ),
                        child: Text(
                          '${widget.roadData['section_name']} section',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.main,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: mediaQuery.height / 1.15,
                      margin: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 50),
                      padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 50),
                      child: ListView(
                        children: steps,
                      ),
                    )
                  ],
                ),
              ],
            ),
    );
  }
}


  //  child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [

  //                     //column1
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: mediaQuery.height / 30,
  //                     ),
  //                     //column2
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: mediaQuery.height / 30,
  //                     ),
  //                     //column1
  //                     Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 // Navigate to the selected level
  //                                 // Add your navigation logic here
  //                                 print('Level 1 selected!');
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 shape: CircleBorder(
  //                                     side: BorderSide(
  //                                         color: Colors.amber
  //                                             .shade200)), // Circular shape
  //                                 padding: EdgeInsets.symmetric(
  //                                     horizontal: mediaQuery.width / 15,
  //                                     vertical: mediaQuery.height /
  //                                         20), // Adjust padding for size
  //                               ),
  //                               child: Text(
  //                                 'Level 1',
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     color: Colors.white,
  //                                     fontSize: mediaQuery.width / 25),
  //                               ),
  //                             ),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
               