import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/prizes_screen/collected_prize_widget.dart';
import 'package:bdh/widgets/prizes_screen/unCollected_prize_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles/app_colors.dart';
import '../widgets/title_widget.dart';

class PrizeScreen extends StatefulWidget {
  const PrizeScreen({super.key});

  @override
  State<PrizeScreen> createState() => _PrizeScreenState();
}

class _PrizeScreenState extends State<PrizeScreen>
    with SingleTickerProviderStateMixin {
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Provider.of<Apis>(context, listen: false).allPrizes()) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool isLoading = false;
  late TabController? controller;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);

    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        title: Text(
          'Students Prizes',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: mediaQuery.width / 24),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: mediaQuery.height / 25,
            child: TitleWidget(
              mediaQuery: mediaQuery,
              title: 'Prizes',
              icon: Icon(
                Icons.notifications_active,
                color: AppColors.whiteLight,
              ),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.main,
                  ),
                )
              : Consumer<Apis>(
                  builder: (context, value, child) => Container(
                    margin: EdgeInsets.only(top: mediaQuery.height / 20),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.amber)),
                            child: Tabs(
                                controller: controller!,
                                mediaQuery: mediaQuery)),
                        SlidesForTabs(
                          mediaQuery: mediaQuery,
                          controller: controller,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  Tabs({
    required this.controller,
    required this.mediaQuery,
  });
  final Size mediaQuery;
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      dividerColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 20),
      tabAlignment: TabAlignment.fill,
      tabs: const [
        Tab(
          text: 'UnCollected',
        ),
        Tab(
          text: 'Collected',
        ),
      ],
    );
  }
}

class SlidesForTabs extends StatelessWidget {
  SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
  });

  final Size mediaQuery;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.height / 1.3,
      child: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          UnCollectedPrizeWidget(mediaQuery: mediaQuery),
          CollectedPrizeWidget(mediaQuery: mediaQuery),
        ],
      ),
    );
  }
}
