import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class UserNewPointsWidget extends StatelessWidget {
  const UserNewPointsWidget({
    super.key,
    required this.isNewScoreTimeStart,
    required this.mediaQuery,
    required this.result,
  });
  final bool isNewScoreTimeStart;
  final Size mediaQuery;
  final Map<String, dynamic> result;

  @override
  Widget build(BuildContext context) {
    return isNewScoreTimeStart
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 30,
                    vertical: mediaQuery.height / 60),
                height: mediaQuery.height / 1.5,
                width: mediaQuery.width / 1.05,
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(color: Colors.amber, width: 2)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: mediaQuery.width / 2,
                        height: mediaQuery.height / 15,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          result['evaluation'],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.width / 15),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height / 80,
                      ),
                      ListTile(
                        title: Text(
                          'Your Mark',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.width / 15),
                        ),
                        trailing: Text(
                          result['deservedMark'].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.width / 15),
                        ),
                      ),
                      SizedBox(
                        height: mediaQuery.height / 40,
                      ),
                      result['evaluation'] == 'Fail'
                          ? Text(
                              'Next time try harder',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: mediaQuery.width / 20),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(
                                    'Score',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                  trailing: Text(
                                    result['prize']['score_points'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Golden coins',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                  trailing: Text(
                                    result['prize']['golden_coin'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Silver coins',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                  trailing: Text(
                                    result['prize']['silver_coin'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Bronze coins',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                  trailing: Text(
                                    result['prize']['bronze_coin'].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: mediaQuery.width / 20),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: mediaQuery.height / 30,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber),
                          onPressed: () {
                            Phoenix.rebirth(context);
                          },
                          child: const Text(
                            'Home screen',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              )
            ],
          )
            .animate()
            .scale(duration: const Duration(seconds: 1))
            .moveY(end: 0, begin: -mediaQuery.height / 3)
        : const SizedBox(
            height: 0,
          );
  }
}
