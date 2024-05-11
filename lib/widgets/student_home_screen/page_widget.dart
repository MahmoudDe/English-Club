import 'package:flutter/material.dart';

import '../../model/constants.dart';
import '../../server/apis.dart';

class PageWidget extends StatelessWidget {
  const PageWidget({super.key, required this.mediaQuery, required this.index});
  final Size mediaQuery;
  final int index;

  Color darkenColor(Color color, [double factor = 0.5]) {
    assert(factor >= 0 && factor <= 1);
    final int red = (color.red * factor).round();
    final int green = (color.green * factor).round();
    final int blue = (color.blue * factor).round();
    return Color.fromRGBO(red, green, blue, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQuery.width,
      height: mediaQuery.height,
      alignment: Alignment.center,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
              opacity: 0.5,
              child: Image(
                image: const AssetImage('assets/images/circleBackground.png'),
                fit: BoxFit.fill,
                height: mediaQuery.height,
                width: mediaQuery.width * 2,
              )),
          Container(
            height: mediaQuery.height / 2,
            width: mediaQuery.width / 1.2,
            decoration: BoxDecoration(
                color: Constants.colorsForRoad[index],
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                    width: 5,
                    color: darkenColor(Constants.colorsForRoad[index], 0.7)
                        .withOpacity(0.9)),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.white54,
                      offset: Offset(1, 0),
                      blurRadius: 100,
                      blurStyle: BlurStyle.inner,
                      spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Apis.studentModel!.progress![index]['section']['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 18,
                  ),
                ),
                ListTile(
                  title: const Text(
                    'Current level',
                  ),
                  trailing: Text(
                      Apis.studentModel!.progress![index]['level']['name']),
                ),
                ElevatedButton(
                  onPressed: () {
                    //TODO: navigate to the road
                    print('navigate to the road');
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    'Let\'s start our journey',
                    style: TextStyle(
                        color: Constants.colorsForRoad[index],
                        fontWeight: FontWeight.bold),
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
