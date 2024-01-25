// ignore_for_file: use_build_context_synchronously

import 'package:bdh/widgets/english_club_settings_screen/subLevel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class LevelsWidget extends StatelessWidget {
  LevelsWidget({super.key, required this.mediaQuery, required this.levels});
  final Size mediaQuery;
  final List levels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: levels.length,
      itemBuilder: (context, index) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              extentRatio: 1 / 2,
              dragDismissible: false,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (con) {},
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'edit',
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 30),
              height: mediaQuery.height / 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Text(
                levels[index]['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          subLevelWidget(levels: levels, index: index, mediaQuery: mediaQuery),
        ],
      ),
    );
  }
}
