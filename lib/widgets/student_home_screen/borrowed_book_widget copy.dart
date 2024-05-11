import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../server/apis.dart';
import '../../server/image_url.dart';

class BorrowedBookWidget extends StatelessWidget {
  const BorrowedBookWidget({
    super.key,
    required this.index2,
    required this.mediaQuery,
  });
  final int index2;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          child: Container(
              height: mediaQuery.height / 3,
              width: mediaQuery.width / 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Apis.studentModel!.borrowedStories![index2]['story']
                          ['cover_url'] !=
                      null
                  ? Image(
                      image: NetworkImage(
                        '${ImageUrl.imageUrl}${Apis.studentModel!.testAvailableForStories![index2]['cover_url']}',
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    )
                  : const Image(
                      image: AssetImage('assets/images/bookCover.jpg'),
                      fit: BoxFit.cover,
                    )),
        ),
        Container(
          height: mediaQuery.height / 18,
          width: mediaQuery.width / 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            'return at ${Apis.studentModel!.borrowedStories![index2]['due_date']}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
