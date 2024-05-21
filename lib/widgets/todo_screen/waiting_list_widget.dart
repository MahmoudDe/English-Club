import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../styles/app_colors.dart';

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
      text: 'Did you do this task ?',
      type: QuickAlertType.info,
      animType: QuickAlertAnimType.slideInRight,
      cancelBtnText: 'no',
      confirmBtnText: 'yes',
      onConfirmBtnTap: () async {
        if (await Provider.of<Apis>(context, listen: false)
            .makeTaskDone(taskId: taskId, page: '1')) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Apis.waitingTasks.isEmpty
        ? Column(
            children: [
              SizedBox(
                height: widget.mediaQuery.height / 10,
              ),
              Center(
                child: Lottie.asset('assets/lotties/noData.json',
                    height: MediaQuery.of(context).size.height / 3),
              ),
              Text(
                'No data',
                style: TextStyle(
                    color: AppColors.main, fontWeight: FontWeight.bold),
              )
            ],
          )
        : ListView.builder(
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
