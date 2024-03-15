// ignore_for_file: avoid_print, deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/data/data.dart';
import 'package:bdh/server/dio_settings.dart';
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
  static Map<String, dynamic> sectionInfo = {};
  static Map<String, dynamic> levelData = {};
  static Map<String, dynamic> stroyData = {};

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
      print('................................delete admin server response');
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

  Future<void> getSectionInfo({
    required String sectionId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/sections/$sectionId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................section info by id server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      sectionInfo = response.data['data'];
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

  Future<void> activeStudent(
      {required String studentId, required String activeState}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/students/$studentId/inActive",
        data: {
          'inactive': activeState,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................inActive student server response');
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

  Future<void> createNewSection({required String sectionName}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/sections",
        data: {
          'name': sectionName,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................create new section server response');
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

  Future<void> updateSection(
      {required String sectionId, required String sectionName}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/sections/$sectionId",
        data: {
          'name': sectionName,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................update section server response');
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

  Future<void> createSupLevel(
      {required String levelId, required String supLevelName}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/sections/levels/$levelId/subLevels",
        data: {
          'name': supLevelName,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................create supLevel server response');
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

  Future<void> deleteSubLevel(
      {required String levelId, required String supLevelId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().delete(
        "/admin/sections/levels/$levelId/subLevels/$supLevelId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete subLevel server response');
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

  Future<void> upDateSubLevel(
      {required String levelId,
      required String newSubLevelName,
      required String newLevelId,
      required subLevelId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/sections/levels/$levelId/subLevels/$subLevelId",
        data: {
          'name': newSubLevelName,
          'level_id': newLevelId,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................update subLevel server response');
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

  Future<bool> createBook({
    required String subLevelId,
    required String title,
    required String subQuestions,
    required String quantity,
    required String allowedBorrowDays,
    required String qrCode,
    required File exclFile,
    required File bookCover,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      String fileName = exclFile.path.split('/').last;
      String fileName1 = bookCover.path.split('/').last;
      FormData formData = FormData.fromMap({
        'title': title,
        'test_subQuestions_count': subQuestions,
        'allowed_borrow_days': allowedBorrowDays,
        'quantity': quantity,
        "cover_image": MultipartFile.fromFileSync(
          bookCover.path,
          filename: fileName1,
        ),
        "file": MultipartFile.fromFileSync(
          exclFile.path,
          filename: fileName,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/sections/levels/subLevels/$subLevelId/stories",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................create level server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data['errors'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createLevel({
    required String sectionId,
    required String test_subQuestions_count,
    required String name,
    required String good_percentage,
    required String veryGood_percentage,
    required String excellent_percentage,
    required List prizes,
    required String vocab_g_percentage,
    required String vocab_vg_percentage,
    required String vocab_exc_percentage,
    required List vocabPrizes,
    required File file,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        'name': name,
        'test_subQuestions_count': test_subQuestions_count,
        'good_percentage': good_percentage,
        'veryGood_percentage': veryGood_percentage,
        'excellent_percentage': excellent_percentage,
        'prizes': prizes,
        'vocab_g_percentage': vocab_g_percentage,
        'vocab_vg_percentage': vocab_vg_percentage,
        'vocab_exc_percentage': vocab_exc_percentage,
        'vocabPrizes': vocabPrizes,
        "file": MultipartFile.fromFileSync(
          file.path,
          filename: fileName,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/sections/$sectionId/levels",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................create level server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data['errors'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteLevel({
    required String sectionId,
    required String levelId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/sections/$sectionId/levels/$levelId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete level server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data['message'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteSection({
    required String sectionId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/sections/$sectionId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete section server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data);
      message = e.response!.data['message'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> makeSectionReady({
    required String sectionId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().put(
        "/admin/sections/$sectionId/makeReady",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................make section ready server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data);
      message = e.response!.data['message'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getLevelData(
      {required String sectionId, required String levelId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/sections/$sectionId/levels/$levelId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................get level data server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      levelData = response.data['data'];
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data);
      message = e.response!.data['message'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateLevelControlP({
    required String sectionId,
    required String levelId,
    required String good_percentage,
    required String veryGood_percentage,
    required String excellent_percentage,
    required List prizes,
    required String vocab_g_percentage,
    required String vocab_vg_percentage,
    required String vocab_exc_percentage,
    required List vocabPrizes,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/sections/$sectionId/levels/$levelId/controlPanel",
        data: {
          'good_percentage': good_percentage,
          'veryGood_percentage': veryGood_percentage,
          'excellent_percentage': excellent_percentage,
          'prizes': prizes,
          'vocab_g_percentage': vocab_g_percentage,
          'vocab_vg_percentage': vocab_vg_percentage,
          'vocab_exc_percentage': vocab_exc_percentage,
          'vocabPrizes': vocabPrizes,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................update level controlP server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data['errors'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateLevel({
    required String sectionId,
    required String levelId,
    required String name,
    required String test_subQuestions_count,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().put(
        "/admin/sections/$sectionId/levels/$levelId",
        data: {
          'name': name,
          'test_subQuestions_count': test_subQuestions_count,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................update level controlP server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data['errors'].toString();
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getStoriesSublevel({
    required String storyId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/admin/story/$storyId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );

      showBookController.bookData = response.data['story'];
      print(
          '................................story in subLevel data server response');
      print(showBookController.bookData);
      print('................................');
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateStoryCover(
      {required String storyId,
      required String subLevelId,
      required File bookCover}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = bookCover.path.split('/').last;
      FormData formData = FormData.fromMap({
        "cover_image": MultipartFile.fromFileSync(
          bookCover.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/sections/levels/subLevels/$subLevelId/stories/$storyId/updateCoverImage",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................update book cober data server response');
      print(response.data);
      print('................................');
      showBookController.bookData = response.data['story'];
      showBookController.message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteStory({
    required String storyId,
    required String subLevelId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/sections/levels/subLevels/$subLevelId/stories/$storyId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................delete story server response');
      print(response.data);
      print('................................');
      showBookController.message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return false;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateStory({
    required String storyId,
    required String subLevelId,
    required String title,
    required String test_subQuestions_count,
    required String allowed_borrow_days,
    required String quantity,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().patch(
        "/admin/sections/levels/subLevels/$subLevelId/stories/$storyId",
        data: {
          'title': title,
          'test_subQuestions_count': test_subQuestions_count,
          'allowed_borrow_days': allowed_borrow_days,
          'quantity': quantity,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................update story server response');
      print(response.data);
      print('................................');
      showBookController.message = response.data['message'];
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getAdminQuiz({
    required String quizId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/tests/$quizId/adminView",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      // print('................................quiz admin server response');
      // print(response.data);
      // print('................................');
      QuizController.numberOfQuestions =
          response.data['data']['subQuestions_count'];
      QuizController.test.clear();
      QuizController.questions.clear();
      QuizController.test = response.data['data']['test_sections'];
      for (int i = 0; i < QuizController.test.length; i++) {
        for (int j = 0; j < QuizController.test[i]['questions'].length; j++) {
          QuizController.questions.add({
            'data': QuizController.test[i]['questions'][j],
            'main_text_url': QuizController.test[i]['text_url'],
            'main_is_image': QuizController.test[i]['is_image'],
            'main_id': QuizController.test[i]['id'],
          });
        }
      }
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeMainQuestionToText(
      {required String mainQuestionId,
      required String quizId,
      required String newText}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/$quizId/sections/$mainQuestionId/turnIntoText",
        data: {'text': newText},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change main question to text server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeMainQuestionToImage({
    required String mainQuestionId,
    required String quizId,
    required File questionImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = questionImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          questionImage.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/tests/$quizId/sections/$mainQuestionId/turnIntoImage",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change main question to image server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteMainQuestion({
    required String mainQuestionId,
    required String quizId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/tests/$quizId/sections/$mainQuestionId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................delete main question to image server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeCurrentQuestionToText(
      {required String currentQuestionId,
      required String mainQuestionId,
      required String quizId,
      required String newText}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/sections/$mainQuestionId/questions/$currentQuestionId/turnIntoText",
        data: {'text': newText},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change current question to text server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> changeCurrentQuestionToImage({
    required String mainQuestionId,
    required String currentQuestionId,
    required String quizId,
    required File questionImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = questionImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          questionImage.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/tests/sections/$mainQuestionId/questions/$currentQuestionId/turnIntoImage",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change current question to image server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCurrentQuestion({
    required String mainQuestionId,
    required String currentQuestionId,
    required String quizId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/tests/sections/$mainQuestionId/questions/$currentQuestionId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................delete current question to image server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateCurrentQuestion(
      {required String mainQuestionId,
      required String currentQuestionId,
      required String quizId,
      required String allOrNothing,
      required String mark}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().put(
        "/admin/tests/sections/$mainQuestionId/questions/$currentQuestionId",
        data: {'allOrNothing': allOrNothing, 'mark': mark},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................update current question to image server response');
      print(response.data);
      print('................................');
      getAdminQuiz(quizId: quizId);
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      showBookController.message = e.response!.data['message'];
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
