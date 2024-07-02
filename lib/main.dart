
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/pages/inventory/stock/stock.dart';
import 'package:smart_shopping_list/util/database/database_instance.dart';
import 'package:smart_shopping_list/util/routing/router.dart';
import 'package:sqflite/sqflite.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseInstance().database;
  await Stock.subtractDailyUsage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp.router(
      title: 'Smart Shopping List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    ));
  }
}
