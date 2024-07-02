import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:smart_shopping_list/main.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/database/database_instance_impl.dart';
import 'package:smart_shopping_list/util/database/databse_instance.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class ArticleDatabase {
  static Future<void> insertArticle(Article article) async {
    final database = await GetIt.I.get<DatabaseInstance>().getDatabase();
    await database.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Article>> getAllArticles() async {
    final database = await GetIt.I.get<DatabaseInstance>().getDatabase();
    final List<Map<String, Object?>> articlesMap =
        await database.query('articles');
    return [
      for (final {
            'name': name as String,
            'currentAmount': currentAmount as double,
            'dailyUsage': dailyUsage as double,
            'unit': unit as String,
            'rebuyAmount': rebuyAmount as double,
            'lastUsage': lastUsage as String
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
    final database = await GetIt.I.get<DatabaseInstance>().getDatabase();

    await database.update(
      'articles',
      article.toMap(),
      where: 'name = ?',
      whereArgs: [article.name],
    );
  }

  static Future<void> deleteArticle(String name) async {
    final database = await GetIt.I.get<DatabaseInstance>().getDatabase();
    await database.delete(
      'articles',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  static Future<Article?> getArticle(String name) async {
    final database = await GetIt.I.get<DatabaseInstance>().getDatabase();
    List<Map<String, Object?>> result =
        await database.query('articles', where: 'name = ?', whereArgs: [name]);
    if (result.length == 1) {
      return Article(
          name: result[0]['name'] as String,
          currentAmount: result[0]['currentAmount'] as double,
          dailyUsage: result[0]['dailyUsage'] as double,
          unit: result[0]['unit'] as String,
          rebuyAmount: result[0]['rebuyAmount'] as double,
          lastUsage: DateTime.parse(result[0]['lastUsage'] as String));
    } else {
      return null;
    }
  }
}
