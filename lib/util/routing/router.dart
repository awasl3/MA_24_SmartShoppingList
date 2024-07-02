import 'package:go_router/go_router.dart';
import 'package:smart_shopping_list/pages/inventory/inventory.dart';
import 'package:smart_shopping_list/pages/recipe/recipe_search_screen.dart';
import 'package:smart_shopping_list/pages/shopping_list/shopping_list.dart';

import 'app_shell.dart';

final routes = ["shopping_list", "inventory", "recipe"];

final GoRouter router = GoRouter(
  initialLocation: '/${routes[0]}',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(
        currentIndex: switch (state.uri.path) {
          var p when p.startsWith('/${routes[1]}') => 1,
          var p when p.startsWith('/${routes[2]}') => 2,
          _ => 0,
        },
        child: child,
      ),
      routes: [
        GoRoute(
          name: routes[0],
          path: "/${routes[0]}",
          pageBuilder: (context, state) =>
              NoTransitionPage(key: state.pageKey, child: const ShoppingList()),
        ),
        GoRoute(
          name: routes[1],
          path: "/${routes[1]}",
          pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey, child: const InventoryPage()),
        ),
        GoRoute(
          name: routes[2],
          path: "/${routes[2]}",
          pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey, child: const RecipeSearchScreen()),
        )
      ],
    ),
  ],
);
