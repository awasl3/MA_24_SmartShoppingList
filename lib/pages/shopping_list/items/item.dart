class Item {
  String name;
  double amount;
  String unit;
  bool checked;

  Item(
      {required this.name,
      required this.amount,
      required this.unit,
      this.checked = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'unit': unit,
      'checked': checked ? 1 : 0,
    };
  }
}
