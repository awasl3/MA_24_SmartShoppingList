import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';

class Stock {
  static Future<bool> isCookable(List<String> ingredients) async {
    for (String ingredient in ingredients) {
      if(await ArticleDatabase.getArticle(ingredient) == null) {
        return false;
      }
    }
    return true;
  }


  static Future<List<String>> getMissingIngredients(List<String> ingredients) async {
    List<String> articles = [];
    for (String ingredient in ingredients) {
      if(await ArticleDatabase.getArticle(ingredient) == null) {
       articles.add(ingredient);
      }
    }
    return articles;
  }

  static Future<void> subtractIngredients(List<String> ingredients) async {
     for (String ingredient in ingredients) {
      Article? article = await ArticleDatabase.getArticle(ingredient);
      if(article != null) {
       await ArticleDatabase.updateArticle(article);
      }
    }
  }

   static Future<void> addIngredients(List<String> ingredients) async {
     for (String ingredient in ingredients) {
      Article? article = await ArticleDatabase.getArticle(ingredient);
      if(article != null) {
       await ArticleDatabase.updateArticle(article);
      }
      else {
        Article newArticle = Article(name: ingredient, currentAmount: 0, dailyUsage: 0, unit: "", rebuyAmount: 0);
        await ArticleDatabase.insertArticle(newArticle);
      }
    }
  }
}