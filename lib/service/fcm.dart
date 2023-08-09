import 'package:chat/data/db/sqflite.dart';
import 'package:chat/data/models/db_model.dart';
import 'package:chat/providers/db_read_provider.dart';
import 'package:chat/service/notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> initFirebase(BuildContext context) async {
  await Firebase.initializeApp();
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('FCM TOKEN - $fcmToken');
  await FirebaseMessaging.instance.subscribeToTopic('chat');

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // FOREGROUND MESSAGE HANDLING
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    debugPrint(
        'Notification FOREGROUND - ${remoteMessage.data['body']} and ${remoteMessage.data['title']}');
    LocalDatabase.insertTodo(
      DBModelSql(
        name: remoteMessage.data['title'],
        message: remoteMessage.data['body'],
        createdAt: DateTime.now().toString(),
      ),
    );

    context.read<ReadProvider>().readMessages();
  });

  // BACKGROUND MESSAGE HANDLING
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FROM TERMINATED MODE

  handleMessage(RemoteMessage message) {
    debugPrint(
        'Notification TERMINATED MODE - ${message.data['custom_field']} and ${message.notification!.title}');
  }

  RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  if (remoteMessage != null) {
    handleMessage(remoteMessage);
    LocalDatabase.insertTodo(
      DBModelSql(
        name: remoteMessage.data['title'],
        message: remoteMessage.data['body'],
        createdAt: DateTime.now().toString(),
      ),
    );

    if (context.mounted) context.read<ReadProvider>().readMessages();
  }

  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.instance.showFlutterNotification(message);
  LocalDatabase.insertTodo(
    DBModelSql(
      name: message.data['title'],
      message: message.data['body'],
      createdAt: DateTime.now().toString(),
    ),
  );
  debugPrint(
      'Notification FOREGROUND - ${message.data['custom_field']} and ${message.notification!.title}');
}
