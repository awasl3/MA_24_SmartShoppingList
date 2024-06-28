import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTableHeader extends ConsumerWidget{
  const StockTableHeader({super.key});

 
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 10) ,
    child: OverflowBar(
      
      children: 
      [Text("Current Stock",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        FloatingActionButton(
          backgroundColor: Colors.greenAccent,
          child: Icon( Icons.add),
          onPressed: (){})
      ]));
  }
  
}