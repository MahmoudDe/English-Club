// ignore_for_file: avoid_print, deprecated_member_use, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:bdh/controllers/quiz_controller.dart';
import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/data/data.dart';
import 'package:bdh/model/user.dart';
import 'package:bdh/server/dio_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:dio/dio.dart';

import '../model/student_model.dart';

class Apis with ChangeNotifier {
  // Add the routes

  bool isLoggedIn = false;
  static List<dynamic> allAdmins = [];
  static String message = '';
  static int statusResponse = 0;
  static StudentModel? studentModel;
  static Map<String, dynamic> createAdmin = {};
  static Map<String, dynamic> createStudent = {};
  static Map<String, dynamic> allStudents = {};
  static Map<String, dynamic> allGrades = {};
  static List<dynamic> sectionsData = [];
  static List<dynamic> studentRoadMap = [];
  static Map<String, dynamic> sectionInfo = {};
  static Map<String, dynamic> levelData = {};
  static Map<String, dynamic> stroyData = {};
  static List subLevelBooksList = [];
  static List doneTasks = [];
  static List waitingTasks = [];
  static List donePrizes = [];
  static List waitingPrizes = [];
  Future<bool> login(String? username, String? password) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? fcmToken = storage.getString('fcm_token');
      final response = await dio().post('auth/login', data: {
        'username': username,
        'password': password,
        'fcm_token': fcmToken
      });
      if (response.statusCode == 200) {
        String token = response.data['data']['token'];
        print(token);
        String type = response.data['data']['type'];
        User.userType = type;
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

  Future<bool> logout() async {
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
      return true;
    } on DioError catch (e) {
      print(e.response!.data['message']);
      return false;
    } catch (e) {
      print(e);
      return false;
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
        "/admin/admins",
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

  Future<bool> getAllStudents() async {
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
      return true;
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
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
        "/student/sections",
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

  Future<void> getAllSectionsForStudent({required String id}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      Dio.Response response = await dio().get(
        "/student/sections?student_id=$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................get all student sections server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
      statusResponse = 200;
      studentRoadMap.clear();
      studentRoadMap = response.data['data'];
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
    required String borrowLimit,
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
          "borrow_limit": borrowLimit,
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
          'active': activeState,
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
      message = e.response!.data.toString();
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
      print('++++++++++++++++++++++++++++++++++++++++++++++++');
      print(sectionId);
      print({
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
      print('The status code is => ${e.response!.statusCode}');
      print(e.error);
      print(e.response);
      print(e.response!.data['message']);
      message = e.response!.data.toString();
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
      print('The token is => $myToken');
      print('the section id is => $sectionId');
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
      showBookController.message = e.response!.data.toString();
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

  Future<bool> getStudentVocabTest(
      {required String sectionId, required String levelId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/student/getVocaTestOf/section/$sectionId/level/$levelId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student story test server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      QuizController.numberOfQuestions =
          response.data['data']['testSections'].length;
      QuizController.test.clear();
      QuizController.questions.clear();
      QuizController.studentAnswer.clear();
      QuizController.test = response.data['data']['testSections'];
      print(' THE MAIN LENGTH = ${QuizController.test.length}');
      for (int i = 0; i < QuizController.test.length; i++) {
        QuizController.studentAnswer.insert(i, {
          "testSection_id": QuizController.test[i]['id'].toString(),
          "questions": []
        });
        for (int j = 0;
            j < QuizController.test[i]['selected_questions'].length;
            j++) {
          QuizController.questions.add({
            'data': QuizController.test[i]['selected_questions'][j],
            'main_text_url': QuizController.test[i]['text_url'],
            'main_is_image': QuizController.test[i]['is_image'],
            'main_id': QuizController.test[i]['id'],
          });
          QuizController.studentAnswer[i]['questions'].insert(j, {
            'id': QuizController.test[i]['selected_questions'][j]['id']
                .toString(),
            'pickedAnswers': []
          });
        }
      }
      isError = false;
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
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

  Future<bool> addNewTextAnswer({
    required String currentQuestionId,
    required String quizId,
    required String is_correct,
    required String is_image,
    required String text,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/sections/questions/$currentQuestionId/answers",
        data: {'is_image': is_image, 'text': text, 'is_correct': is_correct},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................add new text answer server response');
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

  Future<bool> addNewImageAnswer({
    required String currentQuestionId,
    required String quizId,
    required String is_image,
    required String is_correct,
    required File answerImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = answerImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        'is_image': is_image,
        'is_correct': is_correct,
        "image": MultipartFile.fromFileSync(
          answerImage.path,
          filename: fileName1,
        ),
      });

      Dio.Response response = await dio().post(
        "/admin/tests/sections/questions/$currentQuestionId/answers",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................add new image answer server response');
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

  Future<bool> changeAnswerToText(
      {required String answerId,
      required String currentQuestionId,
      required String quizId,
      required String is_correct,
      required String newText}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/sections/questions/$currentQuestionId/answers/$answerId/turnIntoText",
        data: {'text': newText, 'is_correct': is_correct},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change answer to text server response');
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

  Future<bool> changeAnswerToImage({
    required String answerId,
    required String currentQuestionId,
    required String quizId,
    required String is_correct,
    required File answerImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = answerImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "is_correct": is_correct,
        "image": MultipartFile.fromFileSync(
          answerImage.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/admin/tests/sections/questions/$currentQuestionId/answers/$answerId/turnIntoImage",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change answer to image server response');
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

  Future<bool> deleteAnswer({
    required String currentQuestionId,
    required String answerId,
    required String quizId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().delete(
        "/admin/tests/sections/questions/$currentQuestionId/answers/$answerId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................delete answer to image server response');
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

  Future<void> changeQuestion({
    required File exclFile,
    required String testId,
    required String deletePreviousQuestions,
  }) async {
    print(exclFile.path);

    final SharedPreferences storage = await SharedPreferences.getInstance();
    var tempDir = await getApplicationDocumentsDirectory();
    String fullPath = "${tempDir.path}/response2.xlsx";
    print('full path $fullPath');
    try {
      String? myToken = await storage.getString('token');
      String fileName = exclFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "test_id": testId,
        "file": MultipartFile.fromFileSync(
          exclFile.path,
          filename: fileName,
        ),
        "deletePreviousQuestions?": deletePreviousQuestions,
      });
      Dio.Response response = await dio().post(
        "/admin/tests/$testId/importQuestionsFromExcel",
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
      message = json.decode(String.fromCharCodes(e.response!.data!)).toString();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> changeAdminImage({
    required String studentId,
    required File studentImage,
    required String DeleteImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = studentImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "onlyDelete?": '0',
        "image": MultipartFile.fromFileSync(
          studentImage.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/student/changeProfilePicture/$studentId",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change student image server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      print('we are going to show this');
      if (await getAllStudents()) {
        return true;
      }
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

  Future<bool> changeStudentImage({
    required String studentId,
    required File studentImage,
    required String DeleteImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');
      String fileName1 = studentImage.path.split('/').last;
      FormData formData = FormData.fromMap({
        "onlyDelete?": '0',
        "image": MultipartFile.fromFileSync(
          studentImage.path,
          filename: fileName1,
        ),
      });
      Dio.Response response = await dio().post(
        "/student/changeProfilePicture/$studentId",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change student image server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      print('we are going to show this');

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

  Future<bool> deleteAdminImage({
    required String studentId,
    required String DeleteImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/student/changeProfilePicture/$studentId",
        data: {
          'onlyDelete?': DeleteImage,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................delete student image server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      print('we are going to show this');
      if (await getAllStudents()) {
        print('step 3 update student data');
        notifyListeners();
        return true;
      } else {
        return false;
      }
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

  Future<bool> deleteStudentImage({
    required String studentId,
    required String DeleteImage,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/student/changeProfilePicture/$studentId",
        data: {
          'onlyDelete?': DeleteImage,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................delete student image server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      print('we are going to show this');

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

  Future<bool> updateStudentData({
    required String studentId,
    required String studentName,
    required String borrowLimit,
    required int g_class_id,
  }) async {
    print('Starting');
    print('The student id is => $studentId');
    print('The class id => ${g_class_id}');
    final SharedPreferences storage = await SharedPreferences.getInstance();
    print('step 1');
    try {
      String? myToken = storage.getString('token');
      print('step 2');
      print(myToken);
      Dio.Response response = await dio().patch(
        "admin/students/$studentId",
        data: {
          'name': studentName,
          'g_class_id': g_class_id,
          'borrow_limit': borrowLimit,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................change student image server response');
      print(response.data);
      print('................................');
      message = response.data['message'];
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

  Future<bool> borrowBook({
    required String studentId,
    required String qrCode,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/progress/$studentId/borrow",
        data: {
          'qrCode': qrCode,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student Borrow Book server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      message = response.data.toString();
      showBookController.message = response.data.toString();
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

  Future<bool> returnBook({
    required String studentId,
    required String qrCode,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/progress/$studentId/return",
        data: {
          'qrCode': qrCode,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student return Book server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      message = response.data.toString();
      showBookController.message = response.data.toString();
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

  Future<bool> storiesInSubLevel({
    required String subLevelId,
    required String studentId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    print('3====================================');
    print(studentId);
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/student/sections/levels/subLevels/$subLevelId/stories?student_id=$studentId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................subLevels Books server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      subLevelBooksList = response.data['data'];
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      subLevelBooksList = [];
      notifyListeners();
      return false;
    } catch (e) {
      subLevelBooksList = [];
      print(e);
      return false;
    }
  }

  Future<bool> endStoryCycle(
      {required String mark,
      required String date,
      required String studentId,
      required String storyId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    print('3====================================');
    print(studentId);
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "admin/student/$studentId/story/$storyId/finish_cycle",
        data: {
          'mark': mark,
          'date': date,
        },
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................subLevels Books server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      message = await e.response!.data['message'];
      // subLevelBooksList = [];
      notifyListeners();
      return false;
    } catch (e) {
      // subLevelBooksList = [];
      message = await 'Exception error';

      print(e);
      return false;
    }
  }

  Future<bool> unlockVocabTest({
    required String levelId,
    required String studentId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/sections/levels/$levelId/removeVocabLockForStudent/$studentId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................unlock vocab test server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      notifyListeners();
      return true;
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

  Future<bool> lockVocabTest({
    required String levelId,
    required String studentId,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/tests/sections/levels/$levelId/lockVocabForStudent/$studentId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................lock vocab test server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      notifyListeners();
      return true;
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

  Future<bool> collectedPrize({required String page}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    donePrizes.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/viewPrizes?collected=1&page=$page",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................collectd pirze list server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      donePrizes = response.data['data']['data'];
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      donePrizes = [];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      donePrizes = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> unCollectedPrize({
    required int page,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    waitingPrizes.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/viewPrizes?collected=0",
        queryParameters: {'page': page},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................uncollected prize list server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      waitingPrizes = await response.data['data']['data'];
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      waitingPrizes = [];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      waitingPrizes = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> toDoList({required String page}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    doneTasks.clear();
    waitingTasks.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/todoNotifications?page=$page",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................to do list server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      doneTasks = response.data['data']['done']['data'];
      waitingTasks = response.data['data']['waiting'];
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      doneTasks = [];
      waitingTasks = [];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      doneTasks = [];
      waitingTasks = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> makeTaskDone(
      {required String taskId, required String page}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().patch(
        "/admin/todoNotifications/$taskId/makeDone",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................make task done server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      toDoList(page: page);
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> allPrizes() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    donePrizes.clear();
    waitingPrizes.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/admin/viewPrizes",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................all prizes server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      donePrizes = response.data['data']['collected'];
      waitingPrizes = response.data['data']['unColleted'];
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      donePrizes = [];
      waitingPrizes = [];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      doneTasks = [];
      waitingTasks = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> givePrize(
      {required String studentId, required String prizeId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/students/$studentId/collectedPrize/$prizeId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................give prize server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      allPrizes();
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      donePrizes = [];
      waitingPrizes = [];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      doneTasks = [];
      waitingTasks = [];
      notifyListeners();
      return false;
    }
  }

  Future<bool> studentHomeScreen({required String id}) async {
    print('The id is $id');
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');
      studentModel = StudentModel(
        borrowLimit: 0,
        borrowedStories: [],
        bronzeCoins: 0,
        goldenCoins: 0,
        name: '',
        profilePicture: '',
        score: 0,
        progress: [],
        silverCoins: 0,
        testAvailableForStories: [],
      );
      Dio.Response response = await dio().get(
        User.userType == 'student'
            ? "/student/HomeScreen"
            : "/student/HomeScreen?student_id=$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student home screen server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      studentModel = StudentModel.fromJson(json: response.data['data']);
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  static bool isError = false;

  Future<bool> studentStoryTest(
      {required String subLevelId, required String storyID}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().get(
        "/student/getTestOf/sublevel/$subLevelId/Story/$storyID",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student story test server response');
      print(response.data);
      print('................................');
      statusResponse = 200;
      QuizController.numberOfQuestions =
          response.data['data']['testSections'].length;
      QuizController.test.clear();
      QuizController.questions.clear();
      QuizController.studentAnswer.clear();
      QuizController.test = response.data['data']['testSections'];
      print(' THE MAIN LENGTH = ${QuizController.test.length}');
      for (int i = 0; i < QuizController.test.length; i++) {
        QuizController.studentAnswer.insert(i, {
          "testSection_id": QuizController.test[i]['id'].toString(),
          "questions": []
        });
        for (int j = 0;
            j < QuizController.test[i]['selected_questions'].length;
            j++) {
          QuizController.questions.add({
            'data': QuizController.test[i]['selected_questions'][j],
            'main_text_url': QuizController.test[i]['text_url'],
            'main_is_image': QuizController.test[i]['is_image'],
            'main_id': QuizController.test[i]['id'],
          });
          QuizController.studentAnswer[i]['questions'].insert(j, {
            'id': QuizController.test[i]['selected_questions'][j]['id']
                .toString(),
            'pickedAnswers': []
          });
        }
      }
      isError = false;
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      message = e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  static Map<String, dynamic> studentResultBookTest = {};
  Future<bool> studentSubmitTest(
      {required String subLevelId,
      required String storyID,
      required List<dynamic> answers}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    studentResultBookTest.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/student/submitSolutionOf/sublevel/$subLevelId/Story/$storyID",
        data: json.encode(answers),
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student submit test server response');
      print(response.data);
      print('................................');
      studentResultBookTest = response.data['data'];
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.statusCode);
      message = e.response!.data['errorDetail'] != null
          ? e.response!.data['errorDetail'].toString()
          : e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> studentSubmitTestLevel(
      {required String levelId,
      required String sectionId,
      required List<dynamic> answers}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    studentResultBookTest.clear();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/student/submitSolutionOf/section/$sectionId/level/$levelId",
        data: json.encode(answers),
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print(
          '................................student submit test server response');
      print(response.data);
      print('................................');
      studentResultBookTest = response.data['data'];
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.statusCode);
      message = e.response!.data['errorDetail'] != null
          ? e.response!.data['errorDetail'].toString()
          : e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> convertStudentToExcel({
    required List students,
    required BuildContext context,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = storage.getString('token');

      Dio.Response response = await dio().post(
        "/admin/export-student",
        data: json.encode({'student': students}),
        onReceiveProgress: showDownloadProgress,
        options: Dio.Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $myToken'},
          validateStatus: (status) {
            return status! < 300;
          },
        ),
      );
      print('................................convert student to excel');
      print(response.data);
      print(response.statusCode);
      print('................................');
      Navigator.pop(context);
      print('Save file');
      String filePath = '/storage/emulated/0/Download/studentsExcel.xlsx';
      File file = File(filePath);
      await file.writeAsBytes(response.data);
      print('File downloaded to: $filePath');
      statusResponse = 200;
      notifyListeners();
      return true;
    } on DioError catch (e) {
      print('hello');
      statusResponse = 400;
      print(e.error);
      print(e.response);
      print(e.response!.statusCode);
      message = e.response!.data['errorDetail'] != null
          ? e.response!.data['errorDetail'].toString()
          : e.response!.data['message'];
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }
}
