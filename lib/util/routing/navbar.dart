import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_shopping_list/util/routing/router.dart';

class NavBar extends ConsumerWidget {
  final int currentPage;
  const NavBar({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationBar(
      onDestinationSelected: (value) => context.goNamed(routes[value]),
      indicatorColor: Colors.deepPurple,
      selectedIndex: currentPage,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(
            MaterialSymbols.shopping_cart_filled,
          ),
          icon: Icon(MaterialSymbols.shopping_cart_outlined),
          label: 'Shopping list',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            MaterialSymbols.inventory_2_filled,
          ),
          icon: Icon(MaterialSymbols.inventory_2_outlined),
          label: 'Inventory',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            MaterialSymbols.order_approve_filled,
          ),
          icon: Icon(MaterialSymbols.order_approve_outlined),
          label: 'Recipe',
        ),
      ],
    );
  }
}
