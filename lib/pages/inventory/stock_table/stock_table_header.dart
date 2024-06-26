import 'package:flutter/material.dart';

class StockTableHeader {
 
  static List<DataColumn> getTableHeader() {
    return [
      const DataColumn(label: Text("Name")),
      const DataColumn(label: Text("Current Amount")),
      const DataColumn(label: Text("Daily Usage")),
      const DataColumn(label: Text("Unit")),
      const DataColumn(label: Text("Rebuy Amount")),
      const DataColumn(label: Text("Edit")),
    ];
  }
  
}