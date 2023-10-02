import 'package:chat/data/models/news_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NewsEvent extends Equatable {}

class SendNews extends NewsEvent {
  SendNews({required this.newsModel, required this.context});

  final BuildContext context;
  final NewsModel newsModel;

  @override
  List<Object?> get props => [newsModel, context];
}

class GetNews extends NewsEvent {
  @override
  List<Object?> get props => [];
}
