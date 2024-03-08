import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../styles/app_colors.dart';

class BookCoverWidget extends StatefulWidget {
  const BookCoverWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<BookCoverWidget> createState() => _BookCoverWidgetState();
}

class _BookCoverWidgetState extends State<BookCoverWidget> {
  @override
  void initState() {
    print(showBookController.bookData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<showBookController>(
      builder: (context, value, child) => GestureDetector(
        onTap: (() {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: widget.mediaQuery.height / 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.mediaQuery.width / 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Provider.of<showBookController>(context,
                                  listen: false)
                              .pickImageFromCamera();
                          if (showBookController.isUploading) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.loading,
                              text: 'Uploading data...',
                              // barrierDismissible: false,
                            );
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(widget.mediaQuery.height / 80),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.main),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Icon(
                                Icons.camera,
                                color: AppColors.main,
                                size: widget.mediaQuery.height / 15,
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
                          Provider.of<showBookController>(context,
                                  listen: false)
                              .pickImageFromGallery();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.all(widget.mediaQuery.height / 80),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.main),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Icon(
                                Icons.image,
                                color: AppColors.main,
                                size: widget.mediaQuery.height / 15,
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
        }),
        child: Container(
          margin: EdgeInsets.only(left: widget.mediaQuery.width / 40),
          alignment: Alignment.center,
          height: widget.mediaQuery.height / 3.5,
          width: widget.mediaQuery.width / 2,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
            color: Colors.white,
            border: Border.all(color: Colors.amber, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: showBookController.bookData[0]['cover_url'] != null
              ? ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  child: Image(
                    image: NetworkImage(
                      '${ImageUrl.imageUrl}${showBookController.bookData[0]['cover_url']}',
                    ),
                    fit: BoxFit.cover,
                    height: widget.mediaQuery.height / 3.5,
                    // alignment: Alignment.topCenter,
                  ),
                )
              : const Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.amber,
                    ),
                    Text(
                      'Add a cover',
                      style: TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold),
                    )
                  ],
                )),
        ),
      ),
    );
  }
}
