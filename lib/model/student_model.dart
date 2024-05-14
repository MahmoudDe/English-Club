import 'package:bdh/model/user.dart';

class StudentModel {
  int? id;
  String? name;
  int? score;
  int? goldenCoins;
  int? silverCoins;
  int? bronzeCoins;
  int? borrowLimit;
  String? profilePicture;
  List<dynamic>? progress;
  List<dynamic>? testAvailableForStories;
  List<dynamic>? borrowedStories;
  StudentModel(
      {this.borrowLimit,
      this.bronzeCoins,
      this.goldenCoins,
      this.id,
      this.name,
      this.profilePicture,
      this.score,
      this.silverCoins,
      this.progress,
      this.testAvailableForStories,
      this.borrowedStories});
  StudentModel.fromJson({required Map<String, dynamic> json}) {
    progress = json['progresses'];
    id = User.userType != 'student'
        ? json['student']['id']
        : json['user']['owner']['id'];
    name = User.userType != 'student'
        ? json['student']['name']
        : json['user']['owner']['name'];
    score = User.userType != 'student'
        ? json['student']['score']
        : json['user']['owner']['score'];
    goldenCoins = User.userType != 'student'
        ? json['student']['golden_coins']
        : json['user']['owner']['golden_coins'];
    silverCoins = User.userType != 'student'
        ? json['student']['silver_coins']
        : json['user']['owner']['silver_coins'];
    bronzeCoins = User.userType != 'student'
        ? json['student']['bronze_coins']
        : json['user']['owner']['bronze_coins'];
    profilePicture = User.userType != 'student'
        ? json['student']['profile_picture']
        : json['user']['owner']['profile_picture'];
    borrowLimit = User.userType != 'student'
        ? json['student']['borrow_limit']
        : json['user']['owner']['borrow_limit'];
    testAvailableForStories = json['testAvailableForStories'];
    borrowedStories = json['borrowedStories'];
  }
}
