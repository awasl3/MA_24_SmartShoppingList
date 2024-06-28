import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTableHeader extends ConsumerWidget{
  const StockTableHeader({super.key});

 
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool articleDeletion = ref.watch(articleDeletionMode);
    return buildHeader(articleDeletion);
  }

  Widget buildHeader(bool articleDeletion) {
    List<Widget> children = [
      
        FloatingActionButton(
          heroTag: "addButton",
          backgroundColor: Colors.greenAccent,
          child: const Icon( Icons.add),
          onPressed: (){})
    ];
    if(articleDeletion) {
      children.add(
        FloatingActionButton(
          heroTag: "deletionButton",
          backgroundColor: Colors.redAccent,
          child: const Icon( Icons.delete_forever),
          onPressed: (){})
      );
    }
    return Padding(padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        const Text("Current Stock",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        OverflowBar(
          alignment: MainAxisAlignment.start,
          spacing: 5,
          children: children,
        )
      ]
      
        
      ));
  }


  
}