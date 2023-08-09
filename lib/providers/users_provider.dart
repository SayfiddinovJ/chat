import 'package:chat/data/firebase/users_service.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/data/models/user_model.dart';
import 'package:chat/ui/home/home_screen.dart';
import 'package:chat/ui_utils/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  UsersProvider(
    this.usersService,
  );

  final UsersService usersService;

  Future<void> addUser({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await UsersService.addUser(userModel: userModel);
    if (context.mounted) {
      hideLoading(dialogContext: context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
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

  Future<void> updateUser({
    required BuildContext context,
    required UserModel userModel,
  }) async {
    showLoading(context: context);
    UniversalData universalData =
        await UsersService.updateUser(userModel: userModel);
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

  Future<void> deleteUser({
    required BuildContext context,
    required String userId,
  }) async {
    showLoading(context: context);
    UniversalData universalData = await UsersService.deleteUser(userId: userId);
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

  Stream<List<UserModel>> getUser() =>
      FirebaseFirestore.instance.collection("users").snapshots().map(
            (event1) => event1.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList(),
          );

  showMessage(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    notifyListeners();
  }
}
