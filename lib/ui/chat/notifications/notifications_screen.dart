import 'package:chat/data/models/db_model.dart';
import 'package:chat/providers/db_read_provider.dart';
import 'package:chat/service/fcm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    initFirebase(context);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('NOTIFICATION LENGTH: ${context.watch<ReadProvider>().messages.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ReadProvider>().deleteAll();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: context.watch<ReadProvider>().messages.isEmpty
          ? const Center(
              child: Text('None'),
            )
          : ListView(
              children: [
                ...List.generate(context.watch<ReadProvider>().messages.length,
                    (index) {
                  DBModelSql model =
                      context.watch<ReadProvider>().messages[index];
                  return ListTile(
                    onTap: (){
                      context.read<ReadProvider>().deleteMessage(model.id!);
                    },
                    title: Text(model.name),
                    subtitle: Text(model.message),
                  );
                })
              ],
            ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('AppLifecycleState inactive');
        break;
      case AppLifecycleState.resumed:
        debugPrint('AppLifecycleState resumed');
        context.read<ReadProvider>().readMessages();
        break;
      case AppLifecycleState.paused:
        debugPrint('AppLifecycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('AppLifecycleState detached');
        break;
    }
  }
}
