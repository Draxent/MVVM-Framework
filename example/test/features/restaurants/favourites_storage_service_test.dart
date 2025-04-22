import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/src/features/restaurants/favourites_storage_service.dart';

void main() async {
  group('FavouritesStorageService', () {
    late final FavouritesStorageService uut;
    late final SharedPreferences sharedPreferences;

    const key1 = 'testKey1', key2 = 'testKey2';

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      uut = FavouritesStorageService(sharedPreferences);
    });

    test('should set the value in shared preferences', () async {
      const value = true;
      await uut.setFavourite(key1, value);
      expect(sharedPreferences.getBool('favourites.$key1'), value);
    });

    test('should return the correct value from shared preferences', () async {
      const value = true;
      await sharedPreferences.setBool('favourites.$key1', value);
      final result = uut.isFavourite(key1);
      expect(result, value);
    });

    test(
      'should return false if the key is not present in shared preferences',
      () {
        final result = uut.isFavourite(key2);
        expect(result, false);
      },
    );
  });
}
