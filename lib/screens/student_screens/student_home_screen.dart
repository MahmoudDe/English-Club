// ignore_for_file: must_be_immutable

import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/student_home_screen/book_widget.dart';
import 'package:bdh/widgets/student_home_screen/borrowed_book_widget%20copy.dart';
import 'package:bdh/widgets/student_home_screen/card_widget.dart';
import 'package:bdh/widgets/student_home_screen/student_image_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatefulWidget {
  StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final pageController = PageController();
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Provider.of<Apis>(context, listen: false).studentHomeScreen()) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Consumer<Apis>(
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.5,
                child: Image(
                  image: const AssetImage('assets/images/backRoad.png'),
                  height: mediaQuery.height,
                  width: mediaQuery.width,
                  fit: BoxFit.fill,
                ),
              ),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.main,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: mediaQuery.height / 10,
                          ),
                          StudentImageWidget(mediaQuery: mediaQuery),
                          SizedBox(
                            height: mediaQuery.width / 50,
                          ),
                          Text(
                            Apis.studentModel!.name!,
                            style: TextStyle(
                                color: AppColors.main,
                                fontWeight: FontWeight.bold,
                                fontSize: mediaQuery.width / 20),
                          ),
                          SizedBox(
                            height: mediaQuery.height / 40,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.width / 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardWidget(
                                    color: Colors.brown,
                                    icon: 'assets/images/bronze.png',
                                    data: Apis.studentModel!.bronzeCoins
                                        .toString(),
                                    mediaQuery: mediaQuery),
                                CardWidget(
                                    color: Colors.grey,
                                    icon: 'assets/images/silver.png',
                                    data: Apis.studentModel!.silverCoins
                                        .toString(),
                                    mediaQuery: mediaQuery),
                                CardWidget(
                                    color: Colors.amber,
                                    icon: 'assets/images/golden.png',
                                    data: Apis.studentModel!.goldenCoins
                                        .toString(),
                                    mediaQuery: mediaQuery),
                              ],
                            ),
                          ),
                          Apis.studentModel!.testAvailableForStories!.isEmpty &&
                                  Apis.studentModel!.borrowedStories!.isEmpty
                              ? SizedBox(
                                  height: mediaQuery.height / 20,
                                )
                              : SizedBox(
                                  height: mediaQuery.height / 100,
                                ),
                          Apis.studentModel!.testAvailableForStories!.isEmpty &&
                                  Apis.studentModel!.borrowedStories!.isEmpty
                              ? const Text('You don\'t have any activities yet')
                              : const SizedBox(),
                          Apis.studentModel!.testAvailableForStories!.isEmpty
                              ? const SizedBox()
                              : Container(
                                  width: mediaQuery.width / 1.1,
                                  height: mediaQuery.height / 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.main,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      )),
                                  child: const Text(
                                    'Available stories tests',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                          Apis.studentModel!.testAvailableForStories!.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: mediaQuery.height / 90,
                                ),
                          Apis.studentModel!.testAvailableForStories!.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: mediaQuery.height / 2.5,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Apis.studentModel!
                                        .testAvailableForStories!.length,
                                    itemBuilder: (context, index) {
                                      return BookWidget(
                                        index2: index,
                                        mediaQuery: mediaQuery,
                                      );
                                    },
                                  ),
                                ),
                          Apis.studentModel!.borrowedStories!.isEmpty
                              ? const SizedBox()
                              : Container(
                                  width: mediaQuery.width / 1.1,
                                  height: mediaQuery.height / 25,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.main,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      )),
                                  child: const Text(
                                    'Borrowed stories',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                          Apis.studentModel!.borrowedStories!.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: mediaQuery.height / 90,
                                ),
                          Apis.studentModel!.borrowedStories!.isEmpty
                              ? const SizedBox()
                              : SizedBox(
                                  height: mediaQuery.height / 2.5,
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: Apis.studentModel!
                                        .testAvailableForStories!.length,
                                    itemBuilder: (context, index) {
                                      return BorrowedBookWidget(
                                        index2: index,
                                        mediaQuery: mediaQuery,
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
