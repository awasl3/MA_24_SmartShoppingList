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
            ...recipe.ingredients.map((ingredient) => Text(ingredient)).toList(),
            SizedBox(height: 16),
            Text('Instructions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            recipe.instructions != null
                ? Text(recipe.instructions!)
                : Text('No instructions available'),
          ],
        ),
      ),
    );
  }
}
