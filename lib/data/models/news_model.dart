class NewsModel {
  int? id;
  String title;
  String body;
  String createdAt;

  NewsModel({
    this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json[NewsFields.id] ?? 0,
        title: json[NewsFields.title] ?? '',
        body: json[NewsFields.body] ?? '',
        createdAt: json[NewsFields.createdAt] ?? '',
      );

  NewsModel copyWith({
    int? id,
    String? title,
    String? body,
    String? createdAt,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      NewsFields.id: id,
      NewsFields.title: title,
      NewsFields.body: body,
      NewsFields.createdAt: createdAt,
    };
  }

  @override
  String toString() {
    return ''''
        id: $id,
        title: $title,
        body: $body,
        createdAt: $createdAt,
      ''';
  }
}

class NewsFields {
  static const String id = "id";
  static const String title = "title";
  static const String body = "body";
  static const String createdAt = "createdAt";

  static const String dbTable = "notification";
}
