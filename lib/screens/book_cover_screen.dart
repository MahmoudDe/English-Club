import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../server/apis.dart';
import '../server/image_url.dart';

class BookCoverScreen extends StatelessWidget {
  const BookCoverScreen(
      {super.key, required this.index2, required this.screenColor});
  final int index2;
  final Color screenColor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
              height: mediaQuery.height,
              width: mediaQuery.width,
              foregroundDecoration:
                  Apis.subLevelBooksList[index2]['status'] == ''
                      ? const BoxDecoration(
                          color: Colors.grey,
                          backgroundBlendMode: BlendMode.saturation,
                        )
                      : const BoxDecoration(),
              child: Apis.subLevelBooksList[index2]['cover_url'] != null
                  ? Image(
                      image: NetworkImage(
                        '${ImageUrl.imageUrl}${Apis.subLevelBooksList[index2]['cover_url']}',
                      ),
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/images/bookCover.jpg'),
                      fit: BoxFit.cover,
                    )),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black54,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Apis.subLevelBooksList[index2]['title'],
                style: TextStyle(
                  fontSize: mediaQuery.width / 15,
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Apis.subLevelBooksList[index2]['status'] == 'success'
                  ? ListTile(
                      title: const Text(
                        'Mark',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        Apis.subLevelBooksList[index2]['mark'].toString(),
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
              ListTile(
                title: const Text(
                  'Story status',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  Apis.subLevelBooksList[index2]['status'] == ''
                      ? 'Locked'
                      : Apis.subLevelBooksList[index2]['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Fails count',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  Apis.subLevelBooksList[index2]['failsCount'].toString(),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Allow borrow days',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  Apis.subLevelBooksList[index2]['allowed_borrow_days']
                      .toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Quiz questions count',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  Apis.subLevelBooksList[index2]['subQuestions_count']
                      .toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: mediaQuery.height / 18,
                width: mediaQuery.width,
                alignment: Alignment.center,
                foregroundDecoration:
                    Apis.subLevelBooksList[index2]['status'] == ''
                        ? const BoxDecoration(
                            color: Colors.grey,
                            backgroundBlendMode: BlendMode.saturation,
                          )
                        : const BoxDecoration(),
                decoration: BoxDecoration(
                  color: Apis.subLevelBooksList[index2]['status'] == 'borrowed'
                      ? screenColor
                      : Apis.subLevelBooksList[index2]['status'] == 'success'
                          ? Colors.greenAccent
                          : Colors.amber,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Apis.subLevelBooksList[index2]['status'] == 'success'
                              ? Colors.greenAccent.withOpacity(0.6)
                              : Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Apis.subLevelBooksList[index2]['status'] == ''
                    ? const Icon(
                        Iconsax.lock5,
                        color: Colors.white,
                      )
                    : Apis.subLevelBooksList[index2]['status'] == 'success'
                        ? Text(
                            '${Apis.subLevelBooksList[index2]['status']}: ${Apis.subLevelBooksList[index2]['mark']}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            Apis.subLevelBooksList[index2]['status'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
