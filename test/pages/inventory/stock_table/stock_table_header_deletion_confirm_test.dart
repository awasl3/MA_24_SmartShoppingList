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
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table_header.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/database/database/databse_instance.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'stock_table_header_deletion_confirm_test.mocks.dart';

@GenerateMocks([ArticleDatabse])
Future main() async {
  final Article article = Article(
      name: "Testarticle",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));

  final Article article1 = Article(
      name: "Testarticle 1",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));

  testWidgets('Deletion Dialog can be confirmed', (tester) async {
    final MockArticleDatabse mock = MockArticleDatabse();
    when(mock.deleteArticle(any)).thenAnswer((_) => Future.value());
    GetIt.I.registerSingleton<ArticleDatabse>(mock);
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article, article1];
      }),
      articleDeletionMode.overrideWith((ref) {
        return true;
      }),
      articlesChanged.overrideWith((ref) {
        return true;
      })
    ]);

    await tester.pumpWidget(testWidget);
    final button = find.byType(FloatingActionButton).evaluate().last.widget
        as FloatingActionButton;
    expect(find.byType(FloatingActionButton), findsExactly(2));
    expect(button.backgroundColor, Colors.redAccent);
    expect((button.child as Icon).icon, Icons.delete_forever);
    await tester.tap(find.byType(FloatingActionButton).last);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Confirm"));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);

    final element = tester.element(find.byType(StockTableHeader));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 0);
    expect(container.read(articleDeletionMode), false);
    expect(container.read(articlesChanged), false);

    verify(mock.deleteArticle("Testarticle")).called(1);
    verify(mock.deleteArticle("Testarticle 1")).called(1);

    await GetIt.I.reset();
  });
}

Widget getTestWidget(List<Override> overrides) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: const StockTableHeader())));
}
