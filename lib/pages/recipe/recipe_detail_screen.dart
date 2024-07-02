import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'package:smart_shopping_list/pages/shopping_list/items/item.dart';
import 'package:smart_shopping_list/pages/shopping_list/shopping_list_provider.dart';
import 'recipe_model.dart';

enum IngredientStatus { available, notEnough, missing }

class RecipeDetailScreen extends ConsumerWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  Future<Map<String, IngredientStatus>> _fetchInventoryAndCompare() async {
    Map<String, IngredientStatus> ingredientAvailability = {};

    for (var ingredient in recipe.ingredients) {
      final article = await ArticleDatabase.getArticle(ingredient.name);
      if (article != null) {
        if (article.currentAmount >= ingredient.amount) {
          ingredientAvailability[ingredient.name] = IngredientStatus.available;
        } else {
          ingredientAvailability[ingredient.name] = IngredientStatus.notEnough;
        }
      } else {
        ingredientAvailability[ingredient.name] = IngredientStatus.missing;
      }
    }

    return ingredientAvailability;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              recipe.imageUrl.isNotEmpty
                  ? Image.network(recipe.imageUrl,
                      height: 250, width: double.infinity, fit: BoxFit.cover)
                  : const SizedBox(
                      height: 200,
                      child: Center(child: Text('No image available'))),
              const SizedBox(height: 16),
              Text(
                'Ready in ${recipe.readyInMinutes} minutes',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Ingredients',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, IngredientStatus>>(
                future: _fetchInventoryAndCompare(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final ingredientAvailability = snapshot.data!;
                    return Column(
                      children: [
                        ...recipe.ingredients.map((ingredient) {
                          final status =
                              ingredientAvailability[ingredient.name];
                          final statusText =
                              status == IngredientStatus.available
                                  ? 'Available'
                                  : status == IngredientStatus.notEnough
                                      ? 'Not Enough'
                                      : 'Missing';
                          final statusColor =
                              status == IngredientStatus.available
                                  ? Colors.green
                                  : status == IngredientStatus.notEnough
                                      ? Colors.orange
                                      : Colors.red;

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(ingredient.name),
                              subtitle: Text(
                                  '${ingredient.amount} ${ingredient.unit}'),
                              trailing: Text(statusText,
                                  style: TextStyle(color: statusColor)),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final missingOrNotEnough = recipe.ingredients
                                .where((ingredient) =>
                                    ingredientAvailability[ingredient.name] !=
                                    IngredientStatus.available)
                                .toList();

                            if (missingOrNotEnough.isNotEmpty) {
                              for (var ingredient in missingOrNotEnough) {
                                ref
                                    .read(shoppingListProvider.notifier)
                                    .addItem(Item(
                                      name: ingredient.name,
                                      amount: ingredient.amount,
                                      unit: ingredient.unit,
                                    ));
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Missing items added to shopping list')),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('All ingredients are available')),
                              );
                            }
                          },
                          child:
                              const Text('Add missing items to shopping list'),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              const Text('Instructions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(recipe.instructions),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
