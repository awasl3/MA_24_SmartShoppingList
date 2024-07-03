import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_dialog.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class ArticleCell extends ConsumerWidget {
  final Article article;

  const ArticleCell({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Article> selectedArticles = ref.watch(articleDeletionSelection);
    bool deletionMode = ref.watch(articleDeletionMode);

    late final String amountText;

    if (article.dailyUsage > 0) {
      amountText =
          '${article.currentAmount} ${article.unit} @ ${article.dailyUsage} ${article.unit}/day';
    } else {
      amountText = '${article.currentAmount} ${article.unit}';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: getColor(selectedArticles),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onLongPress: () {
          ref.read(articleDeletionMode.notifier).state = true;
          ref.watch(articleDeletionSelection.notifier).state.add(article);
        },
        onTap: () {
          if (deletionMode) {
            if (selectedArticles.contains(article)) {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return state.where((i) => i != article).toList();
              });
              print(ref.watch(articleDeletionSelection));
              if (ref.watch(articleDeletionSelection).isEmpty) {
                ref.read(articleDeletionMode.notifier).state = false;
              }
            } else {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return [...state, article];
              });
            }
          } else {
            ArticleDialog(article: article, context: context, ref: ref)
                .showArticleDialog();
          }
        },
        child: ListTile(
          title: Text(article.name, style: const TextStyle(fontSize: 20)),
          subtitle: Text(amountText),
          trailing: selectedArticles.contains(article)
              ? const Icon(Icons.close, size: 40)
              : null,
        ),
      ),
    );
  }

  Color? getColor(List<Article> selectedArticles) {
    if (article.currentAmount >= 4 * article.dailyUsage) {
      return null;
    } else if (article.currentAmount >= 2 * article.dailyUsage) {
      return Colors.amberAccent.shade100;
    } else {
      return Colors.redAccent;
    }
  }
}
