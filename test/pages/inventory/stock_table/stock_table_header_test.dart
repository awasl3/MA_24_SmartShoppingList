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

  testWidgets('Stock Table Header has Add Button', (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionMode.overrideWith((ref) {
        return false;
      })
    ]);

    await tester.pumpWidget(testWidget);
    final button = find.byType(FloatingActionButton).evaluate().first.widget
        as FloatingActionButton;
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(button.backgroundColor, Colors.greenAccent);
    expect((button.child as Icon).icon, Icons.add);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    expect(find.text('Name must be provided'), findsOneWidget);
    expect(find.text('Current amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);
  });

  testWidgets('Stock Table Header has Delete Button', (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionMode.overrideWith((ref) {
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

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
        find.text(
            'Are you sure, you want to deleted the selected articles from the stock.\n! This action can not be undone !'),
        findsOneWidget);
    expect(find.text('Delete Articles'), findsOneWidget);
  });

  testWidgets('Deletion Dialog can be canceled', (tester) async {
    Widget testWidget = getTestWidget([
      articleDeletionSelection.overrideWith((ref) {
        return [article];
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

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
        find.text(
            'Are you sure, you want to deleted the selected articles from the stock.\n! This action can not be undone !'),
        findsOneWidget);
    expect(find.text('Delete Articles'), findsOneWidget);

    await tester.tap(find.text("Cancel"));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);

    final element = tester.element(find.byType(StockTableHeader));
    final container = ProviderScope.containerOf(element);

    expect(container.read(articleDeletionSelection).length, 1);
    expect(container.read(articleDeletionMode), true);
    expect(container.read(articlesChanged), true);
  });
}

Widget getTestWidget(List<Override> overrides) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: const StockTableHeader())));
}
