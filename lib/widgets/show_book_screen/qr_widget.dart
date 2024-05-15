// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'dart:ui';

import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:screenshot/screenshot.dart';
// import 'package:device_info_plus/device_info_plus.dart';

import '../../styles/app_colors.dart';

class QrWidget extends StatefulWidget {
  const QrWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _downloadImage() async {
    // // Request storage permission
    // final plugin = DeviceInfoPlugin();
    // final android = await plugin.androidInfo;

    // final storageStatus = android.version.sdkInt < 33
    //     ? await Permission.storage.request()
    //     : PermissionStatus.granted;
    try {
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes != null) {
        // Create a temporary file to save the image
        // final tempFile = File(
        //     '/storage/emulated/0/Download/${showBookController.bookData[0]['title']}.png');
        // await tempFile.writeAsBytes(imageBytes);

        // Now use the tempFile for sharing or further processing
        await Share.file(
          "QR Code",
          "${showBookController.bookData[0]['title']}.jpg",
          imageBytes,
          "image/jpg",
          text:
              "Scan this QR code to borrow or return ${showBookController.bookData[0]['title']} book",
        );
      } else {
        print("Error capturing the QR code image.");
      }
    } catch (error) {
      print("Error capturing or sharing QR code: $error");
    }
  }

  void showDialogFun() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: Screenshot(
            controller: _screenshotController,
            child: Container(
              color: Colors.white,
              child: PrettyQrView.data(
                data: showBookController.bookData[0]['qrCode'],
                decoration: PrettyQrDecoration(
                  image: PrettyQrDecorationImage(
                    image: NetworkImage(
                        '${ImageUrl.imageUrl}${showBookController.bookData[0]['cover_url']}'),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: _downloadImage,
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: widget.mediaQuery.width / 30,
      top: widget.mediaQuery.height / 30,
      child: IconButton(
        icon: const Icon(Iconsax.scan),
        color: AppColors.main,
        onPressed: () {
          showDialogFun();
        },
      ),
    );
  }
}
