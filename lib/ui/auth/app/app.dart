import 'package:chat/providers/auth_provider.dart';
import 'package:chat/ui/auth/sign_in/sign_in_page.dart';
import 'package:chat/ui/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: context.read<AuthProvider>().listenAuthState(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.data == null) {
            return const SignInPage();
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}
