import 'package:smart_shopping_list/pages/shopping_list/items/item.dart';
import 'package:sqflite/sqflite.dart';

import '../../../main.dart';

class ItemDatabase {
  static Future<void> insertArticle(Item item) async {
    final db = await database;
    await db.insert(
      'shopping_list',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Item>> getAllItems() async {
    final db = await database;

    final List<Map<String, Object?>> itemsMap = await db.query('shopping_list');
    return [
      for (final {
            'name': name as String,
            'amount': amount as double,
            'unit': unit as String,
            'checked': checked as int
          } in itemsMap)
        Item(name: name, amount: amount, unit: unit, checked: checked == 1),
    ];
  }

  static Future<void> updateItem(Item item) async {
    final db = await database;

    await db.update(
      'shopping_list',
      item.toMap(),
      where: 'name = ?',
      whereArgs: [item.name],
    );
  }

  static Future<void> deleteItem(String name) async {
    final db = await database;
    await db.delete(
      'shopping_list',
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  static Future<Item?> getItem(String name) async {
    final db = await database;
    List<Map<String, Object?>> result =
        await db.query('shopping_list', where: 'name = ?', whereArgs: [name]);
    if (result.isEmpty) {
      return null;
    }
    final item = result.first;
    return Item(
      name: item['name'] as String,
      amount: item['amount'] as double,
      unit: item['unit'] as String,
      checked: item['checked'] == 1,
    );
  }
}
