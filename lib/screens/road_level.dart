import 'package:bdh/server/image_url.dart';
import 'package:bdh/widgets/road_level_screen/level_step_widget.dart';
import 'package:bdh/widgets/road_level_screen/part_step_widget.dart';
import 'package:bdh/widgets/road_level_screen/start_step_widget.dart';
import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class RoadLevelsScreen extends StatefulWidget {
  const RoadLevelsScreen(
      {super.key,
      required this.roadData,
      required this.mediaQuery,
      required this.color,
      required this.studentData,
      required this.assetUrls,
      required this.showName});
  final Map studentData;
  final Map roadData;
  final Size mediaQuery;
  final Color? color;
  final List assetUrls;
  final bool showName;

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
        editStep();
      }

      String currentLevel = widget.roadData['data'][i]['name']
          .substring(0, widget.roadData['data'][i]['name'].indexOf('/'));
      String currentPart = widget.roadData['data'][i]['name'].substring(
          widget.roadData['data'][i]['name'].indexOf('/') + 1,
          widget.roadData['data'][i]['name'].length);

      //when end all part add uniq step
      if (currentLevel != tempLevel) {
        steps.add(
          LevelStepWidget(
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
        steps.add(
          LevelStepWidget(
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
        title: !widget.showName
            ? null
            : ListTile(
                leading: CircleAvatar(
                  backgroundImage: widget.studentData['profile_picture'] == null
                      ? null
                      : NetworkImage(
                          '${ImageUrl.imageUrl}${widget.studentData['profile_picture']}'),
                  backgroundColor: Colors.white,
                  child: Center(
                      child: Icon(
                    Icons.person,
                    color: AppColors.main,
                  )),
                ),
                title: Text(
                  widget.studentData['name'],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
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
