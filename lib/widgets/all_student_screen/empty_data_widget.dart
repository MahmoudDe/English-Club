import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../title_widget.dart';

// ignore: must_be_immutable
class EmptyDataWidget extends StatelessWidget {
  EmptyDataWidget({super.key, required this.mediaQuery});
  Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(
            mediaQuery: mediaQuery,
            title: 'search',
            icon: const SizedBox(
              width: 0,
            )),
        SizedBox(
          height: mediaQuery.height / 3,
        ),
        Center(
          child: Lottie.asset(
            'assets/lotties/empty.json',
          ),
        ),
      ],
    );
  }
}
