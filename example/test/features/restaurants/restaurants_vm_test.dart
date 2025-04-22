import 'dart:async';

import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';
import 'package:example/src/features/restaurants/restaurants_repository.dart';
import 'package:example/src/features/restaurants/restaurants_vm.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

import '../../mocks.mocks.dart';
import 'restaurants_tests_helper.dart';

void main() {
  group('RestaurantsVM', () {
    late final RestaurantsVM uut;
    late final MockRestaurantsRepository restaurantsRepository;
    late final MockUserLocationRepository userLocationRepository;
    late final MockFavouritesStorageService favouritesStorageService;

    const restaurantId = RestaurantId(id: '1');

    setUpAll(() {
      restaurantsRepository = MockRestaurantsRepository();
      userLocationRepository = MockUserLocationRepository();
      favouritesStorageService = MockFavouritesStorageService();
      uut = RestaurantsVM(
        restaurantsRepository,
        userLocationRepository,
        favouritesStorageService,
        const RestaurantsModel(),
      );
    });

    test(
      'should register error handler and listen to user location when initialized',
      () async {
        final streamController = StreamController<(LocationEntity, bool)>();
        when(
          userLocationRepository.watch(),
        ).thenAnswer((_) => streamController.stream);
        await uut.onInit();
        expect(
          uut.errorHandlers.containsKey(ViewStatusInvalidLocationError),
          true,
        );
        verify(userLocationRepository.watch()).called(1);
        streamController.close();
      },
    );

    test(
      'should cancel stream subscription when closing the view model',
      () async {
        final stream = MockStream();
        final streamSubscription = MockStreamSubscription();
        when(userLocationRepository.watch()).thenAnswer((_) => stream);
        when(stream.listen(any)).thenAnswer((_) => streamSubscription);
        final vm = RestaurantsVM(
          restaurantsRepository,
          userLocationRepository,
          favouritesStorageService,
          const RestaurantsModel(),
        );
        await vm.onInit();
        await vm.close();
        verify(streamSubscription.cancel()).called(1);
      },
    );

    test('should resume user location when view status is initial', () {
      uut.listener(const RestaurantsModel(viewStatus: viewStatusInitial));
      verify(userLocationRepository.resume());
    });

    test('should set the restaurant as favourite', () async {
      const value = true;
      await uut.setFavourite(restaurantId, value);
      verify(
        favouritesStorageService.setFavourite(restaurantId.id, value),
      ).called(1);
      expect(uut.state.favourites[restaurantId], value);
    });

    test('should fetch restaurants when location changes', () async {
      const isUserDirectionForward = true;
      final restaurant = RestaurantsTestHelper.buildDummyRestaurant(
        restaurantId.id,
      );
      final restaurants = [restaurant];
      when(
        restaurantsRepository.fetch(locationZero),
      ).thenAnswer((_) async => restaurants);
      when(favouritesStorageService.isFavourite('1')).thenReturn(true);

      await uut.computeRestaurantsBasedOnUserLocation(
        locationZero,
        isUserDirectionForward,
      );

      expect(uut.state.userLocation, locationZero);
      expect(uut.state.isInvalidLocation, false);
      expect(uut.state.isUserDirectionForward, isUserDirectionForward);
      expect(uut.state.restaurants, restaurants);
      expect(uut.state.favourites[restaurantId], true);
      expect(uut.state.viewStatus.isSuccess, true);
    });

    test(
      'should handle view status error and pause location updates when fetch is failing',
      () async {
        const error = ViewStatusError(message: 'Test error');
        when(restaurantsRepository.fetch(locationZero)).thenThrow(error);
        await uut.computeRestaurantsBasedOnUserLocation(locationZero, true);
        expect(uut.state.viewStatus, const ViewStatus.failure(error));
        verify(userLocationRepository.pause()).called(1);
      },
    );

    test(
      'should handle generic error and pause location updates when fetch is failing',
      () async {
        when(
          restaurantsRepository.fetch(locationZero),
        ).thenThrow(Exception('error'));
        await uut.computeRestaurantsBasedOnUserLocation(locationZero, true);
        expect(uut.state.viewStatus, isA<ViewStatusFailure>());
        expect(uut.state.viewStatus, isA<ViewStatusFailure>());
        expect(
          (uut.state.viewStatus as ViewStatusFailure).error.message,
          'Exception: error',
        );
        verify(userLocationRepository.pause()).called(1);
      },
    );

    test('should reset the location', () {
      uut.resetLocation();
      expect(uut.state.viewStatus.isLoading, true);
      verify(userLocationRepository.reset()).called(1);
    });

    test(
      'should set isInvalidLocation to true when onInvalidLocationError is called',
      () async {
        uut.onInvalidLocationError();
        expect(uut.state.isInvalidLocation, true);
      },
    );

    test(
      'should pause user location when isUserLocationPaused changes to true',
      () {
        const initialModel = RestaurantsModel(isUserLocationPaused: false);
        const updatedModel = RestaurantsModel(isUserLocationPaused: true);
        uut.emit(initialModel);
        uut.didUpdateWidget(updatedModel);
        verify(userLocationRepository.pause()).called(1);
        expect(uut.state.isUserLocationPaused, true);
      },
    );

    test(
      'should resume user location when isUserLocationPaused changes to false',
      () {
        const initialModel = RestaurantsModel(isUserLocationPaused: true);
        const updatedModel = RestaurantsModel(isUserLocationPaused: false);
        uut.emit(initialModel);
        uut.didUpdateWidget(updatedModel);
        verify(userLocationRepository.resume()).called(1);
        expect(uut.state.isUserLocationPaused, false);
      },
    );
  });
}
