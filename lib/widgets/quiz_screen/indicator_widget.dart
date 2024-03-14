// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndicatorWidget extends StatelessWidget {
  IndicatorWidget(
      {super.key,
      required this.activeIndex,
      required this.count,
      required this.controller});
  int activeIndex;
  int count;
  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      onDotClicked: animateToSlide,
      count: count,
      effect: ScaleEffect(
          activeDotColor: Colors.amber,
          dotColor: Colors.white24,
          dotHeight: mediaQuery.height / 100,
          dotWidth: mediaQuery.height / 100,
          strokeWidth: 0,
          spacing: mediaQuery.width / 100),
    );
  }

  void animateToSlide(int index) => controller.animateToPage(index);
}
