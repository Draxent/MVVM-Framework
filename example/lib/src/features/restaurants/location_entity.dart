// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_entity.freezed.dart';

@freezed
abstract class LocationEntity with _$LocationEntity {
  const factory LocationEntity({
    required double latitude,
    required double longitude,
  }) = _LocationEntity;
}

const locationZero = LocationEntity(latitude: 0, longitude: 0);
