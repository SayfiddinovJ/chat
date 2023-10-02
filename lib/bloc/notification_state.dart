import 'package:chat/data/models/news_model.dart';
import 'package:equatable/equatable.dart';

abstract class NewsState extends Equatable {}

class NewsInitialState extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoadingState extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsSuccessState extends NewsState {
  NewsSuccessState({required this.message, required this.news});

  final List<NewsModel> news;
  final String message;

  @override
  List<Object?> get props => [news];
}

class NewsErrorState extends NewsState {
  NewsErrorState({required this.errorText});

  final String errorText;

  @override
  List<Object?> get props => [errorText];
}
