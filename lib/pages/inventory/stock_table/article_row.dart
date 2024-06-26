import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class ArticleRow {
  final Article article;
  final int index;
  final WidgetRef ref;
  const ArticleRow({required this.article,required this.index,required this.ref});

  DataRow generate() {
    return DataRow(
      color: index.isEven ? MaterialStatePropertyAll(Colors.grey.withOpacity(0.3)): const MaterialStatePropertyAll(null),
      cells: 
    [
      DataCell(Text(article.name)),
      DataCell(Text("${article.currentAmount}")),
      DataCell(Text("${article.dailyUsage}")),
      DataCell(Text(article.unit)),
      DataCell(Text("${article.rebuyAmount}")),
      DataCell(editButtons())
    ]
    );
  }



  Widget editButtons() {
    return  OverflowBar(
      spacing: 0,
      children: [
        MaterialButton(
          minWidth: 0,
  onPressed: () {},
  elevation: 2.0,
  color: Colors.green,
  shape: const CircleBorder(),
  child: const Icon(
    Icons.edit,
  ),
),
MaterialButton(
  minWidth: 0,
  onPressed: () {
    ref.watch(articleToBeDeleted.notifier).state = article;
  },
  elevation: 2.0,
  color: Colors.redAccent,
  shape: const CircleBorder(),
  child: const Icon(
    Icons.delete_forever,
  ),
)
      ],
    );
    
  
  }
  

  
}