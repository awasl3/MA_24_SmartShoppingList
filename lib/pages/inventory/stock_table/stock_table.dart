import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/pages/inventory/stock/stock.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_row.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/stock_table_header.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTable extends ConsumerWidget {
  final List<Article> articles;
  const StockTable({super.key, required this.articles});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Article? article = ref.watch(articleToBeDeleted);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
    if(article != null) {
      await showDialog<String>(context: 
      context, builder: (context) => 
      AlertDialog(
        title:  Text("Article ${article.name} deletion"),
        content:  Text('Are you sure, you want to deleted article ${article.name} from the stock.\nThis action can not be undone'),
        actions: <Widget>[
            TextButton(
              onPressed: () {
                ref.watch(articleToBeDeleted.notifier).state = null;
                Navigator.pop(context, 'Cancel');
                },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                ref.watch(articleToBeDeleted.notifier).state = null;
                ArticleDatabase.deleteArticle(article.name);
                ref.watch(articlesChanged.notifier).state = !ref.watch(articlesChanged);
                Navigator.pop(context, 'Confirm');
              },
              child: const Text('Confirm'),
            ),
          ],

      )
      );
      print(article.name);
    }
  });
     
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
      columns: StockTableHeader.getTableHeader()
    , rows: List<DataRow>.generate(
      articles.length,
       (index) => ArticleRow(article: articles[index],index: index,ref:ref).generate()
    )
    ));
  }
  
 


  
}
