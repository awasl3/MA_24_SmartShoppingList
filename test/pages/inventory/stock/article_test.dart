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
        'Article{name: Testarticle, currentAmount: 3.14, dailyUsage: 1.59, unit: liter, rebuyAmount: 265.359, lastUsgage: 2024-01-07 17:30:00.000}');
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
}
