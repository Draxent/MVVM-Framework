// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';

part 'restaurants_model.freezed.dart';

@freezed
abstract class RestaurantsModel with _$RestaurantsModel implements Model {
  const factory RestaurantsModel({
    @Default(viewStatusLoading) ViewStatus viewStatus,
    @Default(locationZero) LocationEntity userLocation,
    @Default(true) bool isUserDirectionForward,
    @Default(false) bool isUserLocationPaused,
    @Default([]) List<RestaurantEntity> restaurants,
    @Default({}) Map<RestaurantId, bool> favourites,
    @Default(false) bool isInvalidLocation,
  }) = _RestaurantsModel;

  const RestaurantsModel._();

  @override
  RestaurantsModel copyWithViewStatus(ViewStatus viewStatus) =>
      copyWith(viewStatus: viewStatus);
}
