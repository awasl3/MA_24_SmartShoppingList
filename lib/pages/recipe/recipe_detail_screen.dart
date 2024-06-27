import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

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
            Table(
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Name'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Quantity'))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text('Measurement'))),
                ]),
                ...recipe.ingredients.map((ingredient) => TableRow(children: [
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.name))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.amount.toString()))),
                  TableCell(child: Padding(padding: EdgeInsets.all(8), child: Text(ingredient.unit))),
                ])).toList(),
              ],
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
