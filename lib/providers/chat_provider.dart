import 'package:chat/data/firebase/chat_service.dart';
import 'package:chat/data/models/chat_model.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/ui_utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider(
    this.chatService,
  );

  final ChatService chatService;

  TextEditingController messageController = TextEditingController();

  clean() {
    messageController.clear();
  }

  Future<void> addMessage({
    required BuildContext context,
    required ChatModel chatModel,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await ChatService.addMessage(chatModel: chatModel);
    if (context.mounted) {
      hideLoading(dialogContext: context);
      clean();
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Future<void> updateMessage({
    required BuildContext context,
    required ChatModel chatModel,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await ChatService.updateMessage(chatModel: chatModel);
    if (context.mounted) {
      hideLoading(dialogContext: context);
      clean();
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Future<void> deleteMessage({
    required BuildContext context,
    required String chatId,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await ChatService.deleteMessage(chatId: chatId);
    if (context.mounted) {
      hideLoading(dialogContext: context);
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Future<void> deleteAll({required BuildContext context}) async {
    showLoading(context: context);
    UniversalData universalData = await ChatService.deleteAll();
    if (context.mounted) {
      hideLoading(dialogContext: context);
    }
    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showMessage(context, universalData.data as String);
      }
    } else {
      if (context.mounted) {
        showMessage(context, universalData.error);
      }
    }
  }

  Stream<List<ChatModel>> getMessage() => FirebaseFirestore.instance
      .collection("chat1")
      .orderBy('createdAt')
      .snapshots()
      .map(
        (event1) =>
            event1.docs.map((doc) => ChatModel.fromJson(doc.data())).toList(),
      );

  showMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    notifyListeners();
  }
}
