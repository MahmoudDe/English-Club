import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../server/apis.dart';

class DoneListWidget extends StatelessWidget {
  const DoneListWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Apis.doneTasks.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Card(
        color: const Color.fromARGB(255, 194, 244, 220),
        child: CheckboxListTile(
          value: true,
          title: Text(
            Apis.doneTasks[index]['required_action'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Issued at : ${Apis.doneTasks[index]['issued_at']}',
                  ),
                  SizedBox(
                    width: mediaQuery.width / 30,
                  ),
                  Text(
                    'done at : ${Apis.doneTasks[index]['done_at']}',
                  ),
                ],
              ),
              Text(
                Apis.doneTasks[index]['done_by_admin'] == null
                    ? 'Done by : No body'
                    : 'Done by : ${Apis.doneTasks[index]['done_by_admin']['name']}',
              ),
            ],
          ),
          onChanged: (value) {},
        ),
      ),
    )
        .animate()
        .slide(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCirc)
        .fadeIn(delay: const Duration(milliseconds: 200));
  }
}

