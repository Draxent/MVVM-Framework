// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:example/src/features/restaurants/location_entity.dart';

part 'restaurant_entity.freezed.dart';

@freezed
abstract class RestaurantEntity with _$RestaurantEntity {
  const factory RestaurantEntity({
    required RestaurantId id,
    required String name,
    required String description,
    required String imageUrl,
    required LocationEntity location,
  }) = _RestaurantEntity;
}

@freezed
abstract class RestaurantId with _$RestaurantId {
  const factory RestaurantId({required String id}) = _RestaurantId;
}
