// ignore_for_file: use_build_context_synchronously

import 'package:bdh/data/data.dart';
import 'package:bdh/screens/prizes_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const PrizeScreen(),
          ));
          QuickAlert.show(
              context: context, type: QuickAlertType.success, text: 'Success!');
        }
      },
    );
  }

  List doneTasks = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool isGettingData = false;

  Future<void> getData() async {
    setState(() {
      isGettingData = true;
    });
    try {
      if (await Provider.of<Apis>(context, listen: false)
          .unCollectedPrize(page: '1')) {
        setState(() {
          // for (int i = 0; i < Apis.doneTasks.length; i++) {
          //   doneTasks.add(Apis.doneTasks[i]);
          // }
          doneTasks = doneTasks + Apis.waitingPrizes;
        });
        print('-----------------------------------------');
        print(doneTasks);
        print('-----------------------------------------');
        isGettingData = false;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    dataClass.doneTaskIndex = 0;
    getData();
    scrollController.addListener(pagination);

    super.initState();
  }

  Future pagination() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      dataClass.doneTaskIndex++;
      setState(() {
        isLoading = true;
      });
      try {
        if (await Provider.of<Apis>(context, listen: false)
            .unCollectedPrize(page: dataClass.doneTaskIndex.toString())) {
          setState(() {
            // for (int i = 0; i < Apis.doneTasks.length; i++) {
            //   doneTasks.add(Apis.doneTasks[i]);
            // }
            doneTasks = doneTasks + Apis.waitingPrizes;
            isLoading = false;
          });
        }
      } catch (e) {
        print(e);
      }
      print(dataClass.doneTaskIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isGettingData
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.main,
            ),
          )
        : doneTasks.isEmpty
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
                    itemCount: doneTasks.length + (isLoading ? 1 : 0),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      if (index == doneTasks.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: widget.mediaQuery.height / 80),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.main,
                            ),
                          ),
                        );
                      } else {
                        return Card(
                          color: const Color.fromARGB(255, 194, 244, 220),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.white,
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.orange,
                              child: doneTasks[index]['giveItTo']
                                          ['profile_picture'] !=
                                      null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        '${dataClass.urlHost}${doneTasks[index]['giveItTo']['profile_picture']}',
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
                              doneTasks[index]['giveItTo']['name'],
                              style: const TextStyle(fontSize: 18),
                            ),
                            // subtitle: Text(
                            //   doneTasks[index]['giveItTo']['pivot']['date']
                            //       .toString(),
                            //   style: const TextStyle(
                            //       fontSize: 14, color: Colors.black54),
                            // ),
                            trailing: Checkbox(
                              value: false,
                              onChanged: (value) {
                                showDialogEndTask(
                                    context: context,
                                    studentId: doneTasks[index]['giveItTo']
                                            ['id']
                                        .toString(),
                                    taskId: doneTasks[index]['prize']['id']
                                        .toString());
                              },
                            ),
                            children: [
                              //Reason
                              ListTile(
                                title: const Text(
                                  'Reason',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  doneTasks[index]['reason'].toString(),
                                ),
                              ),
                              //score
                              ListTile(
                                title: const Text(
                                  'Score',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Image(
                                  image: const AssetImage(
                                      'assets/images/studentScore.png'),
                                  height: widget.mediaQuery.height / 30,
                                ),
                                trailing: Text(doneTasks[index]['prize']
                                        ['score_points']
                                    .toString()),
                              ),
                              //golden cards
                              ListTile(
                                title: const Text(
                                  'Golden cards',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Image(
                                  image: const AssetImage(
                                      'assets/images/golden.png'),
                                  height: widget.mediaQuery.height / 30,
                                ),
                                trailing: Text(doneTasks[index]['prize']
                                        ['golden_coin']
                                    .toString()),
                              ),
                              //silver cards
                              ListTile(
                                title: const Text(
                                  'Silver cards',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Image(
                                  image: const AssetImage(
                                      'assets/images/silver.png'),
                                  height: widget.mediaQuery.height / 25,
                                ),
                                trailing: Text(doneTasks[index]['prize']
                                        ['silver_coin']
                                    .toString()),
                              ),
                              //bronze cards
                              ListTile(
                                title: const Text(
                                  'Bronze cards',
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.bold),
                                ),
                                leading: Image(
                                  image: const AssetImage(
                                      'assets/images/bronze.png'),
                                  height: widget.mediaQuery.height / 30,
                                ),
                                trailing: Text(doneTasks[index]['prize']
                                        ['bronze_coin']
                                    .toString()),
                              ),
                            ],
                          ),
                        );
                      }
                    })
                .animate()
                .slide(
                    begin: const Offset(0, 1),
                    end: const Offset(0, 0),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOutCirc)
                .fadeIn(delay: const Duration(milliseconds: 200));
  }
}
