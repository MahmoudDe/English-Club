// import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

////////هي  هبدة شغال الكود بلاها بس بحطا مشان اتأكد انو التطبيق اخد اشعارات  من التيرمينال
Future<void> handelBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('Body :${message.notification?.body}');
  print('Payload:${message.data}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notification',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

class FirebaseApi {
  ///هود عم اخود انتستنس من فاير بيز
  ///
  final firebaseMessaging = FirebaseMessaging.instance;
  // final channel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description: 'This channel is used for important notification',
  //   importance: Importance.max,
  // );

//هي الفانكشن مشان يستوعب الفاير بيز وين بدو ينتقل وقت امبس عل النوتيفميشن
  // void handleMessage(RemoteMessage? message) {
  //   if (message == null) return;
  //   navigatorKey.currentState
  //       ?.pushNamed(NotificationScreen.route, arguments: message);
  // }

  ///هي الفانكشن مشان هندل النوتيفكيشن وقت اكبس عليها
  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    // FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
    FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
  }

//هي الفنكشن هية المسئولة عن استلام الداتا من فاير بيز مشان تتهندل عندي وقت كون طافي التطبيق
  Future<void> initNotification() async {
    try {
      //هي الفنكشن مشان يطلب مني البيرمشن
      await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      firebaseMessaging.subscribeToTopic('user');
      //هي النكشن مشان تجبلي التوكين
      String? fcmToken = await firebaseMessaging.getToken();
      FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);

      print('The fcm token =>$fcmToken');
      // CashNetwork.insertToCash(key: 'fcm_token', value: fcmToken.toString());
      print('/////////////////');
      print('.................');
      // print(CashNetwork.getCashData(key: 'fcm_token'));
      initPushNotification();
    } catch (e) {}
  }

  // sendMessage(title, message) async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authentication':
  //         'AAAAw0YHfnM:APA91bGxEYYZNs8Gtlk23RgIfKDQ9COIkluBeVO6C91XvPykNcP-RUCC3ZqvAvqfT-RrZjHrn2wZnI3MtAxi2nIhzZ3GCeWDll-hCjW_MKB8pZKqBh5f8dRb6xOrchJuwHMhpszT9kWa'
  //   };
  //   var request =
  //       http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  //   request.body = json.encode({
  //     "to":
  //         "dxNkAi0OQ6yCSU5AQ0kq5R:APA91bEuF4nRHhnUhkWkBCgmrMKOyRj9i0i3Dj81HbyXu09GcPqjYTayErrFNdiqBXKRhbGqOHKsRsZ8pCnkEli0wuGPA3EQykNOgGkW5iC97lxGKfZvYXC5OaHh5QoPyAVnBkseeJFt",
  //     "notification": {"title": title, "body": message}
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  // sendMessageTobic(title, message, topic) async {
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'key=AAAAM989bQo:APA91bHsa3zC-nCXAMfG9pEH5uHnQXDQ6Ej-EkVLwgboRZNA3MSb11LcMq3GYisGVjZaw2_Uq1OUrcpXsdqyVTwKkykhwVg0mwtj4UKoNydoqjltWgh7gVOxyCOrcIz2G7IA5xEoYDPA'
  //   };
  //   var request =
  //       http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
  //   request.body = json.encode({
  //     "to": "/topics/$topic",
  //     "notification": {"title": title, "body": message}
  //   });
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     print(await response.stream.bytesToString());
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }
}
