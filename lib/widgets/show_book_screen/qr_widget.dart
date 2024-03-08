// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/server/image_url.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../styles/app_colors.dart';

class QrWidget extends StatefulWidget {
  const QrWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  Future<void> _downloadImage() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final qrImage = await QrPainter(
          data: showBookController.bookData['story']['story']['qrCode'],
          version: 4,
          color: Colors.black,
          emptyColor: Colors.white,
        ).toImage(150);

        String filePath =
            '/storage/emulated/0/Download/${showBookController.bookData['story']['story']['title']}.png';
        File file = File(filePath);
        final bytes = await qrImage.toByteData(
          format: ImageByteFormat.png,
        );
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('QR code downloaded successfully!')));
      } catch (error) {
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to download QR code')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Storage permission is required to download QR code')));
    }
  }

  void showDialogFun() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: Container(
            child: PrettyQrView.data(
              data: showBookController.bookData['story']['story']['qrCode'],
              decoration: PrettyQrDecoration(
                image: PrettyQrDecorationImage(
                  image: NetworkImage(
                      '${ImageUrl.imageUrl}${showBookController.bookData['story']['story']['cover_url']}'),
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
