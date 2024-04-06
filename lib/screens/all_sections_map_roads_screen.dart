import 'package:bdh/model/constants.dart';
import 'package:bdh/screens/road_level.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      print('from apis ..........................................');
      print(Apis.studentRoadMap);
      print('...................................................');
    } else {
      print(widget.allSections);
    }
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
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

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
            floatingActionButton: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Consumer<Apis>(
                builder: (context, value, child) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width / 30,
                      vertical: mediaQuery.height / 50),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.main),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: PageView.builder(
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
                            studentData: widget.studentData,
                            assetUrls: Constants.animations[index],
                            roadData: widget.allSections[index],
                            mediaQuery: widget.mediaQuery,
                            color: Constants.colorsForRoad[index],
                          ),
                        );
                }),
          );
  }
}
