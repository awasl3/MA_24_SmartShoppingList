import 'package:flutter/material.dart';
import 'package:smart_shopping_list/util/routing/navbar.dart';

class ScreenPage extends StatelessWidget {
  final Widget body;
  final int currentPage;

  const ScreenPage({
    super.key,
    required this.body,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: NavBar(currentPage: currentPage),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: body,
    );
  }
}
