import 'package:bdh/widgets/road_level_screen/level_step_widget.dart';
import 'package:bdh/widgets/road_level_screen/part_step_widget.dart';
import 'package:bdh/widgets/road_level_screen/start_step_widget.dart';
import 'package:flutter/material.dart';

class RoadLevelsScreen extends StatefulWidget {
  const RoadLevelsScreen(
      {super.key,
      required this.roadData,
      required this.mediaQuery,
      required this.color,
      required this.studentData,
      required this.assetUrls,
      required this.allSections,
      required this.showName});

  final Map studentData;
  final Map roadData;
  final Size mediaQuery;
  final Color? color;
  final List assetUrls;
  final bool showName;
  final List<dynamic> allSections;

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
  String tempLevelId = '';
  int counter = 0;

  Color _darkenColor(Color color, [double factor = 0.5]) {
    assert(factor >= 0 && factor <= 1);
    final int red = (color.red * factor).round();
    final int green = (color.green * factor).round();
    final int blue = (color.blue * factor).round();
    return Color.fromRGBO(red, green, blue, 1);
  }

  void editStep() {
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
        height: widget.mediaQuery.height / 50,
      ));
    }
    if (isForwarding) {
      partPosition += 1;
    }
    if (!isForwarding) {
      partPosition -= 1;
    }
  }

  void addSteps(Size mediaQuery) {
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < widget.roadData['data'].length; i++) {
      editStep();
      //adding start step
      if (tempLevel == '') {
        steps.add(
          StartStepWidget(
              assetUrls: widget.assetUrls,
              mediaQuery: mediaQuery,
              aligmentList: aligmentList,
              counter: counter),
        );
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 30,
          ));
        }
        tempLevel = widget.roadData['data'][i]['name']
            .substring(0, widget.roadData['data'][i]['name'].indexOf('/'));
        tempLevelId = widget.roadData['data'][i]['level_id'].toString();
        editStep();
      }

      String currentLevel = widget.roadData['data'][i]['name']
          .substring(0, widget.roadData['data'][i]['name'].indexOf('/'));
      int currentLevelId = widget.roadData['data'][i]['level_id'];
      String currentPart = widget.roadData['data'][i]['name'].substring(
          widget.roadData['data'][i]['name'].indexOf('/') + 1,
          widget.roadData['data'][i]['name'].length);

      //when end all part add uniq step
      if (currentLevel != tempLevel) {
        bool isLocked = true;
        print('The level id is => ${(currentLevelId - 1).toString()}');
        for (int i = 0;
            i < widget.roadData['availableVocabularyTests'].length;
            i++) {
          if ((currentLevelId - 1).toString() ==
              widget.roadData['availableVocabularyTests'][i]['level_id']
                  .toString()) {
            print('Found available test ');
            setState(() {
              isLocked = false;
            });
          }
        }
        steps.add(
          LevelStepWidget(
              allSections: widget.allSections,
              studentData: widget.roadData,
              isLocked: isLocked,
              sectionId: widget.roadData['section_id'].toString(),
              studentId:
                  !widget.showName ? '' : widget.studentData['id'].toString(),
              levelId: (currentLevelId - 1).toString(),
              assetUrls: widget.assetUrls,
              showButton: widget.showName,
              levelName: tempLevel,
              mediaQuery: mediaQuery,
              aligmentList: aligmentList,
              counter: counter),
        );
        if (counter == 0 || counter == 2) {
          steps.add(SizedBox(
            height: mediaQuery.height / 30,
          ));
        }
        tempLevel = currentLevel;
        editStep();
      }

      //adding steps for each level
      steps.add(PartStepWidget(
          studentId: widget.studentData['id'].toString(),
          studentData: widget.studentData,
          isForStudent: widget.showName,
          mediaQuery: mediaQuery,
          aligmentList: aligmentList,
          counter: counter,
          color: widget.color!,
          currentPart: currentPart,
          roadData: widget.roadData,
          i: i));

      if (counter == 0 || counter == 2) {
        steps.add(SizedBox(
          height: mediaQuery.height / 30,
        ));
      }

      //add final level step
      if (i == widget.roadData['data'].length - 1) {
        editStep();
        bool isLocked = true;
        print('The level id is => ${currentLevelId.toString()}');
        for (int i = 0;
            i < widget.roadData['availableVocabularyTests'].length;
            i++) {
          if (currentLevelId.toString() ==
              widget.roadData['availableVocabularyTests'][i]['level_id']
                  .toString()) {
            print('found test');
            setState(() {
              isLocked = false;
            });
            break;
          }
        }
        steps.add(
          LevelStepWidget(
              allSections: widget.allSections,
              studentData: widget.roadData,
              sectionId: widget.roadData['section_id'].toString(),
              isLocked: isLocked,
              studentId:
                  !widget.showName ? '' : widget.studentData['id'].toString(),
              levelId: currentLevelId.toString(),
              assetUrls: widget.assetUrls,
              showButton: widget.showName,
              levelName: currentLevel,
              mediaQuery: mediaQuery,
              aligmentList: aligmentList,
              counter: counter),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _darkenColor(widget.color!, 0.7),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                const Opacity(
                  opacity: 0.5,
                  child: Image(
                    image: AssetImage(
                      'assets/images/backRoad.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: const Duration(seconds: 2),
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.height / 80),
                      color: widget.color,
                      width: mediaQuery.width,
                      alignment: Alignment.bottomCenter,
                      height: mediaQuery.height / 20,
                      child: Text(
                        '${widget.roadData['section_name']} section',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: mediaQuery.width / 20),
                      ),
                    ),
                    Container(
                      height: mediaQuery.height / 1.19,
                      padding: EdgeInsets.symmetric(
                          vertical: mediaQuery.width / 50,
                          horizontal: mediaQuery.width / 10),
                      child: ListView(
                        padding: EdgeInsets.zero,
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
