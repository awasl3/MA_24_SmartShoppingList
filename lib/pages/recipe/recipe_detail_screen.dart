import 'package:flutter/material.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article_database.dart';
import 'recipe_model.dart';

enum IngredientStatus { available, notEnough, missing }

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  Future<Map<String, IngredientStatus>> _fetchInventoryAndCompare() async {
    final inventory = await ArticleDatabase().fetchInventory();
    Map<String, IngredientStatus> ingredientAvailability = {};

    for (var ingredient in recipe.ingredients) {
      if (inventory.containsKey(ingredient.name)) {
        if (inventory[ingredient.name]! >= ingredient.amount) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            recipe.imageUrl.isNotEmpty
                ? Image.network(recipe.imageUrl)
                : SizedBox(height: 200, child: Center(child: Text('No image available'))),
            SizedBox(height: 16),
            Text('Ready in ${recipe.readyInMinutes} minutes', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Ingredients', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            FutureBuilder<Map<String, IngredientStatus>>(
              future: _fetchInventoryAndCompare(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final ingredientAvailability = snapshot.data!;
                  return Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Name'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Quantity'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Measurement'))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Status'))),
                      ]),
                      ...recipe.ingredients.map((ingredient) => TableRow(children: [
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.name))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.amount.toString()))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.unit))),
                        TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(
                          ingredientAvailability[ingredient.name] == IngredientStatus.available
                              ? 'Available'
                              : ingredientAvailability[ingredient.name] == IngredientStatus.notEnough
                                  ? 'Not Enough'
                                  : 'Missing',
                        ))),
                      ])).toList(),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Text('Instructions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(recipe.instructions),
          ],
        ),
      ),
    );
  }
}