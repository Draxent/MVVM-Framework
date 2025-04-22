// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:example/src/core/core.dart';

class MockWidget extends StatelessWidget {
  const MockWidget({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Utils.isUnitTest ? const Placeholder() : child;
  }
}
