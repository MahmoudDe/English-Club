import 'package:bdh/data/data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../server/apis.dart';

class CollectedPrizeWidget extends StatefulWidget {
  const CollectedPrizeWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<CollectedPrizeWidget> createState() => _CollectedPrizeWidgetState();
}

class _CollectedPrizeWidgetState extends State<CollectedPrizeWidget> {
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
          .collectedPrize(page: '1')) {
        setState(() {
          // for (int i = 0; i < Apis.doneTasks.length; i++) {
          //   doneTasks.add(Apis.doneTasks[i]);
          // }
          doneTasks = doneTasks + Apis.donePrizes;
          print('-----------------------------------------');
          print(doneTasks);
          print('-----------------------------------------');
          isGettingData = false;
        });
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
            .collectedPrize(page: dataClass.doneTaskIndex.toString())) {
          setState(() {
            // for (int i = 0; i < Apis.doneTasks.length; i++) {
            //   doneTasks.add(Apis.doneTasks[i]);
            // }
            doneTasks = doneTasks + Apis.donePrizes;
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
        : ListView.builder(
                controller: scrollController,
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
                          value: true,
                          onChanged: (value) {},
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
                            trailing: Text(doneTasks[index]['giveItTo']['score']
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
                              image:
                                  const AssetImage('assets/images/golden.png'),
                              height: widget.mediaQuery.height / 30,
                            ),
                            trailing: Text(doneTasks[index]['giveItTo']
                                    ['golden_coins']
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
                              image:
                                  const AssetImage('assets/images/silver.png'),
                              height: widget.mediaQuery.height / 25,
                            ),
                            trailing: Text(doneTasks[index]['giveItTo']
                                    ['silver_coins']
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
                              image:
                                  const AssetImage('assets/images/bronze.png'),
                              height: widget.mediaQuery.height / 30,
                            ),
                            trailing: Text(doneTasks[index]['giveItTo']
                                    ['bronze_coins']
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