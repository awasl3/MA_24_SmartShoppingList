import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/util/database/database_instance_impl.dart';
import 'package:smart_shopping_list/util/database/databse_instance.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'article_database_test.mocks.dart';

@GenerateMocks([DatabaseInstance])
Future main() async {
  Database? db;
  final Article article = Article(
      name: "Testarticle",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    GetIt.I.reset();
    db = await openDatabase(inMemoryDatabasePath, version: 1,
        onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE articles(name TEXT PRIMARY KEY, currentAmount REAL, dailyUsage REAL, unit TEXT, rebuyAmount REAL, lastUsage TEXT)');
    });
    MockDatabaseInstance mock = MockDatabaseInstance();
    when(mock.getDatabase()).thenAnswer((_) {
      return Future.value(db!);
    });
    GetIt.I.registerSingleton<DatabaseInstance>(mock);
  });

  tearDown(() async {
    await db!.close();
  });

  test('Database can insert Article', () async {
    await ArticleDatabase.insertArticle(article);
    final map = await db!.query('articles');
    expect(map, [
      {
        "name": "Testarticle",
        "currentAmount": 3.14,
        "dailyUsage": 1.59,
        "unit": "liter",
        "rebuyAmount": 265.359,
        "lastUsage": "2024-01-07T17:30:00.000"
      }
    ]);
    expect(map.length, 1);
  });

  test('Database can get all articles', () async {
    await ArticleDatabase.insertArticle(article);
    final articles = await ArticleDatabase.getAllArticles();
    expect(articles[0].toMap(), article.toMap());
    expect(articles.length, 1);
  });

  test('Database can update article', () async {
    Article update = Article(
        name: "Testarticle",
        currentAmount: 1,
        dailyUsage: 2,
        unit: "kylo",
        rebuyAmount: 3,
        lastUsage: DateTime(2024, 1, 7, 17, 30));

    await ArticleDatabase.insertArticle(update);
    final map = await db!.query('articles');
    expect(map, [
      {
        "name": "Testarticle",
        "currentAmount": 1,
        "dailyUsage": 2,
        "unit": "kylo",
        "rebuyAmount": 3,
        "lastUsage": "2024-01-07T17:30:00.000"
      }
    ]);

    update = Article(
        name: "Testarticle",
        currentAmount: 1,
        dailyUsage: 2,
        unit: "kilo",
        rebuyAmount: 3,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    await ArticleDatabase.updateArticle(update);
    final map1 = await db!.query('articles');
    expect(map1, [
      {
        "name": "Testarticle",
        "currentAmount": 1,
        "dailyUsage": 2,
        "unit": "kilo",
        "rebuyAmount": 3,
        "lastUsage": "2024-01-07T17:30:00.000"
      }
    ]);
    expect(map.length, 1);
  });

  test('Database updates article based on name', () async {
    Article update = Article(
        name: "Testarticle",
        currentAmount: 1,
        dailyUsage: 2,
        unit: "kilo",
        rebuyAmount: 3,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    await ArticleDatabase.insertArticle(update);
    final map = await db!.query('articles');
    expect(map, [
      {
        "name": "Testarticle",
        "currentAmount": 1,
        "dailyUsage": 2,
        "unit": "kilo",
        "rebuyAmount": 3,
        "lastUsage": "2024-01-07T17:30:00.000"
      }
    ]);

    update = Article(
        name: "Testarticle 1",
        currentAmount: 1,
        dailyUsage: 2,
        unit: "kilo",
        rebuyAmount: 3,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    await ArticleDatabase.updateArticle(update);
    final map1 = await db!.query('articles');
    expect(map1.length, 1);
    expect(map1[0], {
      "name": "Testarticle",
      "currentAmount": 1,
      "dailyUsage": 2,
      "unit": "kilo",
      "rebuyAmount": 3,
      "lastUsage": "2024-01-07T17:30:00.000"
    });
  });

  test('Database can delete Article', () async {
    await ArticleDatabase.insertArticle(article);
    final map = await db!.query('articles');
    expect(map.length, 1);
    await ArticleDatabase.deleteArticle("Not real");
    final map1 = await db!.query('articles');
    expect(map1.length, 1);

    await ArticleDatabase.deleteArticle("Testarticle");
    final map2 = await db!.query('articles');
    expect(map2.length, 0);
  });

  test('Database can get single Article', () async {
    await ArticleDatabase.insertArticle(article);
    Article update = Article(
        name: "Testarticle 2",
        currentAmount: 1,
        dailyUsage: 2,
        unit: "kilo",
        rebuyAmount: 3,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    await ArticleDatabase.insertArticle(update);
    Article? get = await ArticleDatabase.getArticle("Testarticle");
    expect(get.toString(), article.toString());
  });

  test('Database gets no Article on wrong key', () async {
    await ArticleDatabase.insertArticle(article);

    Article? get = await ArticleDatabase.getArticle("Not real");
    expect(get, null);
  });
}
