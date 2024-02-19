// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bdh/screens/english_club_settings_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:bdh/widgets/create_story_screen/add_cover_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../common/snack_bar_widget.dart';

import '../widgets/form_widget copy.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen(
      {super.key,
      required this.levelName,
      required this.subLevelName,
      required this.subLevelId});
  final String subLevelName;
  final String levelName;
  final String subLevelId;

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  File? bookImage;
  File? bookImagePath;
  String storyTitle = '';
  String bookQuantity = '';
  String bookAllowBorrowDays = '';
  String bookQrCode = '';
  String excelFileName = '';
  String message = '';
  File? exclFile;
  bool didSelectFile = false;
  bool isUploading = false;
  final _formKey = GlobalKey<FormState>();

  FocusNode storyTitleNode = FocusNode();
  FocusNode allowBorrowDaysNode = FocusNode();
  FocusNode quantityNode = FocusNode();
  FocusNode qrNode = FocusNode();

  TextEditingController controllerTitle = TextEditingController(text: '');
  TextEditingController controllerQuantity = TextEditingController(text: '');
  TextEditingController controllerBorrowDays = TextEditingController(text: '');
  TextEditingController controllerQrCode = TextEditingController(text: '');

  Future<void> scanQr() async {
    print('----------------------------------');
    String qrResult;
    try {
      qrResult = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print('----------------------------------');
      print(qrResult);
      print('----------------------------------');
    } catch (e) {
      print('----------------------------------');
      qrResult = 'Failed to get platform version';
      print('----------------------------------');
    }
    if (!mounted) return;
    setState(() {
      bookQrCode = qrResult;
    });
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Scan result',
      text: bookQrCode,
      confirmBtnText: 'ok',
      confirmBtnColor: Colors.grey,
    );
  }

  Future<void> openFilePicker() async {
    bool isOk = await Permission.storage.status.isGranted;
    if (!isOk) {
      await Permission.storage.request();
    }
    print('is ok = $isOk');
    print(await Permission.storage.status.isGranted);
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
    if (resultFile != null) {
      setState(() {
        exclFile = File(resultFile.files.single.path!);
        excelFileName = resultFile.names.toString();
        didSelectFile = true;
      });
    }
  }

  Future<void> uploadData() async {
    setState(() {
      isUploading = true;
    });
    try {
      await Provider.of<Apis>(context, listen: false).createBook(
        subLevelId: widget.subLevelId,
        title: storyTitle,
        quantity: bookQuantity,
        allowedBorrowDays: bookAllowBorrowDays,
        qrCode: bookQrCode,
        exclFile: exclFile!,
        bookCover: bookImage!,
      );
      setState(() {
        print(Apis.message);
        message = Apis.message;
      });
      Navigator.pop(context);
      if (Apis.statusResponse != 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: message,
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: message,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnglishClubSettingsScreen(),
                ));
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.main,
        title: const Text(
          'create new story',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: mediaQuery.height / 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 4,
                    vertical: mediaQuery.height / 70,
                  ),
                  child: Text(
                    '${widget.levelName} \\ ${widget.subLevelName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.main,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              AddCoverWidget(
                mediaQuery: mediaQuery,
                pickImageFromCamera: pickImageFromCamera,
                pickImageFromGallery: pickImageFromGallery,
                bookCover: bookImage,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 10,
                    vertical: mediaQuery.height / 90),
                child: FormWidget(
                  controller: controllerTitle,
                  textInputType: TextInputType.text,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Story title',
                  hintText: 'EX: W.ever\'s success story',
                  focusNode: storyTitleNode,
                  nextNode: quantityNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter title for the book';
                    } else if (value.length < 2) {
                      return 'This title is too short';
                    }
                    setState(() {
                      storyTitle = value;
                    });
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.width / 10,
                ),
                child: FormWidget(
                  controller: controllerQuantity,
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: mediaQuery,
                  textInputAction: TextInputAction.next,
                  labelText: 'Quantity',
                  hintText: 'EX: 10',
                  focusNode: quantityNode,
                  nextNode: quantityNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter quantity for the book';
                    }
                    setState(() {
                      bookQuantity = value;
                    });
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.width / 10,
                    vertical: mediaQuery.height / 90),
                child: FormWidget(
                  controller: controllerBorrowDays,
                  textInputType: TextInputType.number,
                  isNormal: true,
                  obscureText: false,
                  togglePasswordVisibility: () {},
                  mediaQuery: mediaQuery,
                  textInputAction: TextInputAction.done,
                  labelText: 'Allow borrow days',
                  hintText: 'EX: 14',
                  focusNode: allowBorrowDaysNode,
                  nextNode: allowBorrowDaysNode,
                  validationFun: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter the days this book is allowed to be borrowed';
                    }
                    setState(() {
                      bookAllowBorrowDays = value;
                    });
                    return null;
                  },
                ),
              ),
              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     ElevatedButton.icon(
              //       onPressed: () {
              //         scanQr();
              //       },
              //       style: ElevatedButton.styleFrom(primary: AppColors.main),
              //       icon: const Icon(
              //         Iconsax.scan,
              //         color: Colors.white,
              //       ),
              //       label: const Text(
              //         'Qr',
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //     Container(
              //       alignment: Alignment.center,
              //       height: mediaQuery.height / 25,
              //       width: mediaQuery.width / 1.5,
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         border: Border.all(color: AppColors.main, width: 2),
              //       ),
              //       child: Text(
              //         bookQrCode.isEmpty ? 'Qr code' : bookQrCode,
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: AppColors.main,
              //         ),
              //       ),
              //     )
              //   ],
              // ),

              SizedBox(
                height: mediaQuery.height / 90,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      openFilePicker();
                    },
                    style: ElevatedButton.styleFrom(primary: AppColors.main),
                    icon: const Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'excel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: mediaQuery.height / 25,
                    width: mediaQuery.width / 1.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.main, width: 2),
                    ),
                    child: Text(
                      didSelectFile ? excelFileName : 'Excel file',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.main,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuery.height / 30,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      // (bookQrCode.isNotEmpty || bookQrCode != '-1') &&
                      didSelectFile) {
                    print('storyTitle => $storyTitle');
                    print('bookQuantity => $bookQuantity');
                    print('bookAllowBorrowDays => $bookAllowBorrowDays');
                    print('bookQrCode => $bookQrCode');
                    print('excelFileName => $excelFileName');
                    uploadData();
                    if (isUploading) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        text: 'Uploading data...',
                        // barrierDismissible: false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBarWidget(
                              title: 'Ops',
                              message:
                                  'you still have to enter or edit data for this story',
                              contentType: ContentType.failure)
                          .getSnakBar());
                  }
                },
                style: ElevatedButton.styleFrom(primary: AppColors.main),
                child: const Text(
                  'Create book',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      bookImage = File(returnedImage.path);
    });
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      bookImage = bookImagePath = File(returnedImage.path);
    });
  }
}
