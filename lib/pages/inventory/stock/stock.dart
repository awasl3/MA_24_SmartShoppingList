import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';

class Stock {
  static Future<bool> isCookable(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      if (await ArticleDatabase.getArticle(ingredient) == null) {
        return false;
      }
    }
    return true;
  }

  static Future<List<String>> getMissingIngredients(
      List<String> ingredients) async {
    List<String> articles = [];
    for (String ingredient in ingredients) {
      if (await ArticleDatabase.getArticle(ingredient) == null) {
        articles.add(ingredient);
      }
    }
    return articles;
  }

  static Future<void> subtractIngredients(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      Article? article = await ArticleDatabase.getArticle(ingredient);
      if (article != null) {
        await ArticleDatabase.updateArticle(article);
      }
    }
  }

  static Future<void> addIngredients(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      Article? article = await ArticleDatabase.getArticle(ingredient);
      if (article != null) {
        await ArticleDatabase.updateArticle(article);
      } else {
        Article newArticle = Article(
            name: ingredient,
            currentAmount: 0,
            dailyUsage: 0,
            unit: "",
            rebuyAmount: 0);
        await ArticleDatabase.insertArticle(newArticle);
      }
    }
  }

  static Future<void> subtractDailyUsage() async {
    List<Article> articles = await ArticleDatabase.getAllArticles();
    for (Article article in articles) {
      if (article.dailyUsage > 0) {
        double newAmount = article.currentAmount - article.dailyUsage;
        Article updatedArticle = Article(
            name: article.name,
            currentAmount: newAmount,
            dailyUsage: article.dailyUsage,
            unit: article.unit,
            rebuyAmount: article.rebuyAmount);
        ArticleDatabase.updateArticle(updatedArticle);
      }
    }
  }

  static Future<void> addRebuyAmount(Map<String, int> shoppingCart) async {
    shoppingCart.forEach((key, value) async {
      Article? article = await ArticleDatabase.getArticle(key);
      if (article != null) {
        double newAmount = article.currentAmount + value * article.rebuyAmount;
        Article updatedArticle = Article(
            name: article.name,
            currentAmount: newAmount,
            dailyUsage: article.dailyUsage,
            unit: article.unit,
            rebuyAmount: article.rebuyAmount);
        ArticleDatabase.updateArticle(updatedArticle);
        await ArticleDatabase.updateArticle(article);
      }
    });
  }
}
