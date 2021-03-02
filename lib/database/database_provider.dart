import 'dart:io';
import 'package:NewYorkTest/model/home_news_db_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE = "news";
  static const String COLUMN_ID = "id";
  static const String COLUMN_PATH = "path";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_SUBTITLE = "subtitle";
  static const String COLUMN_URL = "url";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, "audioQuote.db"),
        version: 1, //join = слэш
        onCreate: (Database database, int version) async {
      print("creating audioQuote table");
      await database.execute("CREATE TABLE $TABLE (" //командовать мекуним
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_PATH TEXT,"
          "$COLUMN_TITLE TEXT,"
          "$COLUMN_SUBTITLE TEXT,"
          "$COLUMN_URL TEXT"
          ")");
    });
  }

  Future<List<HomeNewsDBModel>> getAllNews() async {
    final db = await database;
    var news = await db.query(TABLE, columns: [
      //типо select* from
      COLUMN_ID,
      COLUMN_PATH,
      COLUMN_TITLE,
      COLUMN_SUBTITLE,
      COLUMN_URL,
    ]);

    List<HomeNewsDBModel> homeNewsDBModels = [];

    if (news.isNotEmpty) {
      news.forEach((element) {
        HomeNewsDBModel homeNewsDBModel = HomeNewsDBModel.fromMap(element);
        homeNewsDBModels.add(homeNewsDBModel);
      });

      return homeNewsDBModels;
    }
    return [];
  }

  Future<HomeNewsDBModel> insert(HomeNewsDBModel homeNewsDBModel) async {
    final db = await database;
    homeNewsDBModel.id = await db.insert(TABLE, homeNewsDBModel.toMap());
    return homeNewsDBModel;
  }

  Future<void> delete(HomeNewsDBModel homeNewsDBModel) async {
    final db = await database;
    await db.delete(TABLE,
        where: '${DatabaseProvider.COLUMN_ID} = ? ',
        whereArgs: [homeNewsDBModel.id]);
  }

  Future<void> deleteFileFromLocaStorage(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        imageCache.clear();
      }
    } catch (e) {
      print("Error accessing file: $e");
    }
  }
}
