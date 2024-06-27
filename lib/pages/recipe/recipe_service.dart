import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class RecipeService {
  final String _apiKey = '1b408c235450460a81bca9ee05e43aa7';
  final String _baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/complexSearch?query=$query&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Recipe> getRecipeDetails(int? recipeId) async {
    if (recipeId == null) {
      throw Exception('Invalid recipe ID');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/$recipeId/information?apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
