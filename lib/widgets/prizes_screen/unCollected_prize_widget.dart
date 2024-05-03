// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class UnCollectedPrizeWidget extends StatefulWidget {
  const UnCollectedPrizeWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<UnCollectedPrizeWidget> createState() => _WaitingListWidgetState();
}

class _WaitingListWidgetState extends State<UnCollectedPrizeWidget> {
  void showDialogEndTask(
      {required BuildContext context,
      required String taskId,
      required String studentId}) {
    QuickAlert.show(
      context: context,
      title: 'Make it done',
      text: 'Did you give this prize to the right student?',
      type: QuickAlertType.info,
      animType: QuickAlertAnimType.slideInRight,
      cancelBtnText: 'no',
      confirmBtnText: 'yes',
      onConfirmBtnTap: () async {
        if (await Provider.of<Apis>(context, listen: false)
            .givePrize(studentId: studentId, prizeId: taskId)) {
          Navigator.pop(context);
          QuickAlert.show(
              context: context, type: QuickAlertType.success, text: 'Success!');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Apis.waitingPrizes.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Card(
        color: const Color.fromARGB(255, 194, 244, 220),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child:
                Apis.waitingPrizes[index]['giveItTo']['profile_picture'] != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          '${dataClass.urlHost}${Apis.waitingPrizes[index]['giveItTo']['profile_picture']}',
                        ),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        radius: 23,
                      )
                    : const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
          ),
          title: Text(
            Apis.waitingPrizes[index]['giveItTo']['name'],
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            Apis.waitingPrizes[index]['giveItTo']['pivot']['date'].toString(),
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          trailing: Checkbox(
            value: false,
            onChanged: (value) {
              showDialogEndTask(
                  context: context,
                  studentId:
                      Apis.waitingPrizes[index]['giveItTo']['id'].toString(),
                  taskId: Apis.waitingPrizes[index]['id'].toString());
            },
          ),
          children: [
            //Reason
            ListTile(
              title: const Text(
                'Reason',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                Apis.waitingPrizes[index]['giveItTo']['pivot']['reason']
                    .toString(),
              ),
            ),
            //score
            ListTile(
              title: const Text(
                'Score',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/studentScore.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing:
                  Text(Apis.waitingPrizes[index]['score_points'].toString()),
            ),
            //golden cards
            ListTile(
              title: const Text(
                'Golden cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/golden.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing:
                  Text(Apis.waitingPrizes[index]['golden_coin'].toString()),
            ),
            //silver cards
            ListTile(
              title: const Text(
                'Silver cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/silver.png'),
                height: widget.mediaQuery.height / 25,
              ),
              trailing:
                  Text(Apis.waitingPrizes[index]['silver_coin'].toString()),
            ),
            //bronze cards
            ListTile(
              title: const Text(
                'Bronze cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/bronze.png'),
                height: widget.mediaQuery.height / 30,
              ),
              trailing:
                  Text(Apis.waitingPrizes[index]['bronze_coin'].toString()),
            ),
          ],
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
