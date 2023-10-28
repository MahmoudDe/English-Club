import 'package:flutter/material.dart';

// ignore: camel_case_types
class headProfileWidget extends StatelessWidget {
  const headProfileWidget({
    super.key,
    required this.screenHight,
    required this.screenWidth,
    required this.icon,
    required this.nameColor,
    required this.circleColor,
    required this.name,
    required this.subTitle,
  });

  final double screenHight;
  final double screenWidth;
  final Icon icon;
  final String name;
  final String subTitle;

  final Color nameColor;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //this container for user image
        Container(
          //first layer light blue
          padding: const EdgeInsets.all(3),

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 0.11,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            //second layer white
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: Center(
              child: icon,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        //this column for student name&grade
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                  color: nameColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Euclid Circular A'),
            ),
            Text(
              subTitle,
              style: const TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
