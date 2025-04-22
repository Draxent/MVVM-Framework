import 'package:example/src/features/basic/basic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:example/src/features/home/home_page.dart';
import 'package:example/src/features/counter/counter_page.dart';
import 'package:example/src/features/restaurants/restaurants_page.dart';
import 'package:example/src/features/integrated/integrated_page.dart';

import '../../app_wrapper.dart';
import '../../mocks.mocks.dart';

void main() {
  late MockAppRouter router;

  late Widget uut;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    router = MockAppRouter();
    when(router.push(any)).thenAnswer((_) async {});
  });

  setUp(() {
    uut = AppWrapper(child: HomePage(router));
  });

  testWidgets(
    'should have a button that navigates to BasicPage',
    (tester) => _testButtonNavigation(
      tester,
      uut,
      router,
      'Basic Feature',
      BasicPage.name,
    ),
  );

  testWidgets(
    'should have a button that navigates to CounterPage',
    (tester) => _testButtonNavigation(
      tester,
      uut,
      router,
      'Counter Feature',
      CounterPage.name,
    ),
  );

  testWidgets(
    'should have a button that navigates to RestaurantsPage',
    (tester) => _testButtonNavigation(
      tester,
      uut,
      router,
      'Restaurants Feature',
      RestaurantsPage.name,
    ),
  );

  testWidgets(
    'should have a button that navigates to IntegratedPage',
    (tester) => _testButtonNavigation(
      tester,
      uut,
      router,
      'Integrated Feature',
      IntegratedPage.name,
    ),
  );
}

Future<void> _testButtonNavigation(
  WidgetTester tester,
  Widget uut,
  MockAppRouter router,
  String buttonLabel,
  String pageName,
) async {
  await tester.pumpWidget(uut);
  final buttonFinder = find.text(buttonLabel);
  expect(buttonFinder, findsOneWidget);

  await tester.tap(buttonFinder);
  await tester.pumpAndSettle();
  verify(router.push(pageName)).called(1);
}
