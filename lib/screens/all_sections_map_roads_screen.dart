import 'package:bdh/model/constants.dart';
import 'package:bdh/screens/road_level.dart';
import 'package:bdh/styles/app_colors.dart';

import 'package:flutter/material.dart';

class AllSectionsMapRoadsScreen extends StatefulWidget {
  static const String routeName = '/navigation-screen';
  const AllSectionsMapRoadsScreen(
      {super.key, required this.allSections, required this.mediaQuery});
  final List allSections;
  final Size mediaQuery;
  @override
  State<AllSectionsMapRoadsScreen> createState() =>
      _AllSectionsMapRoadsScreenState();
}

class _AllSectionsMapRoadsScreenState extends State<AllSectionsMapRoadsScreen>
    with SingleTickerProviderStateMixin {
  // List roads = [];
  // final PageController _controller = PageController();
  int _currentPage = 0;
  @override
  void initState() {
    // for (int i = 0; i < widget.allSections.length; i++) {
    //   roads.add(RoadLevelsScreen(
    //     roadData: widget.allSections[i],
    //     mediaQuery: widget.mediaQuery,
    //     color: Constants.colorsForRoad[i],
    //   ));
    // }
    super.initState();
  }

  final controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 30,
              vertical: mediaQuery.height / 50),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: AppColors.main),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: PageView.builder(
          controller: controller,
          onPageChanged: (index) {
            _currentPage = index;
          },
          itemCount: widget.allSections.length,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              color: Constants.colorsForRoad[_currentPage],
              child: RoadLevelsScreen(
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
