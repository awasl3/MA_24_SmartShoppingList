import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

final Article article = Article(
    name: "Testarticle",
    currentAmount: 3.14,
    dailyUsage: 1.59,
    unit: "liter",
    rebuyAmount: 265.359,
    lastUsage: DateTime(2024, 1, 7, 17, 30));

void main() {
  test('ArticleCell gets correct Color on selection', () {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 3,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 2,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final cell = ArticleCell(article: article);
    Color color = cell.getColor([article]);
    expect(color, Colors.red);
  });

  test('ArticleCell gets correct Color on high stock', () {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 4,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 2,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final cell = ArticleCell(article: article);
    Color color = cell.getColor([]);
    expect(color, Colors.green.withOpacity(0.8));
  });

  test('ArticleCell gets correct Color on medium stock', () {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 2,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 2,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final cell = ArticleCell(article: article);
    Color color = cell.getColor([]);
    expect(color, Colors.amber.withOpacity(0.8));
  });

  test('ArticleCell gets correct Color on low stock', () {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 1,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 2,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final cell = ArticleCell(article: article);
    Color color = cell.getColor([]);
    expect(color, Colors.red.withOpacity(0.8));
  });

  testWidgets('ArticleCell displays data from article', (tester) async {
    await tester.pumpWidget(getTestWidget([]));
    final nameFinder = find.text('Testarticle');
    final stockFinder = find.text('In stock: 3.14 liter');
    final usageFinder = find.text('Usage: 1.59 liter/day');

    expect(nameFinder, findsOneWidget);
    expect(stockFinder, findsOneWidget);
    expect(usageFinder, findsOneWidget);

    Text text = nameFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, null);
    expect(text.style!.fontSize, 30);
  });

  testWidgets('ArticleCell displays data with line through on deletion',
      (tester) async {
    await tester.pumpWidget(getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article];
      })
    ]));

    final nameFinder = find.text('Testarticle');
    final stockFinder = find.text('In stock: 3.14 liter');
    final usageFinder = find.text('Usage: 1.59 liter/day');

    Text text = nameFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, TextDecoration.lineThrough);

    text = stockFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, TextDecoration.lineThrough);

    text = usageFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, TextDecoration.lineThrough);
  });

  testWidgets('ArticleCell changes to deletion mode on long press',
      (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [];
      }),
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);
    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 0);
    expect(container.read(articleDeletionMode), false);

    await tester.longPress(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article), true);
    expect(container.read(articleDeletionSelection).length, 1);
    expect(container.read(articleDeletionMode), true);
  });

  testWidgets('ArticleCell changes to deletion mode on long press',
      (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [];
      }),
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);
    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 0);
    expect(container.read(articleDeletionMode), false);

    await tester.longPress(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article), true);
    expect(container.read(articleDeletionSelection).length, 1);
    expect(container.read(articleDeletionMode), true);
  });

  testWidgets('ArticleCell opens editor on tap', (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [];
      }),
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);

    await tester.tap(find.byType(ArticleCell));

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Testarticle'), findsExactly(2));
    expect(find.text('liter'), findsExactly(1));
    expect(find.text('1.59'), findsExactly(1));
    expect(find.text('3.14'), findsExactly(1));
    expect(find.text('Edit Article'), findsOneWidget);
  });

  testWidgets('ArticleCell adds article to removal list on tap',
      (tester) async {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 3.14,
        dailyUsage: 1.59,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article];
      }),
      articleDeletionMode.overrideWith((ref) {
        return true;
      })
    ]);

    await tester.pumpWidget(testWidget);

    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 1);

    await tester.tap(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article), true);
    expect(container.read(articleDeletionSelection).length, 2);
    expect(container.read(articleDeletionMode), true);
  });

  testWidgets('ArticleCell removes article from removal list on tap',
      (tester) async {
    final Article article1 = Article(
        name: "Testarticle",
        currentAmount: 3.14,
        dailyUsage: 1.59,
        unit: "liter",
        rebuyAmount: 265.359,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article, article1];
      }),
      articleDeletionMode.overrideWith((ref) {
        return true;
      })
    ]);

    await tester.pumpWidget(testWidget);

    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 2);
    expect(container.read(articleDeletionSelection).contains(article), true);
    expect(container.read(articleDeletionSelection).contains(article1), true);

    await tester.tap(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article), false);
    expect(container.read(articleDeletionSelection).contains(article1), true);
    expect(container.read(articleDeletionSelection).length, 1);
    expect(container.read(articleDeletionMode), true);
  });

  testWidgets('ArticleCell exits deletion mode on empty removal list',
      (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article];
      }),
      articleDeletionMode.overrideWith((ref) {
        return true;
      })
    ]);

    await tester.pumpWidget(testWidget);

    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 1);
    expect(container.read(articleDeletionSelection).contains(article), true);

    await tester.tap(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article), false);
    expect(container.read(articleDeletionSelection).length, 0);
    expect(container.read(articleDeletionMode), false);
  });
}

Widget getTestWidget(List<Override> overrides) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: ArticleCell(article: article))));
}
