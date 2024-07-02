import 'package:flutter/material.dart';
import 'recipe_service.dart';
import 'recipe_model.dart';
import 'recipe_detail_screen.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipes =
          await _recipeService.searchRecipes(_searchController.text);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching recipes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Recipe Search')),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for recipes',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchRecipes,
                ),
              ),
              onSubmitted: (_) => _searchRecipes(),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            if (_recipes.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return GestureDetector(
                      onTap: () async {
                        RecipeService recipeService = RecipeService();
                        try {
                          Recipe detailedRecipe =
                              await recipeService.getRecipeDetails(recipe.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipe: detailedRecipe,
                              ),
                            ),
                          );
                        } catch (e) {
                          print('Error fetching recipe details: $e');
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            recipe.imageUrl.isNotEmpty
                                ? Image.network(recipe.imageUrl,
                                    height: 200, fit: BoxFit.cover)
                                : const SizedBox(
                                    height: 200,
                                    child: Center(
                                        child: Text('No image available')),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipe.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
