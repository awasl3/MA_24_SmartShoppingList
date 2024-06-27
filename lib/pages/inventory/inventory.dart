import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(articlesChanged);
    return  FutureBuilder<List<Article>>(
            future: getAllArticles(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Article> articles = snapshot.data!;
                return StockTable(articles: articles);
              }

              return const CircularProgressIndicator();
            });
  }

  Future<List<Article>> getAllArticles() async {
    return await ArticleDatabase.getAllArticles();
  }
}
