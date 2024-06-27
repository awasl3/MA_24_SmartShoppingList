import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class ArticleRow extends ConsumerWidget{
  final Article article;
  const ArticleRow({super.key, required this.article});

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
   return Text(article.name);
  }



  //   DataRow generate() {
//     return DataRow(
//       color: index.isEven ? MaterialStatePropertyAll(Colors.grey.withOpacity(0.3)): const MaterialStatePropertyAll(null),
//       cells: 
//     [
//       DataCell(Text(article.name)),
//       DataCell(Text("${article.currentAmount } ${article.unit}")),
//       DataCell(Text("${article.rebuyAmount} ${article.unit}")),
//       DataCell(editButtons())
//     ]
//     );
//   }



//   Widget editButtons() {
//     return  OverflowBar(
//       spacing: 0,
//       children: [
//         MaterialButton(
//           minWidth: 0,
//   onPressed: () {
//      ref.watch(articleToBeEdited.notifier).state = article;
//   },
//   elevation: 2.0,
//   color: Colors.orange.withOpacity(0.8),
//   shape: const CircleBorder(),
//   child: const Icon(
//     Icons.edit,
//   ),
// ),
// MaterialButton(
//   minWidth: 0,
//   onPressed: () {
//     ref.watch(articleToBeDeleted.notifier).state = article;
//   },
//   elevation: 2.0,
//   color: Colors.red.withOpacity(0.8),
//   shape: const CircleBorder(),
//   child: const Icon(
//     Icons.delete_forever,
//   ),
// )
//       ],
//     );
    
  
//   }
  

  
}