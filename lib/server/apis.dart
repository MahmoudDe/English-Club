import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_settings.dart';

class Apis with ChangeNotifier {
  // Add the routes
  static bool isValid = false;

  Future<bool> login(String? username, String? password) async {
    try {
      final response = await dio().post('auth/login',
          data: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        isValid = true;
        notifyListeners();
        print('User logged in!');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        return true;
      } else {
        print('Failed to log in');
        isValid = false;
        notifyListeners();
        return false;
      }
    } on DioException catch (a) {
      isValid = false;
      notifyListeners();
      print('nice error');
      print(a.error);
      print(a);
      print(a.requestOptions);
      print(a.message);
      print(a.response);
      return false;
    } catch (e) {
      print('connection error: $e');
      isValid = false;
      notifyListeners();
      return false;
    }
  }

//remove token when logout
  Future<void> logout() async {
    try {
      final response = await dio().post('auth/logout');
      if (response.statusCode == 200) {
        print('User logged out!');
        // Remove the token from shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
      } else {
        print('Failed to log out');
      }
    } catch (e) {
      print('connection error: $e');
    }
  }
}
