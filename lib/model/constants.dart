import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/SearchPage.dart';
import 'package:bdh/screens/BorrowPage.dart';

class Constants {
  // ignore: non_constant_identifier_names
  static bool DidSelectLanguage = false;
  static int index = 0;
  static List secreens = [
    HomeScreen(),
    SearchScreen(),
    BorrowScreen(),
  ];
}
