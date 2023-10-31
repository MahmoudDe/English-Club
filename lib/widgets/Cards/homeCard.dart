import 'package:flutter/material.dart';

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

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
                        image: const DecorationImage(
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
    );
  }
}
