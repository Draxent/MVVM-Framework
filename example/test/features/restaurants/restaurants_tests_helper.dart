import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';

abstract class RestaurantsTestHelper {
  static RestaurantEntity buildDummyRestaurant(
    String id, [
    LocationEntity? location,
  ]) => RestaurantEntity(
    id: RestaurantId(id: id),
    name: 'name',
    description: 'desc',
    imageUrl: '',
    location: location ?? locationZero,
  );
}
