import 'package:smart_shopping_list/pages/inventory/stock/article.dart';

abstract class ArticleDatabse {
  Future<void> insertArticle(Article article);

  Future<List<Article>> getAllArticles();

  Future<void> updateArticle(Article article);

  Future<void> deleteArticle(String name);

  Future<Article?> getArticle(String name);
}
