// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bdh/controllers/show_book_controller.dart';
// import 'package:bdh/notification/notification_services.dart';
import 'package:bdh/screens/HomePage.dart';
import 'package:bdh/screens/navigation_screen.dart';
import 'package:bdh/screens/splashscreen.dart';
import 'package:bdh/screens/start_screen.dart';
import 'package:bdh/server/apis.dart';
import 'package:bdh/server/home_provider.dart';
import 'package:bdh/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_core/firebase_core.dart';

import 'notification/notification.dart';
import 'shared/local_network.dart';

// import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashNetwork.cashInitialization();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCpqL7hvVLTCa1Nh12eM0q_J2pCP1LHEpo',
      appId: '1:838693518963:android:d947e652bdbf6c3f3eb406',
      messagingSenderId: '838693518963',
      projectId: 'flutter-1cda7',
    ),
  );
  await FirebaseApi().initNotification();

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Apis(),
        ),
        ChangeNotifierProvider.value(
          value: showBookController(),
        ),
        ChangeNotifierProvider.value(
          value: HomeProvider(),
        ),
      ],
      child: Consumer<Apis>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
            canvasColor: Colors.grey.shade200,
            fontFamily: 'Avenir',
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white)),
            tabBarTheme: TabBarTheme(
              labelColor: AppColors.main,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.main,
              ), // color for text
              // overlayColor: ,
              indicator: UnderlineTabIndicator(
                // color for indicator (underline)
                borderSide: BorderSide(
                  color: AppColors.main,
                ),
              ),
            ),
          ),
          home: const SplashScreen(),
          routes: {
            '/home': (context) => HomeScreen(),
            NavigationScreen.routeName: (context) => const NavigationScreen(),
            StartScreen.routName: (context) => const StartScreen()
          },
        ),
      ),
    );
  }
}
