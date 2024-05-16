import 'package:bdh/server/dio_settings.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  static bool isLoading = false;
  static bool isError = false;
  static List notifications = [];

  Future<void> getAllNotifications({required String page}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      notifications.clear();
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/notifications?page=$page&read=0",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................all notifications server response');
      print(response.data);
      print('................................');
      notifications = response.data['data']['data'];
      isLoading = false;
      isError = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Fine error');
      notifications = [];
      print('The status code is => ${e.response!.statusCode}');
      isLoading = false;
      isError = true;
      notifyListeners();
      print(e);
    } catch (e) {
      notifications = [];
      print('ERRRRRRRRRRRRRRRRRRRROR');
      isLoading = false;
      isError = true;
      notifyListeners();
      print(e);
    }
  }

  Future<void> getAllNotificationsStudent({required String page}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      notifications.clear();
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/student/notifications?page=$page&read=0",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................all notifications server response');
      print(response.data);
      print('................................');
      notifications = response.data['data']['data'];
      isLoading = false;
      isError = false;
      notifyListeners();
    } on DioException catch (e) {
      print('Fine error');
      notifications = [];
      isLoading = false;
      isError = true;
      notifyListeners();
      print(e);
    } catch (e) {
      notifications = [];
      print('ERRRRRRRRRRRRRRRRRRRROR');
      isLoading = false;
      isError = true;
      notifyListeners();
      print(e);
    }
  }
}
