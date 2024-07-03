import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:units_converter/properties/mass.dart';
import 'package:units_converter/units_converter.dart';

class Stock {
  static Future<void> subtractDailyUsage() async {
    List<Article> articles =
        await GetIt.I.get<ArticleDatabse>().getAllArticles();
    for (Article article in articles) {
      double newAmount = article.currentAmount -
          (DateTime.now().difference(article.lastUsage).inDays) *
              article.dailyUsage;
      Article updatedArticle = Article(
          name: article.name,
          currentAmount: newAmount > 0 ? newAmount : 0,
          dailyUsage: article.dailyUsage,
          unit: article.unit,
          rebuyAmount: article.rebuyAmount,
          lastUsage: Article.resetUsage());
      GetIt.I.get<ArticleDatabse>().updateArticle(updatedArticle);
    }
  }
}
