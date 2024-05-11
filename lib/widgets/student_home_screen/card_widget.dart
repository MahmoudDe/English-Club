import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key,
      required this.color,
      required this.icon,
      required this.data,
      required this.mediaQuery});
  final Color color;
  final String icon;
  final String data;
  final Size mediaQuery;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: mediaQuery.height / 7,
      width: mediaQuery.width / 3.5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: mediaQuery.height / 60,
          ),
          Image(
            image: AssetImage(
              icon,
            ),
            // height: mediaQuery.height / 15,
            width: mediaQuery.width / 7,
          ),
          SizedBox(
            height: mediaQuery.height / 100,
          ),
          Text(
            data,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.width / 20),
          )
        ],
      ),
    );
  }
}
