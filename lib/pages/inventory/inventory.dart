import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

import 'stock/article_dialog.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(articlesChanged);
    bool deletionMode = ref.watch(articleDeletionMode);
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Current Stock'))),
      body: FutureBuilder<List<Article>>(
        future: getAllArticles(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Article> articles = snapshot.data!;
            return StockTable(articles: articles);
          }

          return const CircularProgressIndicator();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: deletionMode
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (deletionMode)
              FloatingActionButton(
                  heroTag: 'deletionButton',
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.delete_forever),
                  onPressed: () {
                    deleteSelectedArticles(ref, context);
                  }),
            FloatingActionButton(
                heroTag: 'addButton',
                child: const Icon(Icons.add),
                onPressed: () {
                  ArticleDialog(article: null, context: context, ref: ref)
                      .showArticleDialog();
                }),
          ],
        ),
      ),
    );
  }

  Future<List<Article>> getAllArticles() async {
    //ArticleDatabase.insertArticle(Article(name: "name "+ Random().nextInt(100).toString(), currentAmount: 3.0, dailyUsage: 1, unit: "Liter", rebuyAmount: 1.0));
    return await GetIt.I.get<ArticleDatabse>().getAllArticles();
  }

  void deleteSelectedArticles(WidgetRef ref, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Articles'),
              content: const Text(
                  'Are you sure, you want to deleted the selected articles from the stock.\n! This action can not be undone !'),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }),
                ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Confirm'),
                    onPressed: () async {
                      List<Article> articles =
                          ref.read(articleDeletionSelection);
                      for (Article article in articles) {
                        await ArticleDatabase.deleteArticle(article.name);
                      }
                      ref.read(articleDeletionMode.notifier).state = false;
                      ref.read(articleDeletionSelection.notifier).state = [];
                      ref.read(articlesChanged.notifier).state =
                          !ref.read(articlesChanged);
                      Navigator.pop(context, 'Confirm');
                    })
              ],
            ));
  }
}
