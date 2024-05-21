import 'dart:convert';

import 'package:bdh/shared/local_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

////////هي  هبدة شغال الكود بلاها بس بحطا مشان اتأكد انو التطبيق اخد اشعارات  من التيرمينال
Future<void> handelBackgroundMessage(
  RemoteMessage message,
) async {
  print('Title : ${message.notification?.title}');
  print('Body :${message.notification?.body}');
  print('Payload:${message.data}');
  final localNotification = FlutterLocalNotificationsPlugin();

  final notification = message.notification;
  if (notification == null) return;
  await localNotification.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
          android: AndroidNotificationDetails(
        androidchannel.id,
        androidchannel.name,
        channelDescription: androidchannel.description,
        icon: '@drawable/flutter_logo',
        importance: Importance.max,
      )),
      payload: jsonEncode(message.toMap()));

  // NotificationService().showNotification(
  //     body: message.notification!.body,
  //     id: 1,
  //     title: message.notification!.title);
}

final androidchannel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notification',
  importance: Importance.max,
);

class FirebaseApi {
  ///هود عم اخود انتستنس من فاير بيز
  ///
  final firebaseMessaging = FirebaseMessaging.instance;
  // final androidchannel = const AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description: 'This channel is used for important notification',
  //   importance: Importance.max,
  // );
  final localNotification = FlutterLocalNotificationsPlugin();

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
    // FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
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
      firebaseMessaging.subscribeToTopic('test_test');
      //هي النكشن مشان تجبلي التوكين
      String? fcmToken = await firebaseMessaging.getToken();
      FirebaseMessaging.onBackgroundMessage(handelBackgroundMessage);
      FirebaseMessaging.onMessage.listen((message) async {
        final notification = message.notification;
        if (notification == null) return;
        await localNotification.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              androidchannel.id,
              androidchannel.name,
              channelDescription: androidchannel.description,
              icon: '@drawable/flutter_logo',
              importance: Importance.max,
            )),
            payload: jsonEncode(message.toMap()));
      });
      print(fcmToken);
      CashNetwork.insertToCash(key: 'fcm_token', value: fcmToken.toString());
      print('/////////////////');
      print('.................');
      print(CashNetwork.getCashData(key: 'fcm_token'));
      initPushNotification();
    } catch (e) {}
  }

  sendMessage(title, message) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAM989bQo:APA91bHsa3zC-nCXAMfG9pEH5uHnQXDQ6Ej-EkVLwgboRZNA3MSb11LcMq3GYisGVjZaw2_Uq1OUrcpXsdqyVTwKkykhwVg0mwtj4UKoNydoqjltWgh7gVOxyCOrcIz2G7IA5xEoYDPA'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to":
          "f85185xJS8Cj7IcTOkgtel:APA91bEkXHiqrrW7RTP1-frGE8g-jpbk5NJTedEiz1i1YehR8C6FvvwyzUdXRBGhTbT7RgNBeDkIlV529KbI0Nlx2u_M4sNDgZl7MR8OHgwEeliCxpRsgy1M1dSbNmPYwacwcalX-CER",
      "notification": {"title": title, "body": message}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  sendMessageTobic(title, message, topic) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAM989bQo:APA91bHsa3zC-nCXAMfG9pEH5uHnQXDQ6Ej-EkVLwgboRZNA3MSb11LcMq3GYisGVjZaw2_Uq1OUrcpXsdqyVTwKkykhwVg0mwtj4UKoNydoqjltWgh7gVOxyCOrcIz2G7IA5xEoYDPA'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": "/topics/$topic",
      "notification": {"title": title, "body": message}
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
