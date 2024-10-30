import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/show_book_screen/book_cover_widget.dart';
import 'package:bdh/widgets/show_book_screen/book_data_widget.dart';
import 'package:bdh/widgets/show_book_screen/float_button_widget.dart';
import 'package:bdh/widgets/show_book_screen/loading_book_widget.dart';
import 'package:bdh/widgets/show_book_screen/qr_widget.dart';
import 'package:bdh/widgets/title_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ShowBookDetailsScreen extends StatefulWidget {
  const ShowBookDetailsScreen(
      {super.key,
      required this.bookId,
      required this.subLevelId,
      required this.subLevelName,
      required this.levelName});
  final String bookId;
  final String subLevelId;
  final String subLevelName;
  final String levelName;

  @override
  State<ShowBookDetailsScreen> createState() => _ShowBookDetailsScreenState();
}

class _ShowBookDetailsScreenState extends State<ShowBookDetailsScreen> {
  @override
  void initState() {
    super.initState();
    showBookController.bookId = widget.bookId;
    showBookController.subLevelId = widget.subLevelId;
    showBookController.subLevelName = widget.subLevelName;
    showBookController.context = context;
    getData();
  }

  Future<void> getData() async {
    setState(() {
      showBookController.isLoading = true;
    });
    try {
      await Provider.of<showBookController>(context, listen: false).getData();
      setState(() {
        showBookController.isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Consumer(
      builder: (context, value, child) {
        return showBookController.isLoading
            ? LoadingBookWidget(mediaQuery: mediaQuery)
            : WillPopScope(
                onWillPop: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EnglishClubSettingsScreen(),
                  ));
                  return false;
                },
                child: Scaffold(
                  floatingActionButton: FloatButtonWidget(
                    testId:
                        showBookController.bookData[0]['test_id'].toString(),
                    mediaQuery: mediaQuery,
                    levelName: widget.levelName,
                    subLevelName: widget.subLevelName,
                  ),
                  appBar: AppBar(
                    backgroundColor: AppColors.main,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(
                        builder: (context) => const EnglishClubSettingsScreen(),
                      )),
                    ),
                  ),
                  body: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            TitleWidget(
                                mediaQuery: mediaQuery,
                                title:
                                    '${widget.subLevelName} / ${widget.levelName}',
                                icon: const Icon(Icons.abc)),
                            SizedBox(
                              height: mediaQuery.height / 30,
                            ),
                            BookCoverWidget(mediaQuery: mediaQuery),
                            SizedBox(
                              height: mediaQuery.height / 30,
                            ),
                            const BookDataWidget(),
                          ],
                        ),
                      ),
                      QrWidget(mediaQuery: mediaQuery),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
