class Article {
  final String name;
  final double currentAmount;
  final double dailyUsage;
  final String unit;
  final double rebuyAmount;
  DateTime lastUsage;

  Article({required this.name, required this.currentAmount, required this.dailyUsage, required this.unit, required this.rebuyAmount, required this.lastUsage});

  static DateTime resetUsage() {
    final now = DateTime.now();
    return DateTime(now.year,now.month,now.day);
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'currentAmount': currentAmount,
      'dailyUsage': dailyUsage,
      'unit':unit,
      'rebuyAmount':rebuyAmount,
      'lastUsage':lastUsage.toIso8601String()
          };
  }

  @override
  String toString() {
    return 'Article{name: $name, currentAmount: $currentAmount, dailyUsage: $dailyUsage, unit: $unit, rebuyAmount: $rebuyAmount, lastUsgage: $lastUsage}';
  }



}


