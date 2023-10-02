import 'package:flutter/material.dart';

class DBModelFields {
  static const String id = "_id";
  static const String name = "title";
  static const String message = "body";
  static const String createdAt = "createdAt";

  static const String dbTable = "chatTel";

}

class DBModelSql {
  int? id;
  final String name;
  final String message;
  final String createdAt;

  DBModelSql({
    this.id,
    required this.name,
    required this.message,
    required this.createdAt,
  });

  DBModelSql copyWith({
    String? name,
    String? message,
    String? createdAt,
    int? id,
  }) {
    return DBModelSql(
      message: message ?? this.message,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  factory DBModelSql.fromJson(Map<String, dynamic> json) {
    return DBModelSql(
      message: json[DBModelFields.message] ?? "",
      name: json[DBModelFields.name] ?? "",
      createdAt: json[DBModelFields.createdAt] ?? "",
      id: json[DBModelFields.id] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DBModelFields.message: message,
      DBModelFields.name: name,
      DBModelFields.createdAt: createdAt,
    };
  }

  @override
  String toString() {
    return '''
      description: $message 
      title: $name
      createdAt: $createdAt 
      id: $id, 
    ''';
  }
}

class DBModel {
  final String name;
  final String message;
  final String createdAt;

  DBModel({
    required this.name,
    required this.message,
    required this.createdAt,
  });

  DBModel copyWith({
    String? name,
    String? message,
    String? createdAt,
  }) {
    return DBModel(
      message: message ?? this.message,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory DBModel.fromJson(Map<String, dynamic> json) {
    debugPrint('DBModel fromJson');
    return DBModel(
      message: json["body"] ?? "",
      name: json["title"] ?? "",
      createdAt: json["createdAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DBModelFields.message: message,
      DBModelFields.name: name,
      DBModelFields.createdAt: createdAt,
    };
  }

  @override
  String toString() {
    return '''
      description: $message 
      title: $name
      createdAt: $createdAt 
    ''';
  }
}
