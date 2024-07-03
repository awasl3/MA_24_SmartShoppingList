import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:units_converter/properties/mass.dart';
import 'package:units_converter/units_converter.dart';

class Stock {
  static Future<bool> isCookable(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      if (await GetIt.I.get<ArticleDatabse>().getArticle(ingredient) == null) {
        return false;
      }
    }
    return true;
  }

  static Future<List<String>> getMissingIngredients(
      List<String> ingredients) async {
    List<String> articles = [];
    for (String ingredient in ingredients) {
      if (await GetIt.I.get<ArticleDatabse>().getArticle(ingredient) == null) {
        articles.add(ingredient);
      }
    }
    return articles;
  }

  static Future<void> subtractIngredients(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      Article? article =
          await GetIt.I.get<ArticleDatabse>().getArticle(ingredient);
      if (article != null) {
        await GetIt.I.get<ArticleDatabse>().updateArticle(article);
      }
    }
  }

  static Future<void> addIngredients(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      Article? article =
          await GetIt.I.get<ArticleDatabse>().getArticle(ingredient);
      if (article != null) {
        await GetIt.I.get<ArticleDatabse>().updateArticle(article);
      } else {
        Article newArticle = Article(
            name: ingredient,
            currentAmount: 0,
            dailyUsage: 0,
            unit: "",
            rebuyAmount: 0,
            lastUsage: Article.resetUsage());
        await GetIt.I.get<ArticleDatabse>().insertArticle(newArticle);
      }
    }
  }

  static Future<void> subtractDailyUsage() async {
    List<Article> articles =
        await GetIt.I.get<ArticleDatabse>().getAllArticles();
    for (Article article in articles) {
      double newAmount = article.currentAmount -
          (DateTime.now().difference(article.lastUsage).inDays) *
              article.dailyUsage;
      Article updatedArticle = Article(
          name: article.name,
          currentAmount: newAmount,
          dailyUsage: article.dailyUsage,
          unit: article.unit,
          rebuyAmount: article.rebuyAmount,
          lastUsage: Article.resetUsage());
      GetIt.I.get<ArticleDatabse>().updateArticle(updatedArticle);
    }
  }

  static Future<void> addRebuyAmount(Map<String, int> shoppingCart) async {
    shoppingCart.forEach((key, value) async {
      Article? article = await GetIt.I.get<ArticleDatabse>().getArticle(key);
      if (article != null) {
        double newAmount = article.currentAmount + value * article.rebuyAmount;
        Article updatedArticle = Article(
            name: article.name,
            currentAmount: newAmount,
            dailyUsage: article.dailyUsage,
            unit: article.unit,
            rebuyAmount: article.rebuyAmount,
            lastUsage: article.lastUsage);
        GetIt.I.get<ArticleDatabse>().updateArticle(updatedArticle);
        await GetIt.I.get<ArticleDatabse>().updateArticle(article);
      }
    });
  }
}
