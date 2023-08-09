import 'package:chat/data/models/universal_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static Future<UniversalData> sendNotification(
      {required String title, required String body}) async {
    Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    try {
      http.Response response = await http.post(
        uri,
        headers: {
          'content-type': 'application/json',
          "Authorization":
              "key=AAAAHsLEZWw:APA91bEyhd31rcvj8jJqMEzosnqVmJx7V-qRZQMb6Cz0rOFccE3AClSGIWoRqpo6hKcmSWUIjNX3-4jmwsSlp7G8QeLGdBUCvyGflQqBYEUE31AeEfqdX19JNchtGjAj4SBwhRh9Emoa"
        },
        body: """{
          "to":"/topics/chat",
          "notification":{
            "title":"Flutter N8",
            "body":"How are you ?"
          },
          "data":{
            "body": "$body",
            "custom_field":"Best",
            "title":"$title",
            "createdAt":"${DateTime.now().toString()}"
          }
        }""",
      );
      debugPrint('------------${response.body}-------------');
      if (response.statusCode == 200) {
        debugPrint('------------Notification 200-------------');
        return UniversalData(
          data: 'Message sent successfully',
        );
      }
    } catch (error) {
      debugPrint('------------$error-------------');
      UniversalData(error: "ERROR");
    }
    debugPrint('------------Notification ERROR-------------');
    return UniversalData(error: "RETURN ERROR");
  }
}
