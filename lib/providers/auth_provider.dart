import 'package:chat/data/firebase/auth_provider.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/data/models/user_model.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/ui/auth/sign_in/sign_in_page.dart';
import 'package:chat/ui/home/home_screen.dart';
import 'package:chat/ui_utils/error_message_dialog.dart';
import 'package:chat/ui_utils/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({required this.firebaseServices});

  final AuthService firebaseServices;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  bool obscureText = true;
  bool obscureText1 = true;
  User? user = FirebaseAuth.instance.currentUser;

  clearTextFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  Stream<User?> listenAuthState() => FirebaseAuth.instance.authStateChanges();

  Future<void> createUser(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      showLoading(context: context);

      if (password == passwordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (context.mounted) {
          showErrorMessage(
              message: "User created successfully! ", context: context);
        }
        if (context.mounted) {
          hideLoading(dialogContext: context);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInPage(),
              ),
              (route) => false);
        }
        clearTextFields();
      } else {
        showErrorMessage(
            message: "Ikkala password ham bir hil bo'lishi kerak! ",
            context: context);
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(message: e.code.toString(), context: context);
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (error) {
      showErrorMessage(message: error.toString(), context: context);
    }
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      showLoading(context: context);

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        context.read<UsersProvider>().addUser(
            context: context,
            userModel: UserModel(
                userId: '',
                userName: email,
                createdAt: DateTime.now().toString()));
        hideLoading(dialogContext: context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
        showConfirmMessage(
            message: "logged in successfully! ", context: context);
        clearTextFields();
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(message: e.code.toString(), context: context);
    } catch (error) {
      showErrorMessage(message: error.toString(), context: context);
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      showLoading(context: context);

      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        hideLoading(dialogContext: context);

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(message: e.code.toString(), context: context);
    } catch (error) {
      showErrorMessage(message: error.toString(), context: context);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showLoading(context: context);
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      if (context.mounted) {
        context.read<UsersProvider>().addUser(
            context: context,
            userModel: UserModel(
                userId: '',
                userName: googleUser!.displayName ?? googleUser.email,
                createdAt: DateTime.now().toString()));
        hideLoading(dialogContext: context);
        hideLoading(dialogContext: context);
        showConfirmMessage(
            message: "logged in successfully! ", context: context);
        clearTextFields();
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(message: e.code.toString(), context: context);
      hideLoading(dialogContext: context);
    } catch (error) {
      showErrorMessage(message: error.toString(), context: context);
      hideLoading(dialogContext: context);
    }
  }

  Future<void> signInWithGoogle1(BuildContext context) async {
    showLoading(context: context);
    UniversalData universalData = await firebaseServices.signInWithGoogle();

    if (context.mounted) {
      hideLoading(dialogContext: context);
    }

    if (universalData.error.isEmpty) {
      if (context.mounted) {
        showConfirmMessage(
            message: "User Signed Up with Google.", context: context);
      }
    } else {
      if (context.mounted) {
        showErrorMessage(message: universalData.error, context: context);
      }
    }
  }

  obs1() {
    obscureText = !obscureText;
    notifyListeners();
  }

  obs2() {
    obscureText1 = !obscureText1;
    notifyListeners();
  }
}
