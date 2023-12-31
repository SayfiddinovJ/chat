import 'package:chat/data/db/sqflite.dart';
import 'package:chat/data/models/db_model.dart';
import 'package:chat/providers/db_read_provider.dart';
import 'package:chat/service/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Future<void> initFirebase(BuildContext context) async {
  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM USER TOKEN: $fcmToken");
  // await FirebaseMessaging.instance.subscribeToTopic("news");

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FOREGROUND MESSAGE HANDLING.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint(
        "NOTIFICATION FOREGROUND MODE: ${message.data["news_image"]} va ${message.notification!.title} in foreground");
    LocalNotificationService.instance.showFlutterNotification(message);
    LocalDatabase.insertMessage(DBModelSql(name: message.notification!.title!, message: message.notification!.body!, createdAt: DateTime.now().toString()));
    if (context.mounted) context.read<ReadProvider>().readMessages();
  });

  // BACkGROUND MESSAGE HANDLING
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FROM TERMINATED MODE

  handleMessage(RemoteMessage message) {
    debugPrint(
        "NOTIFICATION FROM TERMINATED MODE: ${message.data["news_image"]} va ${message.notification!.title} in terminated");
    LocalNotificationService.instance.showFlutterNotification(message);
  }

  RemoteMessage? remoteMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  if (remoteMessage != null) {
    handleMessage(remoteMessage);
    LocalDatabase.insertMessage(DBModelSql(name: remoteMessage.notification!.title!, message: remoteMessage.notification!.body!, createdAt: DateTime.now().toString()));

    if (context.mounted) context.read<ReadProvider>().readMessages();
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalDatabase.insertMessage(DBModelSql(name: message.notification!.title!, message: message.notification!.body!, createdAt: DateTime.now().toString()));
  debugPrint(
      "NOTIFICATION BACKGROUND MODE: ${message.data["news_image"]} va ${message.notification!.title} in background");
}