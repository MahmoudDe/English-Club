import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bdh/controllers/show_book_controller.dart';
import 'package:bdh/notification/notification_services.dart';
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

// import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: 'basic_channel_group_key',
      channelKey: 'myKey',
      channelName: 'alaa_channel',
      channelDescription: 'basic_notification_channel',
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group_key',
        channelGroupName: 'basic group')
  ]);
  bool isNotificationAllowed =
      await AwesomeNotifications().isNotificationAllowed();
  await NotificationServices().initNotification();
  print('isNotificationAllowed => $isNotificationAllowed');
  runApp(Phoenix(child: MyApp()));
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //   if (Platform.isAndroid) {
  //     await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  //   }
  // });
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
            primaryColor: AppColors.main,
            canvasColor: Colors.grey.shade200,
            fontFamily: 'Avenir',
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
