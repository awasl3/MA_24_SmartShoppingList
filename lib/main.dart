import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/stock.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse_impl.dart';
import 'package:smart_shopping_list/util/database/database/database_instance_impl.dart';
import 'package:smart_shopping_list/util/database/database/databse_instance.dart';
import 'package:smart_shopping_list/util/routing/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<DatabaseInstance>(DatabaseInstanceImpl());
  GetIt.I.registerSingleton<ArticleDatabse>(ArticleDatabaseImpl());
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
