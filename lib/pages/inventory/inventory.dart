import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(articlesChanged);
    return Scaffold(
        appBar: AppBar(title: const Center(child: Text("Current Stock"))),
        body: Center(
            child: FutureBuilder<List<Article>>(
                future: getAllArticles(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    List<Article> articles = snapshot.data!;
                    return StockTable(articles: articles);
                  }

                  return const CircularProgressIndicator();
                })));
  }

  Future<List<Article>> getAllArticles() async {
    //ArticleDatabase.insertArticle(Article(name: "name "+ Random().nextInt(100).toString(), currentAmount: 3.0, dailyUsage: 1, unit: "Liter", rebuyAmount: 1.0));
    return await GetIt.I.get<ArticleDatabse>().getAllArticles();
  }
}
