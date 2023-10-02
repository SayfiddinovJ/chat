import 'package:chat/data/models/chat_model.dart';
import 'package:chat/providers/chat_provider.dart';
import 'package:chat/providers/profile_provider.dart';
import 'package:chat/ui/chat/notifications/notifications_screen.dart';
import 'package:chat/ui_utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<ProfileProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ChatProvider>().deleteAll(context: context);
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatModel>>(
              stream: context.read<ChatProvider>().getMessage(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChatModel>> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isNotEmpty
                      ? ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          children: List.generate(
                            snapshot.data!.length,
                            (index) {
                              ChatModel chatModel = snapshot.data![index];
                              return Row(
                                mainAxisAlignment:
                                    chatModel.userName == user!.email
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    child: Text(
                                      chatModel.userName == user.displayName
                                          ? user.displayName![0].capitalize()
                                          : chatModel.userName[0].capitalize(),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: chatModel.userName ==
                                              user.email
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: Radius.circular(15),
                                            )
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                            ),
                                      color: chatModel.userName == user.email
                                          ? Colors.blue
                                          : Colors.yellow,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          chatModel.userName == user.email
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          chatModel.userName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          chatModel.massage,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : const Center(child: Text("Empty!"));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 67.w,
                  child: TextField(
                    controller: context.read<ChatProvider>().messageController,
                    decoration: const InputDecoration(hintText: 'Message'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (context
                        .read<ChatProvider>()
                        .messageController
                        .text
                        .isNotEmpty) {
                      context.read<ChatProvider>().addMessage(
                            context: context,
                            chatModel: ChatModel(
                              chatId: '',
                              userName: user!.email ?? '',
                              massage: context
                                  .read<ChatProvider>()
                                  .messageController
                                  .text,
                              createdAt: DateTime.now().toString(),
                            ),
                          );
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
