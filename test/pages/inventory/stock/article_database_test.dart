import 'dart:convert';

import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

Future main() async {
  Database?  db;
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE articles(name TEXT PRIMARY KEY, currentAmount REAL, dailyUsage REAL, unit TEXT, rebuyAmount REAL, lastUsage TEXT)');
    });
  });

  tearDown(() async {
    await db!.close();
  });

  final Article article = Article(
      name: "Testarticle",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));

  test('Database can insert Article', () async {
    await ArticleDatabase.insertArticle(article);
    expect(await db!.query('articles'), [
      {'id': 1, 'value': 'my_value'}
    ]);
  });
}
