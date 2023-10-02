import 'package:chat/data/db/notif_sqflite.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/providers/notification_api_service.dart';
import 'package:flutter/cupertino.dart';

class NewsRepository {
  final NotificationApiService notificationApiService;

  NewsRepository({
    required this.notificationApiService,
  });

  Future<UniversalData> sendNotification(String title, String body,BuildContext context) async =>
      await notificationApiService.sendNotification(title: title, body: body, context: context);

  Future<List<NewsModel>> getNews() async=>
      await NotLocalDatabase.getAllNotifications();
}
