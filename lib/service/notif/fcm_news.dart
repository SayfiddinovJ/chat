import 'package:chat/data/db/notif_sqflite.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/providers/db_read_provider.dart';
import 'package:chat/service/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Future<void> initFirebaseNews(BuildContext context) async {
  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM USER TOKEN: $fcmToken");
  // await FirebaseMessaging.instance.subscribeToTopic("news");

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FOREGROUND MESSAGE HANDLING.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint(
        "NOTIFICATION FOREGROUND MODE: ${message.data["data"]} va ${message.notification!.title} in foreground");
    LocalNotificationService.instance.showFlutterNotification(message);
    NotLocalDatabase.insertNotification(
      NewsModel(
        title: message.data['title'],
        body: message.data['body'],
        createdAt: message.data['createdAt'],
      ),
    );
    if (context.mounted) context.read<ReadProvider>().readMessages();
  });

  // BACkGROUND MESSAGE HANDLING
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandlerNews);

  // FROM TERMINATED MODE

  handleMessage(RemoteMessage message) {
    debugPrint(
        "NOTIFICATION FROM TERMINATED MODE: ${message.data["title"]} va ${message.notification!.title} in terminated");
    LocalNotificationService.instance.showFlutterNotification(message);
  }

  RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (remoteMessage != null) {
    handleMessage(remoteMessage);
    NotLocalDatabase.insertNotification(
      NewsModel(
        title: remoteMessage.data['title'],
        body: remoteMessage.data['body'],
        createdAt: remoteMessage.data['createdAt'],
      ),
    );

    if (context.mounted) context.read<ReadProvider>().readMessages();
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

Future<void> _firebaseMessagingBackgroundHandlerNews(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotLocalDatabase.insertNotification(
    NewsModel(
      title: message.data['title'],
      body: message.data['body'],
      createdAt: message.data['createdAt'],
    ),
  );
  debugPrint(
      "NOTIFICATION BACKGROUND MODE: ${message.data["title"]} va ${message.notification!.title} in background");
}
