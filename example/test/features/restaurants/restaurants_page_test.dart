import 'package:example/src/widgets/gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_test_utils/flutter_image_test_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';
import 'package:example/src/features/restaurants/restaurants_page.dart';
import 'package:example/src/features/restaurants/restaurants_vm.dart';
import 'package:example/src/widgets/widgets.dart';

import '../../app_wrapper.dart';
import '../../mocks.mocks.dart';
import 'restaurants_tests_helper.dart';

class MockRestaurantsMVVM
    extends MVVM<RestaurantsModel, RestaurantsView, RestaurantsVM> {
  const MockRestaurantsMVVM({required super.viewModel, super.key})
    : super(view: const RestaurantsView());
}

void main() {
  group('RestaurantsPage', () {
    late final MockRestaurantsVM vm;
    late Widget uut;
    const modelInit = RestaurantsModel(viewStatus: viewStatusSuccess);
    var model = modelInit;
    final restaurants = [
      RestaurantsTestHelper.buildDummyRestaurant('1'),
      RestaurantsTestHelper.buildDummyRestaurant('2'),
    ];

    setUpAll(() {
      vm = MockRestaurantsVM();
      when(vm.state).thenAnswer((_) => model);
    });

    setUp(() => uut = AppWrapper(child: MockRestaurantsMVVM(viewModel: vm)));

    tearDown(() => model = modelInit);

    testWidgets('should renders the page', (tester) async {
      await tester.pumpWidget(uut);
      expect(find.byType(RestaurantsView), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text('Restaurants Feature'), findsOneWidget);
    });

    testWidgets(
      'should reset location when location is invalid and button is pressed',
      (tester) async {
        model = model.copyWith(isInvalidLocation: true);
        await tester.pumpWidget(uut);
        expect(find.text('User Location is invalid: '), findsOneWidget);
        expect(find.byType(AppButton), findsOneWidget);
        expect(find.text('Reset'), findsOneWidget);
        await tester.tap(find.byType(AppButton));
        await tester.pump();
        verify(vm.resetLocation()).called(1);
      },
    );

    testWidgets(
      'should show a loading reset button when location is invalid and view is loading',
      (tester) async {
        model = model.copyWith(
          viewStatus: viewStatusLoading,
          isInvalidLocation: true,
        );
        await tester.pumpWidget(uut);
        expect(find.text('User Location is invalid: '), findsOneWidget);
        final buttonFinder = find.byType(AppButton);
        expect(buttonFinder, findsOneWidget);
        final buttonWidget = tester.widget<AppButton>(buttonFinder);
        expect(buttonWidget.isLoading, true);
      },
    );

    testWidgets('should show the user location and forward walking image', (
      tester,
    ) async {
      model = model.copyWith(
        userLocation: const LocationEntity(latitude: 3, longitude: 5),
      );
      await tester.pumpWidget(uut);
      expect(
        find.text('User Location (latitude: 3.0, longitude: 5.0)'),
        findsOneWidget,
      );
      final gifWidget = tester.widget<Gif>(find.byType(Gif));
      expect(gifWidget.isFlippedHorizontally, false);
    });

    testWidgets('should show the user location and backward walking image', (
      tester,
    ) async {
      model = model.copyWith(
        userLocation: const LocationEntity(latitude: 3, longitude: 5),
        isUserDirectionForward: false,
      );
      await tester.pumpWidget(uut);
      final gifWidget = tester.widget<Gif>(find.byType(Gif));
      expect(gifWidget.isFlippedHorizontally, true);
    });

    testWidgets('should show the list of restaurants', (tester) async {
      final restaurants = [
        RestaurantsTestHelper.buildDummyRestaurant('1'),
        RestaurantsTestHelper.buildDummyRestaurant('2'),
      ];
      model = model.copyWith(restaurants: restaurants);
      await provideMockedNetworkImages(() => tester.pumpWidget(uut));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
    });

    testWidgets('should show a loading text when view is loading', (
      tester,
    ) async {
      model = model.copyWith(
        restaurants: restaurants,
        viewStatus: viewStatusLoading,
      );
      await tester.pumpWidget(uut);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('should set a restaurant as favourite', (tester) async {
      model = model.copyWith(restaurants: restaurants);
      await provideMockedNetworkImages(() => tester.pumpWidget(uut));
      await tester.tap(find.byType(IconButton).first);
      await tester.pump();
      verify(vm.setFavourite(any, any)).called(1);
    });
  });
}
