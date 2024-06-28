import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:smart_shopping_list/main.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class ArticleDatabase {
  ArticleDatabase._privateConstructor();
  static final ArticleDatabase instance = ArticleDatabase._privateConstructor();
  static Database? _database;

  factory ArticleDatabase() {
    return instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
   final Future<Database> database  = openDatabase(
   join(await getDatabasesPath(), 'article_database.db'),
   onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE articles(name TEXT PRIMARY KEY, currentAmount REAL, dailyUsage REAL, unit TEXT, rebuyAmount REAL, lastUsage TEXT)',
    );
  },
   version: 1,
  );
    return database;
  }

  static Future<void> insertArticle(Article article) async {
    await ArticleDatabase._database!.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Article>> getAllArticles() async {
    final List<Map<String, Object?>> articlesMap = await ArticleDatabase._database!.query('articles');
    return [
      for (final {
            'name': name as String,
            'currentAmount': currentAmount as double,
            'dailyUsage': dailyUsage as double,
            'unit': unit as String,
            'rebuyAmount': rebuyAmount as double,
            'lastUsage' : lastUsage as String
          } in articlesMap)
        Article(
            name: name,
            currentAmount: currentAmount,
            dailyUsage: dailyUsage,
            unit: unit,
            rebuyAmount: rebuyAmount,
            lastUsage: DateTime.parse(lastUsage)),
    ];
  }

  static Future<void> updateArticle(Article article) async {


    await ArticleDatabase._database!.update(
      'articles',
      article.toMap(),
      where: 'name = ?',
      whereArgs: [article.name],
    );
  }

  static Future<void> deleteArticle(String name) async {
   
    await ArticleDatabase._database!.delete(
      'articles',
      where: 'name = ?',
      whereArgs: [name],
    );
  }


  static Future<Article?> getArticle(String name) async {
    List<Map<String, Object?>> result = await ArticleDatabase._database!.query(
      'articles',
      where: 'name = ?',
      whereArgs: [name] 
    );
    if(result.length == 1) {
      return  Article(
            name: result[0]['name'] as String,
            currentAmount: result[0]['currentAmount'] as double,
            dailyUsage: result[0]['dailyUsage'] as double,
            unit: result[0]['unit'] as String,
            rebuyAmount: result[0]['rebuyAmount'] as double,
            lastUsage: DateTime.parse( result[0]['lastUsage'] as String));
    }else { 

    }  
  }
}



