import 'package:chat/data/models/db_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static String dataPath = '';
  LocalDatabase._init();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("chat.db");
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
    CREATE TABLE ${DBModelFields.dbTable} (
    ${DBModelFields.id} $idType,
    ${DBModelFields.name} $textType,
    ${DBModelFields.message} $textType,
    ${DBModelFields.createdAt} $textType
    )
    ''');
  }

  static Future<DBModelSql> insertTodo(DBModelSql dbModelSql) async {
    final db = await getInstance.database;
    final int id = await db.insert(DBModelFields.dbTable, dbModelSql.toJson());
    return dbModelSql.copyWith(id: id);
  }

  static Future<List<DBModelSql>> getAllMessages() async {
    List<DBModelSql> allMessages = [];
    final db = await getInstance.database;
    allMessages = (await db.query(DBModelFields.dbTable))
        .map((e) => DBModelSql.fromJson(e))
        .toList();

    return allMessages;
  }

  static deleteMessage(int id) async {
    final db = await getInstance.database;
    db.delete(
      DBModelFields.dbTable,
      where: "${DBModelFields.id} = ?",
      whereArgs: [id],
    );
  }

  static Future<void> deleteOptionTable() async {
    final db = await getInstance.database;
    db.rawDelete("Delete from ${DBModelFields.dbTable}");
    debugPrint('-----Table deleted-----');
  }
  dropTable() async {
    final db = await database;
    db.query('SELECT * FROM cloudnet360.db WHERE name =option and type=table');
  }
}
