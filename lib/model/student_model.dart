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
    id = json['user']['owner']['id'];
    name = json['user']['owner']['name'];
    score = json['user']['owner']['score'];
    goldenCoins = json['user']['owner']['golden_coins'];
    silverCoins = json['user']['owner']['silver_coins'];
    bronzeCoins = json['user']['owner']['bronze_coins'];
    profilePicture = json['user']['owner']['profile_picture'];
    borrowLimit = json['user']['owner']['borrow_limit'];
    testAvailableForStories = json['testAvailableForStories'];
    borrowedStories = json['borrowedStories'];
  }
}
