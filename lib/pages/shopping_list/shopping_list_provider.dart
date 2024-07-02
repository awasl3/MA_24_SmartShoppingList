import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/pages/inventory/stock/article.dart';
import 'package:smart_shopping_list/pages/shopping_list/items/item_database.dart';
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
    state = List.from(state); // Trigger a state update
  }

  void _deleteItems(List<Item> items) {
    for (var item in items) {
      ItemDatabase.deleteItem(item.name);
    }
    state = state.where((item) => !item.checked).toList();
  }

  void deleteCheckedItems() {
    _deleteItems(state.where((item) => item.checked).toList());
  }

  void addCheckedItemsToInventory() async {
    final checkedItems = state.where((item) => item.checked).toList();

    for (var item in checkedItems) {
      final article = await ArticleDatabase.getArticle(item.name);
      if (article != null) {
        ArticleDatabase.updateArticle(Article(
            name: article.name,
            currentAmount: article.currentAmount + item.amount,
            dailyUsage: article.currentAmount,
            unit: article.unit,
            rebuyAmount: article.rebuyAmount,
            lastUsage: article.lastUsage));
      }

      ArticleDatabase.insertArticle(Article(
          name: item.name,
          currentAmount: item.amount,
          dailyUsage: 0,
          unit: item.unit,
          rebuyAmount: item.amount,
          lastUsage: Article.resetUsage()));
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
    _loadItems(); // Reload the items to reflect the changes
  }
}
