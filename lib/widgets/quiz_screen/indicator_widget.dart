// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;
import 'package:flutter/material.dart';

class IndicatorWidget extends StatefulWidget {
  IndicatorWidget(
      {super.key,
      required this.activeIndex,
      required this.count,
      required this.scrollController,
      required this.controller});
  int activeIndex;
  int count;
  final carousel_slider.CarouselSliderController controller;
  final ScrollController scrollController;

  @override
  State<IndicatorWidget> createState() => _IndicatorWidgetState();
}

class _IndicatorWidgetState extends State<IndicatorWidget> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScrollStop);
  }

  void _onScrollStop() {
    if (!widget.scrollController.position.isScrollingNotifier.value) {
      int newIndex = (widget.scrollController.offset / 50)
          .round(); // 50 is width of each item, adjust if needed
      if (newIndex >= 0 && newIndex < widget.count) {
        setState(() {
          widget.activeIndex = newIndex;
        });
        widget.controller.jumpToPage(widget.activeIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height / 30,
      child: Stack(
        children: [
          ListView.builder(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.count,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  animateToSlide(index, widget.scrollController);
                },
                child: Container(
                  width: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: widget.activeIndex == index
                        ? Colors.amberAccent
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                        color: widget.activeIndex == index
                            ? Colors.white
                            : Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void animateToSlide(int index, ScrollController scrollController) {
    widget.controller.animateToPage(index);
    scrollController.animateTo(
        (index + 1) * MediaQuery.of(context).size.width / 7,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut);
  }
}
