import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_shopping_list/pages/inventory/inventory.dart';
import 'package:smart_shopping_list/pages/recipe/recipe_search_screen.dart';
import 'package:smart_shopping_list/pages/screenpage/screen_page.dart';
import 'package:smart_shopping_list/pages/shopping_list/shopping_list.dart';

final routes = ["shopping_list", "inventory", "recipe"];

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (context, state) => buildScreenPage(const ShoppingList(), 0),
      routes: <RouteBase>[
        GoRoute(
            name: routes[0],
            path: routes[0],
            builder: (context, state) =>
                buildScreenPage(const ShoppingList(), 0)),
        GoRoute(
            name: routes[1],
            path: routes[1],
            builder: (context, state) =>
                buildScreenPage(const InventoryPage(), 1)),
        GoRoute(
            name: routes[2],
            path: routes[2],
            builder: (context, state) =>
                buildScreenPage(const RecipeSearchScreen(), 2))
      ]),
]);

Widget buildScreenPage(Widget body, int page) {
  return ScreenPage(body: body, currentPage: page);
}
