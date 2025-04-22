import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.page,
    this.floatingActionButton,
    super.key,
  });

  final String title;
  final Widget page;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final bool isTopMostScaffold =
        context.findAncestorWidgetOfExactType<Scaffold>() == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: isTopMostScaffold,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(child: SizedBox(width: 600, child: page)),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
