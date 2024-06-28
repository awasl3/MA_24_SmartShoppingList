import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    return GestureDetector(
        onTap: (){
          if(deletionMode) {
            if(selectedArticles.contains(article)) {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return state.where((i) => i != article).toList();
              });
              print(ref.watch(articleDeletionSelection));
              if(ref.watch(articleDeletionSelection).isEmpty) {
                ref.read(articleDeletionMode.notifier).state = false;
              }
            } 
            else {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return [...state, article];
              });
              
              
            }
          }
          else {
            ArticleDialog(article: article,context: context,ref: ref).showArticleDialog();
          }
        },
        onLongPress: () {
          ref.read(articleDeletionMode.notifier).state = true;
          ref.watch(articleDeletionSelection.notifier).state.add(article);
        },
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(),
                color: getColor(selectedArticles),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(article.name,
                  style: TextStyle(
                      fontSize: 30,
                      decoration: selectedArticles.contains(article)
                          ? TextDecoration.lineThrough
                          : null)),
              Text(
                "${article.currentAmount} ${article.unit}",
                style: selectedArticles.contains(article)
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ])));
  }

  Color getColor(List<Article> selectedArticles) {
    if (selectedArticles.contains(article)) {
      return Colors.red;
    }
    if (article.currentAmount >= 4 * article.dailyUsage) {
      return Colors.green.withOpacity(0.8);
    } else if (article.currentAmount >= 2 * article.dailyUsage) {
      return Colors.amber.withOpacity(0.8);
    } else {
      return Colors.red.withOpacity(0.8);
    }
  }
}
