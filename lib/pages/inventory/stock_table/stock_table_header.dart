import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTableHeader extends ConsumerWidget {
  const StockTableHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool articleDeletion = ref.watch(articleDeletionMode);
    return buildHeader(articleDeletion, ref, context);
  }

  Widget buildHeader(
      bool articleDeletion, WidgetRef ref, BuildContext context) {
    List<Widget> children = [
      FloatingActionButton(
          heroTag: "addButton",
          backgroundColor: Colors.greenAccent,
          child: const Icon(Icons.add),
          onPressed: () {
            ArticleDialog(article: null, context: context, ref: ref)
                .showArticleDialog();
          })
    ];
    if (articleDeletion) {
      children.add(FloatingActionButton(
          heroTag: "deletionButton",
          backgroundColor: Colors.redAccent,
          child: const Icon(Icons.delete_forever),
          onPressed: () {
            deleteSelectedArticles(ref, context);
          }));
    }
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: OverflowBar(
          alignment: MainAxisAlignment.start,
          spacing: 5,
          children: children,
        ));
  }

  void deleteSelectedArticles(WidgetRef ref, BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Articles"),
              content: const Text(
                  'Are you sure, you want to deleted the selected articles from the stock.\n! This action can not be undone !'),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }),
                ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Confirm"),
                    onPressed: () async {
                      List<Article> articles =
                          ref.read(articleDeletionSelection);
                      for (Article article in articles) {
                        await GetIt.I
                            .get<ArticleDatabse>()
                            .deleteArticle(article.name);
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
