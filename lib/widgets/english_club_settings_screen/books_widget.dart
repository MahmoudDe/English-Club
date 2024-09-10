import 'package:bdh/screens/show_book_details_screen.dart';
import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';

class BooksWidget extends StatelessWidget {
  const BooksWidget(
      {super.key,
      required this.mediaQuery,
      required this.index,
      required this.index1,
      required this.levels});
  final Size mediaQuery;
  final int index;
  final int index1;
  final List levels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 40, vertical: mediaQuery.height / 100),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mediaQuery.height / 90),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items in each row
          mainAxisSpacing: 8.0, // Spacing between rows
          crossAxisSpacing: 8.0, // Spacing between columns
          childAspectRatio: 2 / 3, // Width to height ratio of grid items
        ),
        itemCount: levels[index]['sub_levels'][index1]['stories'].length,
        itemBuilder: (context, index2) => GestureDetector(
          onTap: (() {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ShowBookDetailsScreen(
                  bookId: levels[index]['sub_levels'][index1]['stories'][index2]
                          ['id']
                      .toString(),
                  levelName: levels[index]['name'],
                  subLevelId:
                      levels[index]['sub_levels'][index1]['id'].toString(),
                  subLevelName: levels[index]['sub_levels'][index1]['name']),
            ));
          }),
          child: Container(
              height: mediaQuery.height / 2,
              width: mediaQuery.width / 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 246, 246, 246),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: levels[index]['sub_levels'][index1]['stories'][index2]
                          ['cover_url'] !=
                      null
                  ? Image(
                      image: NetworkImage(
                        '${ImageUrl.imageUrl}${levels[index]['sub_levels'][index1]['stories'][index2]['cover_url']}',
                      ),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    )
                  : const Image(
                      image: AssetImage('assets/images/bookCover.jpg'),
                      fit: BoxFit.cover,
                    )),
        ),
      ),
    );
  }
}
