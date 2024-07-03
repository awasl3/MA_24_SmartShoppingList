import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final Article article = Article(
      name: "Testarticle",
      currentAmount: 3.14,
      dailyUsage: 1.59,
      unit: "liter",
      rebuyAmount: 265.359,
      lastUsage: DateTime(2024, 1, 7, 17, 30));

  test('Article should covert to map', () {
    final map = article.toMap();
    expect(map.length, 6);
    expect(map["name"], "Testarticle");
    expect(map["currentAmount"], 3.14);
    expect(map["dailyUsage"], 1.59);
    expect(map["unit"], "liter");
    expect(map["rebuyAmount"], 265.359);
    expect(map["lastUsage"], '2024-01-07T17:30:00.000');
  });

  test('Article should covert to string', () {
    final string = article.toString();
    expect(string,
        'Article{name: Testarticle, currentAmount: 3.14, dailyUsage: 1.59, unit: liter, rebuyAmount: 265.359, lastUsage: 2024-01-07 17:30:00.000}');
  });

  test('Article reset day of last usage', () {
    final date = Article.resetUsage();
    final now = DateTime.now();
    expect(date.year, now.year);
    expect(date.month, now.month);
    expect(date.day, now.day);
    expect(date.hour, 0);
    expect(date.minute, 0);
    expect(date.second, 0);
    expect(date.millisecond, 0);
    expect(date.microsecond, 0);
  });

  test('Two articles with the same properties should be equal', () {
    final date = DateTime.now();

    final article1 = Article(
      name: 'Test Article',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    final article2 = Article(
      name: 'Test Article',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    expect(article1, equals(article2));
  });

  test('Two articles with different properties should not be equal', () {
    final date = DateTime.now();

    final article1 = Article(
      name: 'Test Article 1',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    final article2 = Article(
      name: 'Test Article 2',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    expect(article1, isNot(equals(article2)));
  });

  test('Identical articles should have the same hashCode', () {
    final date = DateTime.now();

    final article1 = Article(
      name: 'Test Article',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    final article2 = Article(
      name: 'Test Article',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    expect(article1.hashCode, equals(article2.hashCode));
  });

  test('Different articles should have different hashCodes', () {
    final date = DateTime.now();

    final article1 = Article(
      name: 'Test Article 1',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    final article2 = Article(
      name: 'Test Article 2',
      currentAmount: 10.0,
      dailyUsage: 0.5,
      unit: 'kg',
      rebuyAmount: 5.0,
      lastUsage: date,
    );

    expect(article1.hashCode, isNot(equals(article2.hashCode)));
  });
}
