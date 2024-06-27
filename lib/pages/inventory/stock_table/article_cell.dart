import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';

class ArticleCell extends ConsumerWidget {
  final Article article;
  const ArticleCell({super.key,required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(),color: getColor() , borderRadius: BorderRadius.all(Radius.circular(30))),
      child: 
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(article.name,style: TextStyle(fontSize: 30)),
        Text("${article.currentAmount} ${article.unit}")
      ]
    ));
  }


  Color getColor() {
    if(article.currentAmount >= 4 * article.dailyUsage) {
      return Colors.green.withOpacity(0.8);
    }
    else if(article.currentAmount >= 2 * article.dailyUsage) {
      return Colors.amber.withOpacity(0.8);
    }
    else {
      return Colors.red.withOpacity(0.8);
    }
  }
  
}