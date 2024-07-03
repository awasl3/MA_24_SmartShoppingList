import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_shopping_list/util/widget/input_field.dart';

import 'items/item.dart';
import 'shopping_list_provider.dart';

class ShoppingList extends ConsumerWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(shoppingListProvider);
    final shoppingListNotifier = ref.read(shoppingListProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('Shopping'))),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            ...items.map(
              (item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onLongPress: () => _showAddEditItemDialog(
                      context, shoppingListNotifier,
                      item: item),
                  onTap: () => shoppingListNotifier.toggleChecked(item),
                  child: ListTile(
                    title:
                        Text(item.name, style: const TextStyle(fontSize: 20)),
                    subtitle: Text('${item.amount} ${item.unit}'),
                    trailing: item.checked
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 40,
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 90),
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Row(
          mainAxisAlignment: items.any((item) => item.checked)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (items.any((item) => item.checked)) ...[
              FloatingActionButton(
                onPressed: () => shoppingListNotifier.deleteCheckedItems(),
                tooltip: 'Delete Checked Items',
                backgroundColor: Colors.redAccent,
                child: const Icon(Icons.delete_forever),
              ),
              FloatingActionButton(
                onPressed: () =>
                    shoppingListNotifier.addCheckedItemsToInventory(),
                tooltip: 'Add to Inventory',
                backgroundColor: Colors.greenAccent,
                child: const Icon(Icons.check),
              ),
            ],
            FloatingActionButton(
              onPressed: () =>
                  _showAddEditItemDialog(context, shoppingListNotifier),
              tooltip: 'Add Item',
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddEditItemDialog(
      BuildContext context, ShoppingListNotifier shoppingListNotifier,
      {Item? item}) async {
    final nameController = TextEditingController(text: item?.name ?? '');
    final amountController =
        TextEditingController(text: item?.amount.toString() ?? '');
    final unitController = TextEditingController(text: item?.unit ?? '');

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item == null ? 'Add' : 'Edit'),
                  if (item != null)
                    IconButton(
                      icon: const Icon(Icons.delete_forever),
                      color: Colors.redAccent,
                      onPressed: () {
                        shoppingListNotifier.deleteItem(item);
                        Navigator.of(context).pop();},
                    ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    buildTextInputField(nameController, 'Name', setState),
                    const SizedBox(height: 10),
                    buildNumberInputField(amountController, 'Amount', setState),
                    const SizedBox(height: 10),
                    buildTextInputField(unitController, 'Unit', setState),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,

              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    var newItem = Item(
                      name: nameController.text,
                      amount: double.tryParse(amountController.text) ?? 0,
                      unit: unitController.text,
                      checked: item?.checked ?? false,
                    );

                    if (item == null) {
                      shoppingListNotifier.addItem(newItem);
                    } else {
                      shoppingListNotifier.editItem(newItem);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
