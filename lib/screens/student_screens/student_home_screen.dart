// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:bdh/model/user.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/server/image_url.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/student_home_screen/book_widget.dart';
import 'package:bdh/widgets/student_home_screen/borrowed_book_widget%20copy.dart';
import 'package:bdh/widgets/student_home_screen/card_widget.dart';
import 'package:bdh/widgets/student_home_screen/student_image_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class StudentHomeScreen extends StatefulWidget {
  StudentHomeScreen({
    super.key,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  final pageController = PageController();
  bool isLoading = false;
  File? studentImage;
  File? studentImagePath;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (await Provider.of<Apis>(context, listen: false).studentHomeScreen()) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: 0.5,
              child: Image(
                image: const AssetImage('assets/images/backRoad.png'),
                height: mediaQuery.height,
                width: mediaQuery.width,
                fit: BoxFit.fill,
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.main,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: mediaQuery.height / 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              print(Apis.studentModel!.profilePicture);
                              print('Upload image');

                              User.userType != 'student'
                                  ? null
                                  : updateStudentImage(context, mediaQuery);
                            },
                            child: StudentImageWidget(mediaQuery: mediaQuery)),
                        SizedBox(
                          height: mediaQuery.width / 50,
                        ),
                        Text(
                          Apis.studentModel!.name!,
                          style: TextStyle(
                              color: AppColors.main,
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.width / 20),
                        ),
                        SizedBox(
                          height: mediaQuery.height / 40,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width / 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CardWidget(
                                  color: Colors.brown,
                                  icon: 'assets/images/bronze.png',
                                  data:
                                      Apis.studentModel!.bronzeCoins.toString(),
                                  mediaQuery: mediaQuery),
                              CardWidget(
                                  color: Colors.grey,
                                  icon: 'assets/images/silver.png',
                                  data:
                                      Apis.studentModel!.silverCoins.toString(),
                                  mediaQuery: mediaQuery),
                              CardWidget(
                                  color: Colors.amber,
                                  icon: 'assets/images/golden.png',
                                  data:
                                      Apis.studentModel!.goldenCoins.toString(),
                                  mediaQuery: mediaQuery),
                            ],
                          ),
                        ),
                        Apis.studentModel!.testAvailableForStories!.isEmpty &&
                                Apis.studentModel!.borrowedStories!.isEmpty
                            ? SizedBox(
                                height: mediaQuery.height / 20,
                              )
                            : SizedBox(
                                height: mediaQuery.height / 100,
                              ),
                        Apis.studentModel!.testAvailableForStories!.isEmpty &&
                                Apis.studentModel!.borrowedStories!.isEmpty
                            ? const Text('You don\'t have any activities yet')
                            : const SizedBox(),
                        Apis.studentModel!.testAvailableForStories!.isEmpty
                            ? const SizedBox()
                            : Container(
                                width: mediaQuery.width / 1.1,
                                height: mediaQuery.height / 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.main,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    )),
                                child: const Text(
                                  'Available stories tests',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        Apis.studentModel!.testAvailableForStories!.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: mediaQuery.height / 90,
                              ),
                        Apis.studentModel!.testAvailableForStories!.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: mediaQuery.height / 2.5,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Apis.studentModel!
                                      .testAvailableForStories!.length,
                                  itemBuilder: (context, index) {
                                    return BookWidget(
                                      index2: index,
                                      mediaQuery: mediaQuery,
                                    );
                                  },
                                ),
                              ),
                        Apis.studentModel!.borrowedStories!.isEmpty
                            ? const SizedBox()
                            : Container(
                                width: mediaQuery.width / 1.1,
                                height: mediaQuery.height / 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.main,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    )),
                                child: const Text(
                                  'Borrowed stories',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                        Apis.studentModel!.borrowedStories!.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: mediaQuery.height / 90,
                              ),
                        Apis.studentModel!.borrowedStories!.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: mediaQuery.height / 2.5,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: Apis.studentModel!
                                      .testAvailableForStories!.length,
                                  itemBuilder: (context, index) {
                                    return BorrowedBookWidget(
                                      index2: index,
                                      mediaQuery: mediaQuery,
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
          ],
        ));
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    studentImage = File(returnedImage.path);
    print('step2 .....> the student id is ${Apis.studentModel!.id.toString()}');
    if (await Provider.of<Apis>(context, listen: false).changeStudentImage(
      studentImage: studentImage!,
      DeleteImage: '0',
      studentId: '-1',
    )) {
      Navigator.pop(context);
      Phoenix.rebirth(context);
    } else {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: Apis.message,
      );
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;

    studentImage = studentImagePath = File(returnedImage.path);
    if (await Provider.of<Apis>(context, listen: false).changeStudentImage(
      studentImage: studentImage!,
      DeleteImage: '0',
      studentId: '-1',
    )) {
      Navigator.pop(context);
      Phoenix.rebirth(context);
    } else {
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: Apis.message,
      );
    }
  }

  void updateStudentImage(BuildContext context, Size mediaQuery) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Image(
                        image: NetworkImage(
                            '${ImageUrl.imageUrl}${Apis.studentModel!.profilePicture}')),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (context1) {
                            return SizedBox(
                              height: mediaQuery.height / 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.width / 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        pickImageFromCamera();
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                                mediaQuery.height / 80),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.main),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                            padding: EdgeInsets.all(
                                                mediaQuery.height / 80),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColors.main),
                                              borderRadius:
                                                  const BorderRadius.all(
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
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 10,
                          vertical: mediaQuery.height / 60,
                        ),
                        child: const Text(
                          'Update your image',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 60,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Navigator.pop(context);/
                        if (await Provider.of<Apis>(context, listen: false)
                            .deleteStudentImage(
                          DeleteImage: '1',
                          studentId: '-1',
                        )) {
                          Navigator.pop(context);
                          Phoenix.rebirth(context);
                        } else {
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            text: Apis.message,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 10,
                          vertical: mediaQuery.height / 60,
                        ),
                        child: const Text(
                          'delete your image',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 60,
                    ),
                  ],
                ),
              ),
            ));
  }
}
