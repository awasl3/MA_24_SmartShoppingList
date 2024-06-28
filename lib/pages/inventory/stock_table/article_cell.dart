import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class ArticleCell extends ConsumerWidget {
  final Article article;
  final int index;
  const ArticleCell({super.key, required this.article, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<int> selectedArticles = ref.watch(articleDeletionSelection);
    bool deletionMode = ref.watch(articleDeletionMode);
    return GestureDetector(
        onTap: (){
          if(deletionMode) {
            if(selectedArticles.contains(index)) {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return state.where((i) => i != index).toList();
              });
              print(ref.watch(articleDeletionSelection));
              if(ref.watch(articleDeletionSelection).isEmpty) {
                ref.read(articleDeletionMode.notifier).state = false;
              }
            } 
            else {
              ref.read(articleDeletionSelection.notifier).update((state) {
                return [...state, index];
              });
              
              
            }
          }
        },
        onLongPress: () {
          ref.read(articleDeletionMode.notifier).state = true;
          ref.watch(articleDeletionSelection.notifier).state.add(index);
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
                      decoration: selectedArticles.contains(index)
                          ? TextDecoration.lineThrough
                          : null)),
              Text(
                "${article.currentAmount} ${article.unit}",
                style: selectedArticles.contains(index)
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
            ])));
  }

  Color getColor(List<int> selectedArticles) {
    if (selectedArticles.contains(index)) {
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
