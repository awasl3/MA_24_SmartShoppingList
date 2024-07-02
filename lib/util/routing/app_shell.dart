import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_shopping_list/util/routing/router.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const AppShell({super.key, required this.child, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => context.goNamed(routes[index]),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(MaterialSymbols.shopping_cart_outlined),
            label: 'Shopping List',
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialSymbols.inventory_2_outlined),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialSymbols.order_approve_outlined),
            label: 'Recipe',
          ),
        ],
      ),
    );
  }
}
