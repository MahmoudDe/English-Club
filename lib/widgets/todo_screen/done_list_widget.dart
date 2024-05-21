import 'package:bdh/data/data.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../server/apis.dart';

class DoneListWidget extends StatefulWidget {
  const DoneListWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<DoneListWidget> createState() => _DoneListWidgetState();
}

class _DoneListWidgetState extends State<DoneListWidget> {
  List doneTasks = [];
  final scrollController = ScrollController();
  bool isLoading = false;
  bool isGettingData = false;

  Future<void> getData() async {
    setState(() {
      isGettingData = true;
    });
    try {
      if (await Provider.of<Apis>(context, listen: false).toDoList(page: '1')) {
        setState(() {
          // for (int i = 0; i < Apis.doneTasks.length; i++) {
          //   doneTasks.add(Apis.doneTasks[i]);
          // }
          doneTasks = doneTasks + Apis.doneTasks;
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
    print('-----------------------------------------');
    print(doneTasks);
    print('-----------------------------------------');
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
            .toDoList(page: dataClass.doneTaskIndex.toString())) {
          setState(() {
            // for (int i = 0; i < Apis.doneTasks.length; i++) {
            //   doneTasks.add(Apis.doneTasks[i]);
            // }
            doneTasks = doneTasks + Apis.doneTasks;
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
        : RefreshIndicator(
            onRefresh: pagination,
            child: doneTasks.isEmpty
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
                              child: CheckboxListTile(
                                value: true,
                                title: Text(
                                  doneTasks[index]['required_action'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Issued at : ${doneTasks[index]['issued_at']}',
                                    ),
                                    SizedBox(
                                      height: widget.mediaQuery.height / 100,
                                    ),
                                    Text(
                                      'done at : ${doneTasks[index]['done_at']}',
                                    ),
                                    Text(
                                      doneTasks[index]['done_by_admin'] == null
                                          ? 'Done by : No body'
                                          : 'Done by : ${doneTasks[index]['done_by_admin']['name']}',
                                    ),
                                  ],
                                ),
                                onChanged: (value) {},
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
                    .fadeIn(delay: const Duration(milliseconds: 200)),
          );
  }
}
