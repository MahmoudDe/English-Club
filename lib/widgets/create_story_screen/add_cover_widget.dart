import 'dart:io';

import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

class AddCoverWidget extends StatelessWidget {
  const AddCoverWidget(
      {super.key,
      required this.mediaQuery,
      required this.pickImageFromCamera,
      required this.pickImageFromGallery,
      this.bookCover});
  final Size mediaQuery;
  final File? bookCover;
  final Function pickImageFromCamera;
  final Function pickImageFromGallery;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: mediaQuery.height / 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 5),
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
                              border: Border.all(color: AppColors.main),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Icon(
                              Icons.camera,
                              color: AppColors.main,
                              size: mediaQuery.height / 15,
                            ),
                          ),
                          Text(
                            'Camera',
                            style: TextStyle(
                                color: AppColors.main,
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
                              border: Border.all(color: AppColors.main),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Icon(
                              Icons.image,
                              color: AppColors.main,
                              size: mediaQuery.height / 15,
                            ),
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(
                                color: AppColors.main,
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
      child: SizedBox(
        // alignment: Alignment.center,
        width: mediaQuery.width / 2,
        height: mediaQuery.height / 3.5,
        child: Card(
          child: bookCover != null
              ? Image.file(
                  bookCover!,
                  fit: BoxFit.contain,
                  // height: mediaQuery.height / 3.5,
                  // width: mediaQuery.width / 2,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline_outlined,
                      color: AppColors.main,
                    ),
                    Text(
                      'Add cover image',
                      style: TextStyle(
                          color: AppColors.main, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
