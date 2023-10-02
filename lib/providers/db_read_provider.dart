import 'package:chat/data/db/sqflite.dart';
import 'package:chat/data/models/db_model.dart';
import 'package:flutter/material.dart';

class ReadProvider with ChangeNotifier{
  List<DBModelSql> messages = [];

  ReadProvider(){
    readMessages();
  }

  readMessages()async{
    messages =  await LocalDatabase.getAllMessages();
    notifyListeners();
  }

  deleteMessage(int id)async{
    await LocalDatabase.deleteMessage(id);
    readMessages();
    notifyListeners();
  }

  deleteAll()async{
    await LocalDatabase.deleteOptionTable();
    notifyListeners();
  }
}