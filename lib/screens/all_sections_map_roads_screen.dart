import 'package:bdh/model/constants.dart';
import 'package:bdh/screens/road_level.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/all_sections_road/student_settings_widget.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AllSectionsMapRoadsScreen extends StatefulWidget {
  static const String routeName = '/navigation-screen';
  const AllSectionsMapRoadsScreen(
      {super.key,
      required this.allSections,
      required this.mediaQuery,
      required this.studentData,
      required this.studentId});
  final Map studentData;
  final List allSections;
  final String studentId;
  final Size mediaQuery;
  @override
  State<AllSectionsMapRoadsScreen> createState() =>
      _AllSectionsMapRoadsScreenState();
}

class _AllSectionsMapRoadsScreenState extends State<AllSectionsMapRoadsScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  bool isLoading = false;
  List studentRoad = [];
  @override
  void initState() {
    super.initState();
    if (widget.studentId.isNotEmpty) {
      getStudentMap();
    } else {
      print(widget.allSections);
    }
    print('first length => ${widget.allSections.length}');
    print('second length => ${Apis.studentRoadMap.length}');
    if (widget.allSections.length > 3 || Apis.studentRoadMap.length > 3) {
      print('Hello');
      for (int i = 0; i < 3; i++) {
        Constants.colorsForRoad.add(Constants.colorsForRoad[i]);
        Constants.animations.add(Constants.animations[i]);
      }
    }
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
  }

  Future<void> getStudentMap() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false)
          .getAllSectionsForStudent(id: widget.studentId);
      setState(() {
        // studentRoad = Apis.studentRoadMap;
        print('from apis ..........................................');
        print(Apis.studentRoadMap);
        print('...................................................');
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  late AnimationController animationController;

  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.main,
              ),
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar:
                Apis.studentRoadMap.isEmpty && widget.allSections.isEmpty
                    ? true
                    : false,
            appBar: Apis.studentRoadMap.isEmpty && widget.allSections.isEmpty
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                  )
                : null,
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                Apis.studentRoadMap.isEmpty && widget.allSections.isEmpty
                    ? const Center(
                        child: Text(
                          'The english club did not start yet',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : PageView.builder(
                        controller: controller,
                        onPageChanged: (index) {
                          _currentPage = index;
                        },
                        itemCount: widget.studentId.isNotEmpty
                            ? Apis.studentRoadMap.length
                            : widget.allSections.length,
                        itemBuilder: (context, index) {
                          return widget.studentId.isNotEmpty
                              ? AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  color: Constants.colorsForRoad[_currentPage],
                                  child: RoadLevelsScreen(
                                    allSections: widget.allSections,
                                    showName: true,
                                    assetUrls: Constants.animations[index],
                                    studentData: widget.studentData,
                                    roadData: Apis.studentRoadMap[index],
                                    mediaQuery: widget.mediaQuery,
                                    color: Constants.colorsForRoad[index],
                                  ),
                                )
                              : AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  color: Constants.colorsForRoad[_currentPage],
                                  child: RoadLevelsScreen(
                                    allSections: widget.allSections,
                                    showName: false,
                                    studentData: widget.studentData,
                                    assetUrls: Constants.animations[index],
                                    roadData: widget.allSections[index],
                                    mediaQuery: widget.mediaQuery,
                                    color: Constants.colorsForRoad[index],
                                  ),
                                );
                        }),
                widget.studentId.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: mediaQuery.width / 10),
                        child: StudentSettingsWidget(
                          studentId: widget.studentId,
                          animationController: animationController,
                          mediaQuery: mediaQuery,
                          studentData: widget.studentData,
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                  bottom: mediaQuery.height / 80,
                  child: SmoothPageIndicator(
                    controller: controller,
                    count: widget.studentId.isNotEmpty
                        ? Apis.studentRoadMap.length
                        : widget.allSections.length,
                    effect: const WormEffect(
                      paintStyle: PaintingStyle.fill,
                      dotColor: Colors.black38,
                      activeDotColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
