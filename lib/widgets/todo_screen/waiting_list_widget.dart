import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class WaitingListWidget extends StatefulWidget {
  const WaitingListWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<WaitingListWidget> createState() => _WaitingListWidgetState();
}

class _WaitingListWidgetState extends State<WaitingListWidget> {
  void showDialogEndTask(BuildContext context, String taskId) {
    QuickAlert.show(
      context: context,
      title: 'Make it done',
      text: 'Did you done this task ?',
      type: QuickAlertType.info,
      animType: QuickAlertAnimType.slideInRight,
      cancelBtnText: 'no',
      confirmBtnText: 'yes',
      onConfirmBtnTap: () async {
        if (await Provider.of<Apis>(context, listen: false)
            .makeTaskDone(taskId: taskId)) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Apis.waitingTasks.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Card(
        child: CheckboxListTile(
          value: false,
          title: Text(
            Apis.waitingTasks[index]['required_action'],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Issued at : ${Apis.waitingTasks[index]['issued_at']}',
          ),
          onChanged: (value) {
            showDialogEndTask(
                context, Apis.waitingTasks[index]['id'].toString());
          },
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
