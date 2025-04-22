import 'package:example/src/generic_error_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';
import 'package:example/src/features/restaurants/restaurants_repository.dart';
import 'package:example/src/core/core.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

import '../../mocks.dart';

void main() {
  group('RestaurantsRepository', () {
    late final RestaurantsRepository uut;
    late final MockRandom random;

    setUpAll(() {
      Utils.isUnitTest = true;
      random = MockRandom();
      uut = RestaurantsRepository(random);
    });

    test('should return a list of restaurants sorted by distance', () async {
      when(random.nextDouble()).thenReturn(0.2);
      final result = await uut.fetch(
        const LocationEntity(latitude: 5, longitude: 5),
      );
      expect(result, isA<List<RestaurantEntity>>());
      expect(result.length, lessThanOrEqualTo(5));
      expect(result[0].id.id, '5');
      expect(result[1].id.id, '4');
      expect(result[2].id.id, '6');
      expect(result[3].id.id, '3');
      expect(result[4].id.id, '7');
    });

    test(
      'should throw ViewStatusError when random value is less than 0.15 and errorType is 0',
      () async {
        when(random.nextDouble()).thenReturn(0.1);
        when(random.nextInt(3)).thenReturn(0);
        expect(() => uut.fetch(locationZero), throwsA(isA<ViewStatusError>()));
      },
    );

    test(
      'should throw ViewStatusNetworkError when random value is less than 0.15 and errorType is 0',
      () async {
        when(random.nextDouble()).thenReturn(0.1);
        when(random.nextInt(3)).thenReturn(1);
        expect(
          () => uut.fetch(locationZero),
          throwsA(isA<ViewStatusNetworkError>()),
        );
      },
    );

    test(
      'should throw ViewStatusInvalidLocationError when random value is less than 0.15 and errorType is 0',
      () async {
        when(random.nextDouble()).thenReturn(0.1);
        when(random.nextInt(3)).thenReturn(2);
        expect(
          () => uut.fetch(locationZero),
          throwsA(isA<ViewStatusInvalidLocationError>()),
        );
      },
    );
  });
}
