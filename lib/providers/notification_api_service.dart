import 'package:chat/data/models/universal_data.dart';
import 'package:chat/ui_utils/error_message_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationApiService {
  // DIO SETTINGS

  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fcm.googleapis.com',
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAHsLEZWw:APA91bEyhd31rcvj8jJqMEzosnqVmJx7V-qRZQMb6Cz0rOFccE3AClSGIWoRqpo6hKcmSWUIjNX3-4jmwsSlp7G8QeLGdBUCvyGflQqBYEUE31AeEfqdX19JNchtGjAj4SBwhRh9Emoa"
      },
    ),
  );

  NotificationApiService() {
    _init();
  }

  _init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          debugPrint("ERROR: ${error.message} and ${error.response}");
          return handler.next(error);
        },
        onRequest: (requestOptions, handler) async {
          debugPrint("On Request: ${requestOptions.path}");
          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          debugPrint("On Response :${response.requestOptions.path}");
          return handler.next(response);
        },
      ),
    );
  }

  Future<UniversalData> sendNotification({
    required String title,
    required String body,
    required BuildContext context,
  }) async {
    Response response;
    try {
      response = await _dio.post(
        '/fcm/send',
        data: {
          "to": "/topics/chat",
          "notification": {"title": title, "body": body},
          "data": {
            "body": body,
            "custom_field": 'custom',
            "title": title,
            "createdAt": DateTime.now().toString()
          }
        },
      );

      if ((response.statusCode! >= 200) && (response.statusCode! < 300)) {
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('News send successfully'),
            ),
          );
        }
        return UniversalData(data: 'News send successfully');
      }
      return UniversalData(error: "Other Error");
    } on DioException catch (e) {
      return UniversalData(error: e.toString());
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}
