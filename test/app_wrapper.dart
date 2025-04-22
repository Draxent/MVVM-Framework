import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    ConfigMVVM.initialize(onGenericError: (context) {});
    return MaterialApp(home: Scaffold(body: child));
  }
}
