import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});
  
  @override
  Widget build(BuildContext context) {
   return FutureBuilder<List<Article>>(
      future: getAllArticles(),
      builder: (ctx, snapshot) {

        if(snapshot.connectionState == ConnectionState.done) {
          String text = "";
          for (var element in snapshot.data!) {
            text += "$element\n"; 
          }
          return  Text(text);       
        }
           
        return const Text('No data available yet...');
      }
    );
  }



  Future<List<Article>> getAllArticles() async {
   
    List<Article> articles = await ArticleDatabase.getAllArticles();
    if(articles.length < 20) {
       Article a = Article(name: "Milk random_${Random().nextInt(100)}", currentAmount: 3.5, dailyUsage: 0.3, unit: "Liter", rebuyAmount: 1.0);
      await ArticleDatabase.insertArticle(a);
    }
    return await ArticleDatabase.getAllArticles();
    
  }
  
}