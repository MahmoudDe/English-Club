import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../server/image_url.dart';
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
        title: ListTile(
          leading: CircleAvatar(
            backgroundImage: widget.studentData['profile_picture'] == null
                ? null
                : NetworkImage(
                    '${ImageUrl.imageUrl}${widget.studentData['profile_picture']}'),
            backgroundColor: Colors.white,
            child: Center(
                child: Icon(
              Icons.person,
              color: AppColors.main,
            )),
          ),
          title: Text(
            widget.studentData['name'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
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
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuery.width / 20,
                      vertical: mediaQuery.height / 200),
                  decoration: BoxDecoration(color: widget.screenColor),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: mediaQuery.width / 25,
                        color: AppColors.whiteLight,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                          padding: EdgeInsets.only(top: mediaQuery.height / 90),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of items in each row
                            mainAxisSpacing: 8.0, // Spacing between rows
                            crossAxisSpacing: 8.0, // Spacing between columns
                            childAspectRatio:
                                2 / 3, // Width to height ratio of grid items
                          ),
                          itemCount: Apis.subLevelBooksList.length,
                          itemBuilder: (context, index2) => Container(
                              height: mediaQuery.height / 2,
                              width: mediaQuery.width / 40,
                              foregroundDecoration:
                                  Apis.subLevelBooksList[index2]['status'] == ''
                                      ? const BoxDecoration(
                                          color: Colors.grey,
                                          backgroundBlendMode:
                                              BlendMode.saturation,
                                        )
                                      : const BoxDecoration(),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Apis.subLevelBooksList[index2]
                                                ['status'] ==
                                            'success'
                                        ? Colors.greenAccent.withOpacity(0.6)
                                        : Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Apis.subLevelBooksList[index2]
                                          ['cover_url'] !=
                                      null
                                  ? Image(
                                      image: NetworkImage(
                                        '${ImageUrl.imageUrl}${Apis.subLevelBooksList[index2]['cover_url']}',
                                      ),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    )
                                  : const Image(
                                      image: AssetImage(
                                          'assets/images/bookCover.jpg'),
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ).animate().slide(
                        begin: const Offset(0, 2),
                        end: const Offset(0, 0),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOutCirc),
              ],
            ),
          )
        ],
      ),
    );
  }
}
