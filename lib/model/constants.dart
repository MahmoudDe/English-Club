import '../screens/HomePage.dart';
import '../screens/accounts_screen.dart';
import '../screens/all_students_screen.dart';

class Constants {
  static int index = 0;

  static List screens = [
    const HomeScreen(),
    const AllStudentsScreen(),
    const AccountScreen(),
  ];
}
