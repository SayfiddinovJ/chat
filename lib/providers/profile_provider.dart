import 'package:chat/data/firebase/profile_service.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ProfileProvider({required this.profileService}) {
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
    listenUserChanges();
  }
  bool isLoading = false;
  ProfileService profileService;
  User? currentUser;

  listenUserChanges() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      currentUser = user;
      emailController.text = currentUser?.email ?? '';
      notifyListeners();
    });
  }
  notify(bool v) {
    isLoading = v;
    notifyListeners();
  }

  Future<void> updateEmail(BuildContext context) async {
    String email = emailController.text;
    if (email.isNotEmpty) {
      notify(true);
      UniversalData universalData =
          await profileService.updateuserEmail(email: email);
      notify(false);
      if (universalData.error.isEmpty) {
        if (context.mounted) {
          snackBar(context, universalData.data.toString());
        }
      } else {
        if (context.mounted) {
          snackBar(context, universalData.error);
        }
      }
    }
  }

  Future<void> updatePassword(BuildContext context) async {
    String password = passwordController.text;
    if (password.isNotEmpty) {
      notify(true);
      UniversalData universalData =
          await profileService.updateUserPassword(password: password);
      notify(false);
      if (universalData.error.isEmpty) {
        if (context.mounted) {
          snackBar(context, universalData.data.toString());
        }
      } else {
        if (context.mounted) {
          snackBar(context, universalData.error);
        }
      }
    }
  }

  snackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    isLoading = false;
    notifyListeners();
  }
}
