import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:example/src/core/core.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/user_location_repository.dart';

void main() {
  group('UserLocationRepository', () {
    late final UserLocationRepository uut;

    setUpAll(() {
      Utils.isUnitTest = true;
      uut = UserLocationRepository();
    });

    test('should update location and direction', () async {
      final (subscription, emittedValues) = _subscribe(uut.watch());
      await Utils.delay();
      subscription.cancel();
      expect(emittedValues.length, 20);
      expect(emittedValues[0].$1, locationZero);
      expect(emittedValues[0].$2, true);
      expect(emittedValues[1].$1.latitude, 1);
      expect(emittedValues[1].$1.longitude, 1);
      expect(emittedValues[1].$2, true);
      expect(emittedValues[2].$1.latitude, 2);
      expect(emittedValues[2].$1.longitude, 2);
      expect(emittedValues[2].$2, true);
      expect(emittedValues[11].$1.latitude, 9);
      expect(emittedValues[11].$1.longitude, 9);
      expect(emittedValues[11].$2, false);
    });

    test('should pause, resume and reset', () async {
      final (subscription, emittedValues) = _subscribe(uut.watch());
      uut.pause();
      await Utils.delay();
      expect(emittedValues.isEmpty, true);
      uut.resume();
      await Utils.delay();
      subscription.cancel();
      expect(emittedValues.isNotEmpty, true);
      uut.reset();
      final (subscription2, emittedValues2) = _subscribe(uut.watch());
      await Utils.delay();
      subscription2.cancel();
      expect(emittedValues2.isNotEmpty, true);
      expect(emittedValues2[0].$1, locationZero);
      expect(emittedValues2[0].$2, true);
    });
  });
}

(StreamSubscription<(LocationEntity, bool)>, List<(LocationEntity, bool)>)
_subscribe(Stream<(LocationEntity, bool)> stream) {
  final emittedValues = <(LocationEntity, bool)>[];
  final subscription = stream.listen((value) => emittedValues.add(value));
  return (subscription, emittedValues);
}
