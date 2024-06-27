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
    buildDeletionDialog(context, ref);
    buildEditDialog(context, ref);
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: StockTableHeader.getTableHeader(),
          rows: List<DataRow>.generate(
              articles.length,
              (index) =>
                  ArticleRow(article: articles[index], index: index, ref: ref)
                      .generate()),
        ));
  }

  void buildDeletionDialog(BuildContext context, WidgetRef ref) {
    Article? article = ref.watch(articleToBeDeleted);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (article != null) {
        await showDialog<String>(
            context: context,
            builder: (context) =>
            PopScope(
              onPopInvoked: (didPop) {
                if(didPop) {
                  ref.watch(articleToBeDeleted.notifier).state = null;
                }
              },
              child:
             AlertDialog(
                  title: Text("Article ${article.name} deletion"),
                  content: Text(
                      'Are you sure, you want to deleted article ${article.name} from the stock.\nThis action can not be undone'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        ref.watch(articleToBeDeleted.notifier).state = null;
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        ref.watch(articleToBeDeleted.notifier).state = null;
                        await ArticleDatabase.deleteArticle(article.name);
                        ref.watch(articlesChanged.notifier).state =
                            !ref.watch(articlesChanged);
                        Navigator.pop(context, 'Confirm');
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                )));
      }
    });
  }

  void buildEditDialog(BuildContext context, WidgetRef ref)  {
    Article? article = ref.watch(articleToBeEdited);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (article != null) {
        String name = article.name;
        double currentAmount = article.currentAmount;
        double dailyUsage = article.dailyUsage;
        String unit = article.unit;
        double rebuyAmount = article.rebuyAmount;
        await showDialog<String>(
            context: context,
            builder: (context) => 
            PopScope(
              onPopInvoked: (didPop) {
                if(didPop) {
                  ref.watch(articleToBeEdited.notifier).state = null;
                }
              },
              child: AlertDialog(
                  scrollable: true,
                  title: Text("Article ${article.name} editor"),
                  content:
                    Column(
                      mainAxisSize:  MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000))),
                              labelText: "Name",
                              hintText:
                                  'Please provide a name for the article'),
                          initialValue: name,
                          onChanged: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              name = value;
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (String? value) {
                            return (value == null || value.isEmpty)
                                ? 'Name for article must be provided'
                                : null;
                          },
                        ),
                        SizedBox(height: 10),
                         TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000))),
                              labelText: "Current Amount",
                              hintText:
                                  'Please provide the current amount of the article'),
                          initialValue: currentAmount.toString(),
                          onChanged: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              currentAmount = double.parse(value);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (String? value) {
                            return (value == null || value.isEmpty)
                                ? 'Current amount of for article must be provided'
                                : null;
                          },
                        ),
                        SizedBox(height: 10),
                         TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000))),
                              labelText: "Daily usage",
                              hintText:
                                  'Please provide the daily usage of the article'),
                          initialValue: dailyUsage.toString(),
                          onChanged: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              dailyUsage = double.parse(value);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (String? value) {
                            return (value == null || value.isEmpty)
                                ? 'Daily usage of for article must be provided'
                                : null;
                          },
                        )  ,
                        SizedBox(height: 10) ,
                        TextFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000))),
                              labelText: "Unit",
                              hintText:
                                  'Please provide a unit for the article'),
                          initialValue: unit,
                          onChanged: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              unit = value;
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (String? value) {
                            return (value == null || value.isEmpty)
                                ? 'Unit for article must be provided'
                                : null;
                          },
                        ),
                        SizedBox(height: 10),
                         TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1000))),
                              labelText: "Rebuy amount",
                              hintText:
                                  'Please provide the rebuy amount of the article'),
                          initialValue: rebuyAmount.toString(),
                          onChanged: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              rebuyAmount = double.parse(value);
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          validator: (String? value) {
                            return (value == null || value.isEmpty)
                                ? 'Rebuy amount of for article must be provided'
                                : null;
                          },
                        ),                        
                                           ],
                    )
                  ,
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        ref.watch(articleToBeEdited.notifier).state = null;
                        Navigator.pop(context, 'Cancel');
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        ref.watch(articleToBeEdited.notifier).state = null;
                        if(name != article.name) {
                            await ArticleDatabase.deleteArticle(article.name);
                            Article updated = Article(name: name, currentAmount: currentAmount, dailyUsage: dailyUsage, unit: unit, rebuyAmount: rebuyAmount);
                            await ArticleDatabase.insertArticle(updated);
                        }
                        else {
                          Article updated = Article(name: article.name, currentAmount: currentAmount, dailyUsage: dailyUsage, unit: unit, rebuyAmount: rebuyAmount);
                          await ArticleDatabase.updateArticle(updated);
                        }
                        
                        ref.watch(articlesChanged.notifier).state =
                            !ref.watch(articlesChanged);
                        Navigator.pop(context, 'Confirm');
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                )));
      }
    });
  }
}
