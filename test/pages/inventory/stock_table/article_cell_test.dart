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
 
  test('ArticleCell gets correct Color on high stock', () {
    final Article article = Article(
        name: "Testarticle",
        currentAmount: 4,
        dailyUsage: 1,
        unit: "liter",
        rebuyAmount: 2,
        lastUsage: DateTime(2024, 1, 7, 17, 30));
    final cell = ArticleCell(article: article);
    Color? color = cell.getColor([]);
    expect(color, null);
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
    Color? color = cell.getColor([]);
    expect(color, Colors.amberAccent.shade100);
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
    Color? color = cell.getColor([]);
    expect(color, Colors.redAccent);
  });

  testWidgets('ArticleCell displays data from article', (tester) async {
    await tester.pumpWidget(getTestWidget([],article));
    final nameFinder = find.text('Testarticle');
    final stockFinder = find.text('3.14 liter @ 1.59 liter/day');
    

    expect(nameFinder, findsOneWidget);
    expect(stockFinder, findsOneWidget);


    Text text = nameFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, null);
    expect(text.style!.fontSize, 20);
  });

  testWidgets('ArticleCell displays data from article with no usagae', (tester) async {
    final Article article = Article(
    name: "Testarticle",
    currentAmount: 3.14,
    dailyUsage: 0,
    unit: "liter",
    rebuyAmount: 265.359,
    lastUsage: DateTime(2024, 1, 7, 17, 30));
    await tester.pumpWidget(getTestWidget([],article));
    final nameFinder = find.text('Testarticle');
    final stockFinder = find.text('3.14 liter');
    

    expect(nameFinder, findsOneWidget);
    expect(stockFinder, findsOneWidget);


    Text text = nameFinder.evaluate().first.widget as Text;
    expect(text.style!.decoration, null);
    expect(text.style!.fontSize, 20);
  });

  testWidgets('ArticleCell displays data with cross on deletion',
      (tester) async {
    await tester.pumpWidget(getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article];
      })
    ],article));

    final crossFinder = find.byType(Icon);

    Icon icon = crossFinder.evaluate().first.widget as Icon;
    expect(icon.icon, Icons.close);
    expect(icon.size, 40);
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
    ],article);
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
    ],article);
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
    ],article);
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
    final Article article1 = Article(
        name: "Testarticle 1",
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
    ],article1);

    await tester.pumpWidget(testWidget);

    final element = tester.element(find.byType(ArticleCell));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 1);

    await tester.tap(find.byType(ArticleCell));

    expect(container.read(articleDeletionSelection).contains(article1), true);
    expect(container.read(articleDeletionSelection).contains(article), true);
    expect(container.read(articleDeletionSelection).length, 2);
    expect(container.read(articleDeletionMode), true);
  });

  testWidgets('ArticleCell removes article from removal list on tap',
      (tester) async {
    final Article article1 = Article(
        name: "Testarticle 1",
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
    ],article);

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
    ],article);

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

Widget getTestWidget(List<Override> overrides,Article article) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: ArticleCell(article: article))));
}
