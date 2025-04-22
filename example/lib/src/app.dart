// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:example/src/core/injection.dart';
import 'package:example/src/router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: inject<AppRouter>().router,
    );
  }
}
