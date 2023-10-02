import 'package:chat/data/models/chat_model.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static Future<UniversalData> sendNotification(
      {required NewsModel newsModel}) async {
    try {
      await NotificationService.sendNotification(newsModel: newsModel);
      DocumentReference newNotification = await FirebaseFirestore.instance
          .collection("notification")
          .add(newsModel.toJson());

      await FirebaseFirestore.instance
          .collection("notification")
          .doc(newNotification.id)
          .update({
        "id": newNotification.id,
      });

      return UniversalData(data: "Notification added!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> updateNotification(
      {required ChatModel chatModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("notification")
          .doc(chatModel.chatId)
          .update(chatModel.toJson());

      return UniversalData(data: "Notification updated!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> deleteNotification({required String chatId}) async {
    try {
      await FirebaseFirestore.instance.collection("notification").doc(chatId).delete();

      return UniversalData(data: "Notification deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> deleteAll() async {
    try {
      await FirebaseFirestore.instance
          .collection("notification")
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      return UniversalData(data: "Notification deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}
