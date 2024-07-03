import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table.dart';
import 'package:smart_shopping_list/util/database/database/databse_instance.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  final Article article = Article(
      name: "Testarticle",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));

  testWidgets('Stock Table has no widgets', (tester) async {
    final table = StockTable(articles: []);
    Widget testWidget = getTestWidget(table);

    await tester.pumpWidget(testWidget);
    expect(find.byType(ArticleCell), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
    expect(table.articles, []);
  });

  testWidgets('Stock Table has one article cell', (tester) async {
    final table = StockTable(articles: [article]);
    Widget testWidget = getTestWidget(table);

    await tester.pumpWidget(testWidget);
    expect(find.byType(ArticleCell), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
    expect(table.articles, [article]);
  });

  testWidgets('Stock Table has two article cell', (tester) async {
    final table = StockTable(articles: [article, article]);
    Widget testWidget = getTestWidget(table);

    await tester.pumpWidget(testWidget);
    expect(find.byType(ArticleCell), findsExactly(2));
    expect(find.byType(SizedBox), findsExactly(1));
    expect(table.articles, [article, article]);
  });

  testWidgets('Stock Table sorts articles based on daily usage',
      (tester) async {
    final Article noUsage = Article(
        name: "Testarticle",
        currentAmount: 10,
        dailyUsage: 0,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final Article fourDays = Article(
        name: "Testarticle",
        currentAmount: 20,
        dailyUsage: 5,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final Article noStock = Article(
        name: "Testarticle",
        currentAmount: 0,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final Article noStockAndUsage = Article(
        name: "Testarticle",
        currentAmount: 0,
        dailyUsage: 0,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final table =
        StockTable(articles: [noStockAndUsage, fourDays, noStock, noUsage]);
    Widget testWidget = getTestWidget(table);

    await tester.pumpWidget(testWidget);

    expect(table.articles, [noStock, fourDays, noStockAndUsage, noUsage]);
  });

  testWidgets('Stock Table has two article cell', (tester) async {
    final table = StockTable(articles: [article, article]);
    Widget testWidget = getTestWidget(table);

    await tester.pumpWidget(testWidget);
    expect(find.byType(ArticleCell), findsExactly(2));
    expect(find.byType(SizedBox), findsExactly(1));
    expect(table.articles, [article, article]);
  });
}

Widget getTestWidget(StockTable child) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(home: ProviderScope(child: child)));
}
