import 'package:chat/data/models/db_model.dart';
import 'package:chat/data/models/news_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotLocalDatabase {
  static final NotLocalDatabase getInstance = NotLocalDatabase._init();
  static String dataPath = '';
  NotLocalDatabase._init();

  factory NotLocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("notification.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    dataPath = path;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";

    await db.execute('''
    CREATE TABLE ${NewsFields.dbTable} (
    ${NewsFields.id} $idType,
    ${NewsFields.title} $textType,
    ${NewsFields.body} $textType,
    ${NewsFields.createdAt} $textType
    )
    ''');
  }

  static Future<NewsModel> insertNotification(NewsModel newsModel) async {
    final db = await getInstance.database;
    final int id = await db.insert(NewsFields.dbTable, newsModel.toJson());
    return newsModel.copyWith(id: id);
  }

  static Future<List<NewsModel>> getAllNotifications() async {
    List<NewsModel> allNotifications = [];
    final db = await getInstance.database;
    allNotifications = (await db.query(NewsFields.dbTable))
        .map((e) => NewsModel.fromJson(e))
        .toList();

    return allNotifications;
  }

  static Future<void> deleteMessage(int id) async {
    final db = await getInstance.database;
    try{
      db.delete(
      NewsFields.dbTable,
        where: "id = ?",
        whereArgs: [id],
      );
      debugPrint('delete message');
    }catch(error){
      debugPrint(error.toString());
    }
  }

  static Future<void> deleteOptionTable() async {
    final db = await getInstance.database;
    db.rawDelete("Delete from ${DBModelFields.dbTable}");
    debugPrint('-----Table deleted-----');
  }
}
