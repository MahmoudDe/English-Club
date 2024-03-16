// ignore_for_file: use_build_context_synchronously, camel_case_types

import 'dart:io';

import 'package:bdh/server/apis.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class showBookController with ChangeNotifier {
  static String subLevelId = '';
  static String subLevelName = '';
  static String bookId = '';
  static bool isLoading = true;
  static bool isUploading = true;
  static late BuildContext context;
  static List<dynamic> bookData = [];
  static File? bookImage;
  static File? bookImagePath;
  static String message = '';

  Future<void> getData() async {
    isLoading = true;
    try {
      await Provider.of<Apis>(context, listen: false)
          .getStoriesSublevel(storyId: bookId);
      isLoading = false;
      isUploading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    bookImage = File(returnedImage.path);
    isUploading = true;
    notifyListeners();
    try {
      await Provider.of<Apis>(context, listen: false).updateStoryCover(
          storyId: bookId, subLevelId: subLevelId, bookCover: bookImage!);
      Navigator.pop(context);
      getData();
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
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    bookImage = bookImagePath = File(returnedImage.path);
    isUploading = true;
    notifyListeners();
    try {
      await Provider.of<Apis>(context, listen: false).updateStoryCover(
          storyId: bookId, subLevelId: subLevelId, bookCover: bookImage!);
      Navigator.pop(context);
      getData();
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
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteStory() async {
    try {
      await Provider.of<Apis>(context, listen: false)
          .deleteStory(storyId: bookId, subLevelId: subLevelId);
      if (Apis.statusResponse != 200) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
