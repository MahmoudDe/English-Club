import 'package:bdh/widgets/Cards/homeCard.dart';
import 'package:bdh/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import '../background/BackgroundPaint.dart';

class HomeScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(
                mediaQuery.width,
                (mediaQuery.width * 0.5833333333333334)
                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automaticallypainter: AppBarCustom(),
            painter: AppBarCustom(),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: mediaQuery.height / 8),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.notifications_active,
                        color: Colors.amberAccent,
                      )
                    ],
                  ),
                ),
                HomeCard()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
