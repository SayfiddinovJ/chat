import 'package:chat/bloc/notification_bloc.dart';
import 'package:chat/bloc/notification_state.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/ui/news/news_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewAddScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: BlocBuilder<NotificationBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NewsErrorState) {
            return Center(child: Text(state.errorText));
          }
          if (state is NewsSuccessState) {
            return state.news.isEmpty
                ? const Center(child: Text('EMPTY!!!'))
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ...List.generate(
                        state.news.length,
                        (index) {
                          NewsModel newsModel = state.news[index];
                          return ListTile(
                            title: Text(newsModel.title),
                          );
                        },
                      ),
                    ],
                  );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
