import 'package:chat/data/db/sqflite.dart';
import 'package:chat/data/firebase/auth_provider.dart';
import 'package:chat/data/firebase/chat_service.dart';
import 'package:chat/data/firebase/profile_service.dart';
import 'package:chat/data/firebase/users_service.dart';
import 'package:chat/providers/auth_provider.dart';
import 'package:chat/providers/chat_provider.dart';
import 'package:chat/providers/db_read_provider.dart';
import 'package:chat/providers/profile_provider.dart';
import 'package:chat/providers/users_provider.dart';
import 'package:chat/service/notifications.dart';
import 'package:chat/ui/auth/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalNotificationService.instance.setupFlutterNotifications();
  LocalDatabase.getInstance;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(firebaseServices: AuthService()),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileProvider(profileService: ProfileService()),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ChatProvider(ChatService()),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => UsersProvider(UsersService()),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ReadProvider(),
          lazy: true,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
        );
      },
    );
  }
}
