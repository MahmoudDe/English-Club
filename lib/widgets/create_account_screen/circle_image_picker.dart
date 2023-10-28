import 'dart:io';

import 'package:flutter/material.dart';

class CircleImagePicker extends StatelessWidget {
  const CircleImagePicker(
      {super.key,
      required this.mediaQuery,
      required this.userImage,
      required this.pickImageFromCamera,
      required this.pickImageFromGallery});
  final Size mediaQuery;
  final File? userImage;
  final Function pickImageFromCamera;
  final Function pickImageFromGallery;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQuery.width / 3,
      height: mediaQuery.height / 4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: mediaQuery.width / 80),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: mediaQuery.height / 5,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width / 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          pickImageFromCamera();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(mediaQuery.height / 80),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 42, 24, 73)),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Icon(
                                Icons.camera,
                                color: const Color.fromARGB(255, 42, 24, 73),
                                size: mediaQuery.height / 15,
                              ),
                            ),
                            const Text(
                              'Camera',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 42, 24, 73),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pickImageFromGallery();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(mediaQuery.height / 80),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 42, 24, 73)),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Icon(
                                Icons.image,
                                color: const Color.fromARGB(255, 42, 24, 73),
                                size: mediaQuery.height / 15,
                              ),
                            ),
                            const Text(
                              'Gallery',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 42, 24, 73),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: userImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.file(
                  userImage!,
                  fit: BoxFit.fill,
                  height: mediaQuery.height / 7,
                  width: mediaQuery.width / 2,
                ),
              )
            : Icon(
                Icons.person,
                color: Colors.white,
                size: mediaQuery.height / 15,
              ),
      ),
    );
  }
}
