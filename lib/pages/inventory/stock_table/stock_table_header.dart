import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTableHeader extends ConsumerWidget{
 
  static List<DataColumn> getTableHeader(WidgetRef ref) {
    return [
      const DataColumn(label: Text("Name")),
      const DataColumn(label: Text("Current Amount")),
      const DataColumn(label: Text("Daily Usage")),
       DataColumn(label: 
          Center(child:
          MaterialButton(
          minWidth: 0,
  onPressed: () {
     ref.watch(articleCreation.notifier).state =  true;
  },
  elevation: 2.0,
  color: Colors.green.withOpacity(0.8),
  shape: const CircleBorder(),
  child: const Icon(
    Icons.add,
  ),
),
        
      ))
      
    ];
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("Current Stock",style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)));
  }
  
}