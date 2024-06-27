class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final String instructions;
  final int readyInMinutes;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.readyInMinutes,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];
    if (json['extendedIngredients'] != null) {
      json['extendedIngredients'].forEach((ingredient) {
        ingredients.add(Ingredient.fromJson(ingredient));
      });
    }

    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No title',
      imageUrl: json['image'] ?? '',
      ingredients: ingredients,
      instructions: json['instructions'] ?? 'No instructions available',
      readyInMinutes: json['readyInMinutes'] ?? 0,
    );
  }
}

class Ingredient {
  final String name;
  final double amount;
  final String unit;

  Ingredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? 'Unknown',
      amount: (json['amount'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }
}
