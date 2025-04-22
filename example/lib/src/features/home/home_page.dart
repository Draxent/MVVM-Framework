import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:example/src/features/basic/basic_page.dart';
import 'package:example/src/features/counter/counter_page.dart';
import 'package:example/src/features/restaurants/restaurants_page.dart';
import 'package:example/src/features/integrated/integrated_page.dart';
import 'package:example/src/router.dart';
import 'package:example/src/widgets/widgets.dart';

@injectable
class HomePage extends StatelessWidget {
  const HomePage(this._router) : super(key: const ValueKey(name));

  static const name = 'home';
  static const path = '/';

  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Select the Feature',
      page: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            onPressed: () => _router.push(BasicPage.name),
            label: 'Basic Feature',
          ),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () => _router.push(CounterPage.name),
            label: 'Counter Feature',
          ),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () => _router.push(RestaurantsPage.name),
            label: 'Restaurants Feature',
          ),
          const SizedBox(height: 10),
          AppButton(
            onPressed: () => _router.push(IntegratedPage.name),
            label: 'Integrated Feature',
          ),
        ],
      ),
    );
  }
}
