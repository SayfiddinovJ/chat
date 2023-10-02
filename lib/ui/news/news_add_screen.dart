import 'package:chat/bloc/notification_bloc.dart';
import 'package:chat/bloc/notification_event.dart';
import 'package:chat/bloc/notification_state.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/ui_utils/error_message_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewAddScreen extends StatefulWidget {
  const NewAddScreen({super.key});

  @override
  State<NewAddScreen> createState() => _NewAddScreenState();
}

class _NewAddScreenState extends State<NewAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: BlocBuilder<NotificationBloc, NewsState>(
        buildWhen: (n1, n2) {
          return n1 != n2;
        },
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NewsErrorState) {
            return Center(child: Text(state.errorText));
          }
          if (state is NewsSuccessState) {
            titleController.clear();
            bodyController.clear();
            context.read<NotificationBloc>().add(GetNews());
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(hintText: 'Body'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        bodyController.text.isNotEmpty) {
                      context.read<NotificationBloc>().add(
                            SendNews(
                              newsModel: NewsModel(
                                title: titleController.text,
                                body: bodyController.text,
                                createdAt: DateTime.now().toString(),
                              ),
                              context: context,
                            ),
                          );
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
