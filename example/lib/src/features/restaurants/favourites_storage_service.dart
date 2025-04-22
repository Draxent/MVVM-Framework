import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class FavouritesStorageService {
  FavouritesStorageService(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  static const _keyStoragePrefix = 'favourites.';

  Future<void> setFavourite(String key, bool value) async =>
      _sharedPreferences.setBool(_computeFullKey(key), value);

  bool isFavourite(String key) =>
      _sharedPreferences.getBool(_computeFullKey(key)) ?? false;

  String _computeFullKey(String key) => '$_keyStoragePrefix$key';
}
