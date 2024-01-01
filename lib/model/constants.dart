import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/SearchPage.dart';
import 'package:bdh/screens/BorrowPage.dart';
import 'package:bdh/screens/accounts_screen.dart';

class Constants {
  // ignore: non_constant_identifier_names
  static bool DidSelectLanguage = false;
  static int index = 0;
  static List screens = [
    const HomeScreen(),
    const SearchScreen(),
    BorrowScreen(),
    const AccountScreen(),
  ];
}
