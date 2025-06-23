// coverage:ignore-file

import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:example/src/core/core.dart';
import 'package:example/src/features/home/home_page.dart';
import 'package:example/src/features/counter/counter_page.dart';
import 'package:example/src/features/counter/counter_model.dart';
import 'package:example/src/features/restaurants/restaurants_page.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';
import 'package:example/src/features/integrated/integrated_page.dart';
import 'package:example/src/features/basic/basic_page.dart';
import 'package:example/src/features/integrated/integrated_model.dart';

@singleton
class AppRouter {
  AppRouter()
    : router = GoRouter(
        routes: [
          GoRoute(path: HomePage.path, name: HomePage.name, builder: (_, _) => inject<HomePage>()),
          GoRoute(path: BasicPage.path, name: BasicPage.name, builder: (_, _) => BasicPage()),
          GoRoute(
            path: CounterPage.path,
            name: CounterPage.name,
            builder: (_, _) => CounterPage(model: const CounterModel()),
          ),
          GoRoute(
            path: RestaurantsPage.path,
            name: RestaurantsPage.name,
            builder: (_, _) => RestaurantsPage(model: const RestaurantsModel()),
          ),
          GoRoute(
            path: IntegratedPage.path,
            name: IntegratedPage.name,
            builder: (_, _) => IntegratedPage(model: const IntegratedModel()),
          ),
        ],
      );

  void push(String name) => router.pushNamed(name);

  final GoRouter router;
}
