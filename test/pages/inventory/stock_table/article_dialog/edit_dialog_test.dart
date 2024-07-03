import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

import '../article_cell_test.dart';
import '../stock_table_header_deletion_confirm_test.mocks.dart';

void main() {
  final Article article = Article(
      name: "Testarticle",
      currentAmount: 4,
      dailyUsage: 1,
      unit: "liter",
      rebuyAmount: 2,
      lastUsage: DateTime(2024, 1, 7, 17, 30));
  testWidgets('Editor can update fiedls of article', (tester) async {
    await GetIt.I.reset();
    MockArticleDatabse mock = MockArticleDatabse();
    when(mock.updateArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;
      expect(a.unit, 'kilogramm');
      return Future(() => [article]);
    });

    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [];
      }),
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ], article);
    await tester.pumpWidget(testWidget);

    await tester.tap(find.byType(ArticleCell));

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Testarticle'), findsExactly(2));
    expect(find.text('4.0'), findsExactly(1));
    expect(find.text('1.0'), findsExactly(1));
    expect(find.text('liter'), findsExactly(1));
    expect(find.text('2.0'), findsExactly(1));

    expect(find.text('Edit Article'), findsOneWidget);

    await tester.enterText(find.text('liter'), 'kilogramm');

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();
    verify(mock.updateArticle(any)).called(1);
  });

  testWidgets('Editor can change name of article', (tester) async {
    await GetIt.I.reset();
    MockArticleDatabse mock = MockArticleDatabse();
    when(mock.insertArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;
      expect(a.name, 'changed');
      return Future(() => [article]);
    });

    when(mock.deleteArticle("Testarticle")).thenAnswer((Invocation invocation) {
      return Future(() => [article]);
    });

    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [];
      }),
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ], article);
    await tester.pumpWidget(testWidget);

    await tester.tap(find.byType(ArticleCell));

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Testarticle'), findsExactly(2));
    expect(find.text('4.0'), findsExactly(1));
    expect(find.text('1.0'), findsExactly(1));
    expect(find.text('liter'), findsExactly(1));
    expect(find.text('2.0'), findsExactly(1));

    expect(find.text('Edit Article'), findsOneWidget);

    await tester.enterText(find.text('Testarticle'), 'changed');

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    verify(mock.insertArticle(any)).called(1);
    verify(mock.deleteArticle(any)).called(1);
  });
}

Widget getTestWidget(List<Override> overrides, Article article) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: ArticleCell(article: article))));
}
