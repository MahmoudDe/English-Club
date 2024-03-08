import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

class BookDataWidget extends StatelessWidget {
  const BookDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          infoWidget('Title',
              showBookController.bookData[0]['title'].toString(), mediaQuery),
          infoWidget(
              'subQuestions',
              showBookController.bookData[0]['test']['subQuestions_count']
                  .toString(),
              mediaQuery),
          infoWidget(
              'Quantity',
              showBookController.bookData[0]['quantity'].toString(),
              mediaQuery),
          infoWidget(
              'Allowed borrow days',
              showBookController.bookData[0]['allowed_borrow_days'].toString(),
              mediaQuery),
          SizedBox(
            height: mediaQuery.height / 30,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: AppColors.main,
              ),
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: mediaQuery.width / 20),
                child: const Text(
                  'Show Quiz',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ))
        ],
      ),
    );
  }

  Widget infoWidget(String title, String value, Size mediaQuery) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 20, vertical: mediaQuery.height / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Colors.amber, width: 2)),
      child: ListTile(
        leading: Text(
          title,
          style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          value,
          style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
