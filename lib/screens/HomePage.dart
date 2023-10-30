import 'package:bdh/widgets/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

import '../background/BackgroundPaint.dart';

class HomeScreen extends StatelessWidget {
  final List<String> descriptions = [
    'Alaa Shebany has borrowed a new story',
    'Magmoud turn back a new story',
    'admin has sent a new message for you',
    'Alaa Shebany has borrowed a new story',
    'Magmoud turn back a new story',
    'admin has sent a new message for you',
    'Alaa Shebany has borrowed a new story',
    'Magmoud turn back a new story',
    'admin has sent a new message for you',
    'Alaa Shebany has borrowed a new story',
    'Magmoud turn back a new story',
    'admin has sent a new message for you',
  ];

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
            child: Column(
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
                Flexible(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 0.0,
                    color: Colors.white,
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: descriptions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: ListTile(
                                leading: Container(
                                  width: 50.0,
                                  height: 60.0,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bdh_logo2.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  descriptions[index],
                                  style: TextStyle(
                                      fontFamily: 'Avenir',
                                      color: Colors.grey.shade800),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
