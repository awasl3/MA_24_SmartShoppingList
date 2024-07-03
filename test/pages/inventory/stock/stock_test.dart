import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/stock.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';

import '../stock_table/stock_table_header_deletion_confirm_test.mocks.dart';

void main() {
  test('Stock subtracts nothing on the same day', () async {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 3.14,
        dailyUsage: 1.59,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime.now());
    await GetIt.I.reset();
    final MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer((_) => Future.value([article]));
    when(mock.updateArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;
      final now = DateTime.now();
      final date = a.lastUsage;
      expect(date.year, now.year);
      expect(date.month, now.month);
      expect(date.day, now.day);
      expect(date.hour, 0);
      expect(date.minute, 0);
      expect(date.second, 0);
      expect(date.millisecond, 0);
      expect(date.microsecond, 0);
      article.lastUsage = a.lastUsage;
      expect(a.toString(), article.toString());

      return Future.value();
    });
    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    await Stock.subtractDailyUsage();

    verify(mock.getAllArticles()).called(1);
    verify(mock.updateArticle(any)).called(1);
  });

  test('Stock subtracts usage of 1 day', () async {
    DateTime date = DateTime.now();
    date = date.subtract(const Duration(days: 1));
    print(date);
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 3,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: date);
    await GetIt.I.reset();
    final MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer((_) => Future.value([article]));
    when(mock.updateArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;

      expect(a.currentAmount, 2);

      return Future.value();
    });
    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    await Stock.subtractDailyUsage();

    verify(mock.getAllArticles()).called(1);
    verify(mock.updateArticle(any)).called(1);
  });

  test('Stock subtracts usage of multiple days', () async {
    DateTime date = DateTime.now();
    date = date.subtract(const Duration(days: 30));
    print(date);
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 3,
        dailyUsage: 0.15,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: date);
    await GetIt.I.reset();
    final MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer((_) => Future.value([article]));
    when(mock.updateArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;

      expect(a.currentAmount, 0);

      return Future.value();
    });
    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    await Stock.subtractDailyUsage();

    verify(mock.getAllArticles()).called(1);
    verify(mock.updateArticle(any)).called(1);
  });
}
