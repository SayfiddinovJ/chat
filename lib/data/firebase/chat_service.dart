import 'package:chat/data/models/chat_model.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/providers/api_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static Future<UniversalData> addMessage(
      {required ChatModel chatModel}) async {
    try {
      await ApiProvider.sendMessage(
          title: chatModel.userName, body: chatModel.massage);
      DocumentReference newChat = await FirebaseFirestore.instance
          .collection("chat1")
          .add(chatModel.toJson());

      await FirebaseFirestore.instance
          .collection("chat1")
          .doc(newChat.id)
          .update({
        "chatId": newChat.id,
      });

      return UniversalData(data: "Message added!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> updateMessage(
      {required ChatModel chatModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("chat1")
          .doc(chatModel.chatId)
          .update(chatModel.toJson());

      return UniversalData(data: "Message updated!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> deleteMessage({required String chatId}) async {
    try {
      await FirebaseFirestore.instance.collection("chat1").doc(chatId).delete();

      return UniversalData(data: "Message deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }

  static Future<UniversalData> deleteAll() async {
    try {
      await FirebaseFirestore.instance.collection("chat1").get().then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      return UniversalData(data: "Messages deleted!");
    } on FirebaseException catch (e) {
      return UniversalData(error: e.code);
    } catch (error) {
      return UniversalData(error: error.toString());
    }
  }
}
