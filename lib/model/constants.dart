import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../screens/HomePage.dart';
import '../screens/admins_accounts_screen.dart';
import '../screens/all_students_screen.dart';

class Constants {
  static int index = 0;

  static List screens = [
    const HomeScreen(),
    const AllStudentsScreen(),
    const AccountScreen(),
  ];

  static List colorsForRoad = [
    AppColors.mainLight,
    Colors.blue,
    Colors.pink,
    Colors.green,
  ];

  static List animations = [
    [
      'assets/lotties/roadCick.json',
      'assets/lotties/roadCick2.json',
    ],
    [
      'assets/lotties/read.json',
      'assets/lotties/read2.json',
    ],
    [
      'assets/lotties/catReading.json',
      'assets/lotties/catReading2.json',
    ],
  ];

  static List<String> wisdoms = [
    'Learning is a journey, not a destination. Embrace the process and be patient with yourself along the way.',
    'Patience is the key to unlocking the treasures of knowledge. Trust in your self become more and more better.',
    'The thing you avoid doing is the thing you don\'t want to do',
    'Get your feet tired, if they get tired you move forward',
    'Whoever asks for honey is not afraid of bee stings',
    'Always strive to understand and learn with an awake mind, not a sleepy one',
    'Like a seed planted in fertile soil, knowledge takes time to grow. Cultivate patience as you nurture your mind.',
    'The journey of a thousand miles begins with a single step. Embrace each step with patience and dedication to learning.',
    'As the stars illuminate the night sky one by one, knowledge reveals itself through patient exploration.',
  ];
}
