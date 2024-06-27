import 'package:smart_shopping_list/main.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class ArticleDatabase {
  static Future<void> insertArticle(Article article) async {
    final db = await database;
    await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Article>> getAllArticles() async {
    final db = await database;

    final List<Map<String, Object?>> articlesMap = await db.query('articles');
    return [
      for (final {
            'name': name as String,
            'currentAmount': currentAmount as double,
            'dailyUsage': dailyUsage as double,
            'unit': unit as String,
            'rebuyAmount': rebuyAmount as double
          } in articlesMap)
        Article(
            name: name,
            currentAmount: currentAmount,
            dailyUsage: dailyUsage,
            unit: unit,
            rebuyAmount: rebuyAmount),
    ];
  }

  static Future<void> updateArticle(Article article) async {
    final db = await database;

    await db.update(
      'articles',
      article.toMap(),
      where: 'name = ?',
      whereArgs: [article.name],
    );
  }

  static Future<void> deleteArticle(String name) async {
    final db = await database;
    await db.delete(
      'articles',
      where: 'name = ?',
      whereArgs: [name],
    );
  }


  static Future<Article?> getArticle(String name) async {
    final db = await database;
    List<Map<String, Object?>> result = await db.query(
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
            rebuyAmount: result[0]['rebuyAmount'] as double);
    }else {

    }  
  }

  Future<Map<String, double>> fetchInventory() async {
    // This is a mock function. Replace it with your actual database fetch logic.
    return {
      'Tomato': 5.0,
      'coconut milk': 2.0,
      'pepper': 0.25,
      'Olive Oil': 1.0,
      // Add more ingredients as needed
    };
  }
}



