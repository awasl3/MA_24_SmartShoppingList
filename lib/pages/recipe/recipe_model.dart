class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
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
    List<String> ingredients = [];
    if (json['extendedIngredients'] != null) {
      json['extendedIngredients'].forEach((ingredient) {
        ingredients.add(ingredient['original']);
      });
    }

    return Recipe(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'] ?? '',
      ingredients: ingredients,
      instructions: json['instructions'] ?? '',
      readyInMinutes: json['readyInMinutes'] ?? 0,
    );
  }
}
