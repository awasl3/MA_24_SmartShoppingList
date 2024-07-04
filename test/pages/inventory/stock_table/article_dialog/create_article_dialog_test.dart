import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:smart_shopping_list/pages/inventory/inventory.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

import '../stock_table_header_deletion_confirm_test.mocks.dart';

final Article article = Article(
    name: "Testarticle",
    currentAmount: 3.14,
    dailyUsage: 1.59,
    unit: "liter",
    rebuyAmount: 265.359,
    lastUsage: DateTime(2024, 1, 7, 17, 30));

void main() {
  testWidgets('Add dialog adds article', (tester) async {
    await GetIt.I.reset();
    MockArticleDatabse mock = MockArticleDatabse();
    when(mock.getAllArticles()).thenAnswer((_) => Future(() => [article]));
    when(mock.insertArticle(any)).thenAnswer((Invocation invocation) {
      Article a = invocation.positionalArguments.first as Article;

      expect(a.name, 'Article name');
      expect(a.currentAmount, 1.0);
      expect(a.dailyUsage, 2.0);
      expect(a.unit, 'kilo');
      expect(a.rebuyAmount, 3.0);
      return Future.value();
    });

    GetIt.I.registerSingleton<ArticleDatabse>(mock);

    Widget testWidget = getTestWidget([
      articlesChanged.overrideWith((ref) {
        return false;
      })
    ]);
    await tester.pumpWidget(testWidget);
    final button = find.byType(FloatingActionButton).evaluate().first.widget
        as FloatingActionButton;
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect((button.child as Icon).icon, Icons.add);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    expect(find.text('Name must be provided'), findsOneWidget);
    expect(find.text('Current amount must be provided'), findsOneWidget);
    expect(find.text('Daily usage must be provided'), findsOneWidget);
    expect(find.text('Unit must be provided'), findsOneWidget);
    expect(find.text('Rebuy amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);

    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        null);

    await tester.enterText(find.byType(TextFormField).at(0), 'Article name');
    await tester.pumpAndSettle();
    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        null);
    expect(find.text('Name must be provided'), findsNothing);
    expect(find.text('Current amount must be provided'), findsOneWidget);
    expect(find.text('Daily usage must be provided'), findsOneWidget);
    expect(find.text('Unit must be provided'), findsOneWidget);
    expect(find.text('Rebuy amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'aaaaaa');
    await tester.pumpAndSettle();
    expect(find.text('Current amount must be a number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), '1.0');
    await tester.pumpAndSettle();
    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        null);
    expect(find.text('Name must be provided'), findsNothing);
    expect(find.text('Current amount must be provided'), findsNothing);
    expect(find.text('Current amount must be a number'), findsNothing);
    expect(find.text('Daily usage must be provided'), findsOneWidget);
    expect(find.text('Unit must be provided'), findsOneWidget);
    expect(find.text('Rebuy amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(2), 'aaaaaa');
    await tester.pumpAndSettle();
    expect(find.text('Daily usage must be a number'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(2), '2.0');
    await tester.pumpAndSettle();
    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        null);
    expect(find.text('Name must be provided'), findsNothing);
    expect(find.text('Current amount must be provided'), findsNothing);
    expect(find.text('Daily usage must be provided'), findsNothing);
    expect(find.text('Daily usage must be a number'), findsNothing);
    expect(find.text('Unit must be provided'), findsOneWidget);
    expect(find.text('Rebuy amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(3), 'kilo');
    await tester.pumpAndSettle();
    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        null);
    expect(find.text('Name must be provided'), findsNothing);
    expect(find.text('Current amount must be provided'), findsNothing);
    expect(find.text('Daily usage must be provided'), findsNothing);
    expect(find.text('Unit must be provided'), findsNothing);
    expect(find.text('Rebuy amount must be provided'), findsOneWidget);
    expect(find.text('Create Article'), findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(4), 'aaaaaa');
    await tester.pumpAndSettle();
    expect(find.text('Rebuy amount must be a number'), findsOneWidget);

    await tester.enterText(
        find.byType(TextFormField, skipOffstage: false).at(4), '3.0');
    await tester.pump();
    expect(
        ((find.byType(AlertDialog).evaluate().first.widget as AlertDialog)
                .actions![1] as ElevatedButton)
            .onPressed,
        isNotNull);
    expect(find.text('Name must be provided'), findsNothing);
    expect(find.text('Current amount must be provided'), findsNothing);
    expect(find.text('Daily usage must be provided'), findsNothing);
    expect(find.text('Unit must be provided'), findsNothing);
    expect(find.text('Rebuy amount must be provided'), findsNothing);
    expect(find.text('Rebuy amount must be a number'), findsNothing);
    expect(find.text('Create Article'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    verify(mock.insertArticle(any)).called(1);
  });
}

Widget getTestWidget(List<Override> overrides) {
  return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: ProviderScope(
              overrides: overrides, child: const InventoryPage())));
}
