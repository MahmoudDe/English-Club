import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_settings.dart';

class Apis with ChangeNotifier {
  // Add the routes
  bool isLoggedIn = false;
  static List<dynamic> allAdmins = [];
  static String message = '';
  static Map<String, dynamic> createAdmin = {};

  Future<bool> login(String? username, String? password) async {
    try {
      final response = await dio().post('auth/login',
          data: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        String token = response.data['data']['token'];
        print(token);
        String type = response.data['data']['type'];
        storToken(token: token, type: type);
        print('User logged in!');
        print('-----------------------------------login response');
        print(response.data);
        print('------------------------------------------------');
      }
      return true;
    } on DioException catch (a) {
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
      isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> storToken({
    required String token,
    required String type,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    print('-------------------------------$token');
    print('-------------------------------$type');
    await storage.setString('token', token);
    await storage.setString('type', type);
  }

  Future<void> logout() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/auth/logout",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................logout server response');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllAdmins() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/admins/",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      allAdmins = response.data;
      notifyListeners();
      print(allAdmins);
      print('................................get all admins server response');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAdmin(String id) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().delete(
        "/admin/admins/$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................get all admins server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      getAllAdmins();
      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNewAdmin(String adminName) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/admins/",
        data: {'name': adminName},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................create admin server response');
      print(response.data);
      print('................................');
      createAdmin = response.data;
      getAllAdmins();
      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
