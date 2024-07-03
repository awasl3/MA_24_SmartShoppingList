import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock_table/article_cell.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class StockTable extends ConsumerWidget {
  final List<Article> articles;

  const StockTable({super.key, required this.articles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    articles.sort((a, b) {
      double a1 = a.currentAmount;
      if (a.currentAmount == 0.0 && a.dailyUsage == 0.0) {
        a1 = double.infinity;
      }
      double a2 = a.dailyUsage != 0.0 ? a.dailyUsage : double.minPositive;

      double b1 = b.currentAmount;
      if (b.currentAmount == 0.0 && b.dailyUsage == 0.0) {
        b1 = double.infinity;
      }

      double b2 = b.dailyUsage != 0.0 ? b.dailyUsage : double.minPositive;

      double aDaysLeft = a1 / a2;
      double bDaysLeft = b1 / b2;

      return (a1 / a2).compareTo(b1 / b2);
    });

    return Scrollbar(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              ...articles.map((article) => ArticleCell(article: article)),
              const SizedBox(height: 90),
            ])));
  }

  void buildDeletionDialog(BuildContext context, WidgetRef ref) {
    Article? article = ref.watch(articleToBeDeleted);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (article != null) {
        await showDialog<String>(
            context: context,
            builder: (context) => PopScope(
                onPopInvoked: (didPop) {
                  if (didPop) {
                    ref.watch(articleToBeDeleted.notifier).state = null;
                  }
                },
                child: AlertDialog(
                  title: Text('Article ${article.name} deletion'),
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
                        await GetIt.I
                            .get<ArticleDatabse>()
                            .deleteArticle(article.name);
                        ref.watch(articlesChanged.notifier).state =
                            !ref.watch(articlesChanged);
                        ref.watch(articleToBeDeleted.notifier).state = null;
                        Navigator.pop(context, 'Confirm');
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                )));
      }
    });
  }

  void buildEditDialog(BuildContext context, WidgetRef ref) {
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
            builder: (context) => PopScope(
                onPopInvoked: (didPop) {
                  if (didPop) {
                    ref.watch(articleToBeEdited.notifier).state = null;
                  }
                },
                child: AlertDialog(
                  scrollable: true,
                  title: Text('Article ${article.name} editor'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            labelText: 'Name',
                            hintText: 'Please provide a name for the article'),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            labelText: 'Current Amount',
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
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            labelText: 'Daily usage',
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
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            labelText: 'Unit',
                            hintText: 'Please provide a unit for the article'),
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
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000))),
                            labelText: 'Rebuy amount',
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
                  ),
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
                        if (name != article.name) {
                          await GetIt.I
                              .get<ArticleDatabse>()
                              .deleteArticle(article.name);
                          Article updated = Article(
                              name: name,
                              currentAmount: currentAmount,
                              dailyUsage: dailyUsage,
                              unit: unit,
                              rebuyAmount: rebuyAmount);
                          await GetIt.I
                              .get<ArticleDatabse>()
                              .insertArticle(updated);
                        } else {
                          Article updated = Article(
                              name: article.name,
                              currentAmount: currentAmount,
                              dailyUsage: dailyUsage,
                              unit: unit,
                              rebuyAmount: rebuyAmount);
                          await GetIt.I
                              .get<ArticleDatabse>()
                              .updateArticle(updated);
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

  void buildCreateDialog(BuildContext context, WidgetRef ref) {
    bool open = ref.watch(articleCreation);
    if (!open) {
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      String name = '';
      double currentAmount = 0;
      double dailyUsage = 0;
      String unit = '';
      double rebuyAmount = 0;
      await showDialog<String>(
          context: context,
          builder: (context) => PopScope(
              onPopInvoked: (didPop) {
                if (didPop) {
                  ref.watch(articleCreation.notifier).state = false;
                }
              },
              child: AlertDialog(
                scrollable: true,
                title: const Text('Article creator'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000))),
                          labelText: 'Name',
                          hintText: 'Please provide a name for the article'),
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
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000))),
                          labelText: 'Current Amount',
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
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000))),
                          labelText: 'Daily usage',
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
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000))),
                          labelText: 'Unit',
                          hintText: 'Please provide a unit for the article'),
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
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(1000))),
                          labelText: 'Rebuy amount',
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
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      ref.watch(articleCreation.notifier).state = false;
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: name.isNotEmpty && unit.isNotEmpty
                        ? () async {
                            Article updated = Article(
                                name: name,
                                currentAmount: currentAmount,
                                dailyUsage: dailyUsage,
                                unit: unit,
                                rebuyAmount: rebuyAmount);
                            await GetIt.I
                                .get<ArticleDatabse>()
                                .insertArticle(updated);
                            ref.watch(articleCreation.notifier).state = false;
                            ref.watch(articlesChanged.notifier).state =
                                !ref.watch(articlesChanged);
                            Navigator.pop(context, 'Confirm');
                          }
                        : null,
                    child: const Text('Confirm'),
                  ),
                ],
              )));
    });
  }
}
