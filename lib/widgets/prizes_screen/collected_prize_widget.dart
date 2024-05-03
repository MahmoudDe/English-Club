import 'package:bdh/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../server/apis.dart';

class CollectedPrizeWidget extends StatelessWidget {
  const CollectedPrizeWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Apis.doneTasks.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => Card(
        color: const Color.fromARGB(255, 194, 244, 220),
        child: ExpansionTile(
          collapsedBackgroundColor: Colors.white,
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.orange,
            child: Apis.donePrizes[index]['giveItTo']['profile_picture'] != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${dataClass.urlHost}${Apis.donePrizes[index]['giveItTo']['profile_picture']}',
                    ),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    radius: 23,
                  )
                : const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
          ),
          title: Text(
            Apis.donePrizes[index]['giveItTo']['name'],
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            Apis.donePrizes[index]['giveItTo']['pivot']['date'].toString(),
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          trailing: Checkbox(
            value: true,
            onChanged: (value) {},
          ),
          children: [
            //Reason
            ListTile(
              title: const Text(
                'Reason',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                Apis.donePrizes[index]['giveItTo']['pivot']['reason']
                    .toString(),
              ),
            ),
            //score
            ListTile(
              title: const Text(
                'Score',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/studentScore.png'),
                height: mediaQuery.height / 30,
              ),
              trailing: Text(Apis.donePrizes[index]['score_points'].toString()),
            ),
            //golden cards
            ListTile(
              title: const Text(
                'Golden cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/golden.png'),
                height: mediaQuery.height / 30,
              ),
              trailing: Text(Apis.donePrizes[index]['golden_coin'].toString()),
            ),
            //silver cards
            ListTile(
              title: const Text(
                'Silver cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/silver.png'),
                height: mediaQuery.height / 25,
              ),
              trailing: Text(Apis.donePrizes[index]['silver_coin'].toString()),
            ),
            //bronze cards
            ListTile(
              title: const Text(
                'Bronze cards',
                style: TextStyle(
                    fontFamily: 'Avenir', fontWeight: FontWeight.bold),
              ),
              leading: Image(
                image: const AssetImage('assets/images/bronze.png'),
                height: mediaQuery.height / 30,
              ),
              trailing: Text(Apis.donePrizes[index]['bronze_coin'].toString()),
            ),
          ],
        ),
      ),
    )
        .animate()
        .slide(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutCirc)
        .fadeIn(delay: const Duration(milliseconds: 200));
  }
}
