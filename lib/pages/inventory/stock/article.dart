class Article {
  final String name;
  final double currentAmount;
  final double dailyUsage;
  final String unit;
  final double rebuyAmount;

  Article(
      {required this.name,
      required this.currentAmount,
      required this.dailyUsage,
      required this.unit,
      required this.rebuyAmount});

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'currentAmount': currentAmount,
      'dailyUsage': dailyUsage,
      'unit': unit,
      'rebuyAmount': rebuyAmount
    };
  }

  @override
  String toString() {
    return 'Article{name: $name, currentAmount: $currentAmount, dailyUsage: $dailyUsage, unit: $unit, rebuyAmount: $rebuyAmount}';
  }
}
