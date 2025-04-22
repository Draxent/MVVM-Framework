import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:example/src/core/core.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';
import 'package:example/src/generic_error_manager.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

@injectable
class RestaurantsRepository {
  RestaurantsRepository(@factoryParam Random? random)
    : _random = random ?? Random();

  final Random _random;

  Future<List<RestaurantEntity>> fetch(LocationEntity userPosition) async {
    await Utils.delay();
    _simulateError(userPosition);
    final restaurants = _restaurants.toList();
    restaurants.sort((a, b) {
      final distanceA = _calculateDistance(userPosition, a.location);
      final distanceB = _calculateDistance(userPosition, b.location);
      return distanceA.compareTo(distanceB);
    });
    final closestRestaurants = restaurants.take(5).toList();
    return closestRestaurants;
  }

  // Simulate error with 15% probability
  void _simulateError(LocationEntity userPosition) {
    if (_random.nextDouble() < 0.15) {
      final errorType = _random.nextInt(3);
      switch (errorType) {
        case 0:
          throw const ViewStatusError(message: 'Generic error occurred');
        case 1:
          throw const ViewStatusNetworkError(message: 'Network error occurred');
        case 2:
          throw ViewStatusInvalidLocationError(
            location: userPosition,
            message: 'Invalid $userPosition',
          );
      }
    }
  }

  static double _calculateDistance(
    LocationEntity userLocation,
    LocationEntity restaurantLocation,
  ) {
    // Simplified distance calculation for simulation purposes
    final latDiff = (userLocation.latitude - restaurantLocation.latitude).abs();
    final lonDiff =
        (userLocation.longitude - restaurantLocation.longitude).abs();
    return latDiff + lonDiff;
  }

  final _restaurants = _generateRestaurants(10, [
    'https://cdn.pixabay.com/photo/2019/09/12/15/21/resort-4471852_1280.jpg',
    'https://cdn.pixabay.com/photo/2020/08/27/07/31/restaurant-5521372_1280.jpg',
    'https://cdn.pixabay.com/photo/2022/11/14/10/37/chinese-lanterns-7591296_1280.jpg',
    'https://cdn.pixabay.com/photo/2015/11/19/10/38/food-1050813_1280.jpg',
    'https://cdn.pixabay.com/photo/2014/09/17/20/26/restaurant-449952_1280.jpg',
    'https://cdn.pixabay.com/photo/2022/05/22/13/21/healthy-7213383_1280.jpg',
    'https://cdn.pixabay.com/photo/2023/07/07/17/47/sushi-8113165_1280.jpg',
    'https://cdn.pixabay.com/photo/2022/03/04/00/47/wine-7046276_1280.jpg',
    'https://cdn.pixabay.com/photo/2015/04/08/13/13/food-712665_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/18/14/39/beans-1834984_1280.jpg',
  ]);

  static List<RestaurantEntity> _generateRestaurants(
    int count,
    List<String> imageUrls,
  ) => List.generate(
    count,
    (index) => RestaurantEntity(
      id: RestaurantId(id: '$index'),
      name: 'Restaurant $index',
      description: 'Description for restaurant $index',
      imageUrl: imageUrls[index],
      location: LocationEntity(
        latitude: index.toDouble(),
        longitude: index.toDouble(),
      ),
    ),
  );
}

/// Simulate that the location provided to the fetch method is outside the valid range
class ViewStatusInvalidLocationError extends ViewStatusError {
  const ViewStatusInvalidLocationError({required this.location, super.message});

  final LocationEntity location;
}
