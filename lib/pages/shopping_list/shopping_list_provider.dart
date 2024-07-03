import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/shopping_list/items/item_database.dart';
import 'package:smart_shopping_list/util/database/article_database/article_databse.dart';
import 'package:smart_shopping_list/util/routing/provider/providers.dart';

import '../inventory/stock/article_database.dart';
import 'items/item.dart';

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Item>>(
        (ref) => ShoppingListNotifier(ref));

class ShoppingListNotifier extends StateNotifier<List<Item>> {
  final Ref ref;

  ShoppingListNotifier(this.ref) : super([]) {
    _loadItems();
  }

  void _loadItems() async {
    final items = await ItemDatabase.getAllItems();
    state = items;
  }

  void toggleChecked(Item item) {
    item.checked = !item.checked;
    ItemDatabase.updateItem(item);
    state = List.from(state);
  }

  void _deleteItems(List<Item> items) {
    for (var item in items) {
      deleteItem(item);
    }
  }

  void deleteCheckedItems() {
    _deleteItems(state.where((item) => item.checked).toList());
  }

  void addCheckedItemsToInventory() async {
    final checkedItems = state.where((item) => item.checked).toList();

    for (var item in checkedItems) {
      final article = await GetIt.I.get<ArticleDatabse>().getArticle(item.name);
      if (article != null) {
        GetIt.I.get<ArticleDatabse>().updateArticle(Article(
            name: article.name,
            currentAmount: article.currentAmount + item.amount,
            dailyUsage: article.currentAmount,
            unit: article.unit,
            rebuyAmount: article.rebuyAmount));
      }

      GetIt.I.get<ArticleDatabse>().insertArticle(Article(
          name: item.name,
          currentAmount: item.amount,
          dailyUsage: 0,
          unit: item.unit,
          rebuyAmount: item.amount));
    }

    ref.read(articlesChanged.notifier).state = !ref.read(articlesChanged);

    _deleteItems(checkedItems);
  }

  void addItem(Item newItem) {
    ItemDatabase.insertArticle(newItem);
    state = [...state, newItem];
  }

  void editItem(Item updatedItem) {
    ItemDatabase.updateItem(updatedItem);
    _loadItems();
  }

  void deleteItem(Item item) {
    ItemDatabase.deleteItem(item.name);
    state = state.where((i) => i != item).toList();
  }
}
