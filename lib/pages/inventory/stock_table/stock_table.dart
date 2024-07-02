import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table_header.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTable extends ConsumerWidget {
  final List<Article> articles;
  const StockTable({super.key, required this.articles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    articles.sort((a, b) {
      double a1 = a.currentAmount;
      if (a.currentAmount == 0.0 && a.dailyUsage == 0.0) {
        a1 = double.infinity;
      }
      double a2 = a.dailyUsage != 0.0 ? a.dailyUsage : double.minPositive;

      double b1 = b.currentAmount;
      if (b.currentAmount == 0.0 && b.dailyUsage == 0.0) {
        b1 = double.infinity;
      }

      double b2 = b.dailyUsage != 0.0 ? b.dailyUsage : double.minPositive;

      double aDaysLeft = a1 / a2;
      double bDaysLeft = b1 / b2;

      print("$a $aDaysLeft");
      print("$b $bDaysLeft");

      return (a1 / a2).compareTo(b1 / b2);
    });
    return FractionallySizedBox(
        widthFactor: 0.9,
        child: Column(children: [
          const StockTableHeader(),
          Expanded(
              child: ListView.separated(
                  itemCount: articles.length,
                  itemBuilder: (context, index) => ArticleCell(
                        article: articles[index],
                      ),
                  separatorBuilder: (context, index) => const Divider(
                        color: Colors.transparent,
                        thickness: 1,
                      )))
        ]));
  }
}
