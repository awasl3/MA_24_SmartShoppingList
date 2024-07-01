import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

class ArticleDialog {
  final BuildContext context;
  final WidgetRef ref;
  final Article? article;
  ArticleDialog(
      {required this.article, required this.context, required this.ref});

  Future<void> showArticleDialog() async {
    final nameController = TextEditingController();
    final currentAmountController = TextEditingController();
    final dailyUsageController = TextEditingController();
    final unitController = TextEditingController();
    final rebuyAmountController = TextEditingController();

    if (article != null) {
      nameController.text = article!.name;
      currentAmountController.text = article!.currentAmount.toString();
      dailyUsageController.text = article!.dailyUsage.toString();
      unitController.text = article!.unit;
      rebuyAmountController.text = article!.rebuyAmount.toString();
    }

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            bool isConfirmEnabled() {
              return nameController.text.isNotEmpty &&
                  currentAmountController.text.isNotEmpty &&
                  dailyUsageController.text.isNotEmpty &&
                  unitController.text.isNotEmpty &&
                  rebuyAmountController.text.isNotEmpty &&
                  double.tryParse(currentAmountController.text) != null &&
                  double.tryParse(dailyUsageController.text) != null &&
                  double.tryParse(rebuyAmountController.text) != null;
            }

            return AlertDialog(
              title: article == null
                  ? const Text("Create Article")
                  : const Text("Edit Article"),
              content: SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTextInputField(nameController, "Name", setState),
                  const SizedBox(height: 10),
                  buildNumberInputField(
                      currentAmountController, "Current amount", setState),
                  const SizedBox(height: 10),
                  buildNumberInputField(
                      dailyUsageController, "Daily usage", setState),
                  const SizedBox(height: 10),
                  buildTextInputField(unitController, "Unit", setState),
                  const SizedBox(height: 10),
                  buildNumberInputField(
                      rebuyAmountController, "Rebuy amount", setState),
                ],
              )),
              actions: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }),
                ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Confirm"),
                    onPressed: isConfirmEnabled()
                        ? () async {
                            final String name = nameController.text;
                            final double currentAmount =
                                double.tryParse(currentAmountController.text) ??
                                    0.0;
                            final double dailyUsage =
                                double.tryParse(dailyUsageController.text) ??
                                    0.0;
                            final String unit = unitController.text;
                            final double rebuyAmount =
                                double.tryParse(rebuyAmountController.text) ??
                                    0.0;
                            final newArticle = Article(
                              name: name,
                              currentAmount: currentAmount,
                              dailyUsage: dailyUsage,
                              unit: unit,
                              rebuyAmount: rebuyAmount,
                            );

                            if (article == null) {
                              await ArticleDatabase.insertArticle(newArticle);
                            } else {
                              if (article!.name == newArticle.name) {
                                await ArticleDatabase.updateArticle(newArticle);
                              } else {
                                await ArticleDatabase.deleteArticle(
                                    article!.name);
                                await ArticleDatabase.insertArticle(newArticle);
                              }
                            }

                            ref.read(articlesChanged.notifier).state =
                                !ref.read(articlesChanged);
                            Navigator.pop(context, 'Confirm');
                          }
                        : null)
              ],
            );
          });
        });
  }

  Widget buildTextInputField(
      TextEditingController controller, String label, Function setState) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Please provide a ${label.toLowerCase()}',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(1000))),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? '$label must be provided'
            : null;
      },
      onChanged: (text) => setState(() {}),
    );
  }

  Widget buildNumberInputField(
      TextEditingController controller, String label, Function setState) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Please provide a ${label.toLowerCase()}',
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(1000))),
      ),
      autovalidateMode: AutovalidateMode.always,
      validator: (String? value) {
        return (value == null || value.isEmpty)
            ? '$label must be provided'
            : double.tryParse(value) == null
                ? '$label must be a number'
                : null;
      },
      onChanged: (text) => setState(() {}),
    );
  }
}
