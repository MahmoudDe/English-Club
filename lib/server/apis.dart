// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:bdh/data/data.dart';
import 'package:bdh/server/dio_settings.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as Dio;

class Apis with ChangeNotifier {
  // Add the routes

  bool isLoggedIn = false;
  static List<dynamic> allAdmins = [];
  static String message = '';
  static int statusResponse = 0;
  static Map<String, dynamic> createAdmin = {};
  static Map<String, dynamic> createStudent = {};
  static Map<String, dynamic> allStudents = {};
  static Map<String, dynamic> allGrades = {};
  static List<dynamic> sectionsData = [];

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
      String? myToken = storage.getString('token');
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
      String? myToken = storage.getString('token');
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
      String? myToken = storage.getString('token');
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
      statusResponse = response.statusCode!;
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
      String? myToken = storage.getString('token');
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
      statusResponse = response.statusCode!;
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

  Future<void> getAllStudents() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/students",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................all students server response');
      print(response.data);
      print('................................');
      allStudents = response.data;
      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllStudentsWithFilter(
      String start_date, String end_date) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/students",
        data: {
          'start_date': start_date,
          'end_date': end_date,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................all students with filter server response');
      print(response.data);
      print('................................');
      allStudents = response.data;
      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllGrades() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/grades",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................all grades server response');
      print(response.data);
      print('................................');
      allGrades = response.data;
      dataClass.customList.clear();
      dataClass.grades.clear();
      dataClass.gradesName.clear();
      dataClass.sections.clear();
      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllGrades1() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/grades",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................all grades server response');
      print(response.data);
      print('................................');
      allGrades = response.data;

      notifyListeners();
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadData(File exclFile, int gradeId) async {
    print(exclFile.path);

    final SharedPreferences storage = await SharedPreferences.getInstance();
    var tempDir = await getApplicationDocumentsDirectory();
    String fullPath = "${tempDir.path}/response2.xlsx";
    print('full path $fullPath');
    try {
      String? myToken = await storage.getString('token');
      String fileName = exclFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromFileSync(
          exclFile.path,
          filename: fileName,
        ),
        "grade_id": gradeId,
      });
      Dio.Response response = await dio().post(
        "/admin/students/importFromExcel",
        data: formData,
        onReceiveProgress: showDownloadProgress,
        options: Dio.Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $myToken'},
          validateStatus: (status) {
            return status! < 300;
          },
        ),
      );
      print(
          '............................................ excil file status code');
      print(response.statusCode);
      print(response.data);
      // final directory = await getDownloadsDirectory();
      String filePath = '/storage/emulated/0/Download/StudentsAccounts.xlsx';
      File file = File(filePath);
      await file.writeAsBytes(response.data);
      print('File downloaded to: $filePath');
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = e.response!.statusCode!;
      print('................................error upload data info');
      message = json.decode(String.fromCharCodes(e.response!.data!))['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future<void> deleteStudent(String id) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().delete(
        "/admin/students/$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete student server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      getAllStudents();
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllSections() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/sections",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................get all sections server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      sectionsData = response.data['data'];
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createStudentAccount({
    required String name,
    required int g_class_id,
    required String score,
    required String golden_coins,
    required String silver_coins,
    required String bronze_coins,
    required List progresses,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/students",
        data: {
          "name": name,
          "g_class_id": g_class_id,
          "score": score,
          "golden_coins": golden_coins,
          "silver_coins": silver_coins,
          "bronze_coins": bronze_coins,
          "progresses": progresses
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................create student server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      createStudent = response.data['data']['account'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNewGrade({
    required String name,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/grades",
        data: {
          "name": name,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................add grade server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNewClass({
    required String name,
    required String grade_id,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/classes",
        data: {
          "name": name,
          "grade_id": grade_id,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................add class server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteGrade({
    required String grade_id,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().delete(
        "/admin/grades/$grade_id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete grade server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteClass({
    required String class_Id,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().delete(
        "/admin/classes/$class_Id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete class server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> editGrade(
      {required String grade_id, required String newName}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/grades/$grade_id",
        data: {"name": newName},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................edit grade server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> editClass({
    required String class_Id,
    required String grade_id,
    required String newName,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/classes/$class_Id",
        data: {
          "name": newName,
          "grade_id": grade_id,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................edit class server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
    } on DioError catch (e) {
      statusResponse = 400;
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
