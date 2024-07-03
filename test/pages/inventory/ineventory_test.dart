import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/inventory.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

import 'stock_table/stock_table_header_deletion_confirm_test.mocks.dart';

final Article article = Article(
    name: "Testarticle",
    currentAmount: 3.14,
    dailyUsage: 1.59,
    unit: "liter",
    rebuyAmount: 265.359,
    lastUsage: DateTime(2024, 1, 7, 17, 30));

void main() {
  testWidgets('Inventory Page has loading screen', (tester) async {
    await GetIt.I.reset();
    MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer(
        (_) => Future.delayed(const Duration(seconds: 100), () => []));

    GetIt.I.registerSingleton<ArticleDatabse>(mock);

    Widget testWidget = getTestWidget([
      articlesChanged.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);

    await tester.pump(Duration(seconds: 111));
    expect(finder, findsNothing);
    verify(mock.getAllArticles()).called(1);
  });

  testWidgets('Inventory Page has display state', (tester) async {
    await GetIt.I.reset();
    MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer((_) => Future(() => [article]));

    GetIt.I.registerSingleton<ArticleDatabse>(mock);

    Widget testWidget = getTestWidget([
      articlesChanged.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);
    await tester.pump(Durations.extralong4);
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsNothing);
    final tableFinder = find.byType(StockTable);
    expect(tableFinder, findsOneWidget);
    expect((tableFinder.evaluate().first.widget as StockTable).articles,
        [article]);
    verify(mock.getAllArticles()).called(1);
  });
}

Widget getTestWidget(List<Override> overrides) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: const InventoryPage())));
}
