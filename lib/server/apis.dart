import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_settings.dart';

class Apis with ChangeNotifier {
  // Add the routes
  static const String loginRoute = 'auth/login';

  Future<bool> login(String? username, String? password) async {
    if (username != null && password != null) {
      try {
        final response = await dio().post(
            loginRoute,
            data: {'username': username, 'password': password});
        if (response.statusCode == 200) {
          print('User logged in!');
          // Save the token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', response.data['token']);
          return true;
        } else {
          print('Failed to log in');
          return false;
        }
      } catch (e) {
        print('connection error: $e');
        return false;
      }
    } else {
      print('Username or password is null');
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

