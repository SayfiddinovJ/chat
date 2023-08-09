import 'package:chat/ui/chat/chat_screen.dart';
import 'package:chat/ui/profile/profile_screen.dart';
import 'package:chat/ui/users/users_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool like = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            icon: const Icon(Icons.person_2_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()));
            },
            icon: const Icon(Icons.people),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            title: const Text(
              'Chat',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()));
            },
          ),
        ],
      ),
    );
  }
}
