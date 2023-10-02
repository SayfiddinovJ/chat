import 'package:chat/bloc/notification_event.dart';
import 'package:chat/bloc/notification_state.dart';
import 'package:chat/data/firebase/notif_service.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:chat/data/models/universal_data.dart';
import 'package:chat/data/repository/news_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NewsEvent, NewsState> {
  NotificationBloc({required this.newsRepository}) : super(NewsInitialState()) {
    on<SendNews>(_sendNews);
    on<GetNews>(_getNews);
  }

  final NewsRepository newsRepository;

  Future<void> _sendNews(SendNews event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    UniversalData response =
        await newsRepository.sendNotification(event.newsModel.title, event.newsModel.body,event.context);
    UniversalData data = await NotificationService.sendNotification(newsModel: event.newsModel);
    if (response.error.isEmpty ) {

      emit(NewsSuccessState(news: const [],message: response.data as String));
    } else {
      emit(NewsErrorState(errorText: response.error));
    }
  }

  Future<void> _getNews(GetNews event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    List<NewsModel> newsModelList =
    await newsRepository.getNews();
    if (newsModelList.isNotEmpty) {
      debugPrint('news model list getting: $newsModelList');
      emit(NewsSuccessState(news:newsModelList,message: 'Success'));
    } else {
      emit(NewsErrorState(errorText: 'ERROR'));
    }
  }
}
