import 'package:bdh/widgets/english_club_settings_screen/books_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../styles/app_colors.dart';

class PartWidget extends StatelessWidget {
  const PartWidget(
      {super.key,
      required this.levels,
      required this.index,
      required this.mediaQuery});
  final List levels;
  final int index;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: levels[index]['sub_levels'].length,
      itemBuilder: (context, index1) => Slidable(
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
          margin: EdgeInsets.symmetric(
              horizontal: mediaQuery.width / 20,
              vertical: mediaQuery.height / 100),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: ExpansionTile(
              title: Text(
                levels[index]['sub_levels'][index1]['name'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.main,
                ),
              ),
              children: [
                BooksWidget(
                    mediaQuery: mediaQuery,
                    index: index,
                    index1: index1,
                    levels: levels)
              ]),
        ),
      ),
    );
  }
}
