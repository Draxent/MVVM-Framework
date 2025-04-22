import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/core/core.dart';

@singleton
class UserLocationRepository {
  var _currentLocation = locationZero;
  var _incr = 1;
  var _isPaused = false;

  void reset() {
    _currentLocation = locationZero;
    _incr = 1;
    _isPaused = false;
  }

  void resume() => _isPaused = false;

  void pause() => _isPaused = true;

  Stream<(LocationEntity, bool)> watch() async* {
    // Simulates a user walking back and forth on a street full of restaurants
    while (true) {
      while (_isPaused) {
        await Utils.delay();
        continue;
      }
      yield (_currentLocation, _incr > 0);
      if (_currentLocation.latitude >= 10) {
        _incr = -1;
      } else if (_currentLocation.latitude <= 0) {
        _incr = 1;
      }
      _currentLocation = LocationEntity(
        latitude: _currentLocation.latitude + _incr,
        longitude: _currentLocation.longitude + _incr,
      );
      if (Utils.isUnitTest) {
        if (_currentLocation == locationZero) {
          break;
        }
      } else {
        // coverage:ignore-start
        await Utils.delay(5000);
        // coverage:ignore-end
      }
    }
  }
}
