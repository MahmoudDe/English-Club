import 'package:bdh/server/apis.dart';
import 'package:bdh/widgets/sub_levle_books_screen/book_subLevel_widget.dart';
import 'package:bdh/widgets/sub_levle_books_screen/title_subLevel_widget.dart';
import 'package:bdh/widgets/sub_levle_books_screen/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../styles/app_colors.dart';

class SubLevelBooksScreen extends StatefulWidget {
  const SubLevelBooksScreen(
      {super.key,
      required this.screenColor,
      required this.screenDarkColor,
      required this.studentData,
      required this.title,
      required this.subLevelId,
      required this.studentId});
  final Color screenColor;
  final Color screenDarkColor;
  final Map studentData;
  final String title;
  final String subLevelId;
  final String studentId;

  @override
  State<SubLevelBooksScreen> createState() => _SubLevelBooksScreenState();
}

class _SubLevelBooksScreenState extends State<SubLevelBooksScreen> {
  bool isLoading = false;
  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      print('2====================================');
      print(widget.studentId);
      if (await Provider.of<Apis>(context, listen: false).storiesInSubLevel(
          studentId: widget.studentId, subLevelId: widget.subLevelId)) {
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
      appBar: AppBar(
        title: UserWidget(studentData: widget.studentData),
        backgroundColor: widget.screenDarkColor,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: mediaQuery.height,
            width: mediaQuery.width,
            child: const Opacity(
              opacity: 0.5,
              child: Image(
                image: AssetImage(
                  'assets/images/backRoad.png',
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TitleSubLevelWidget(
                    title: widget.title,
                    mediaQuery: mediaQuery,
                    screenColor: widget.screenColor),
                isLoading
                    ? Padding(
                        padding: EdgeInsets.only(top: mediaQuery.height / 2.5),
                        child: CircularProgressIndicator(
                          color: AppColors.main,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.width / 40,
                            vertical: mediaQuery.height / 100),
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding:
                                EdgeInsets.only(top: mediaQuery.height / 90),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of items in each row
                              mainAxisSpacing: mediaQuery.height /
                                  30, // Spacing between rows
                              crossAxisSpacing: 8.0, // Spacing between columns
                              childAspectRatio: 1.60 /
                                  3, // Width to height ratio of grid items
                            ),
                            itemCount: Apis.subLevelBooksList.length,
                            itemBuilder: (context, index2) =>
                                BookSubLevelWidget(
                                    studentName: widget.studentData['name'],
                                    screenColor: widget.screenColor,
                                    studentId:
                                        widget.studentData['id'].toString(),
                                    index2: index2,
                                    mediaQuery: mediaQuery)),
                      )
                        .animate()
                        .slide(
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOutCirc)
                        .fadeIn(delay: const Duration(milliseconds: 200)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
