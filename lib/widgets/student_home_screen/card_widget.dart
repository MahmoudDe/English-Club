import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key,
      required this.color,
      required this.icon,
      required this.data,
      required this.title,
      required this.mediaQuery});
  final Color color;
  final String icon;
  final String title;
  final String data;
  final Size mediaQuery;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: mediaQuery.height / 7,
      width: mediaQuery.width,
      margin: EdgeInsets.symmetric(vertical: mediaQuery.height / 150),
      padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 20, vertical: mediaQuery.height / 90),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        border: Border.all(color: color, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image: AssetImage(
                  icon,
                ),
                // height: mediaQuery.height / 15,
                width: mediaQuery.width / 9,
              ),
              SizedBox(
                width: mediaQuery.width / 20,
              ),
              Text(
                title,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 30),
              )
            ],
          ),
          Text(
            data,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.width / 20),
          )
        ],
      ),
    );
  }
}
