import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/restaurants/favourites_storage_service.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';
import 'package:example/src/features/restaurants/restaurants_repository.dart';
import 'package:example/src/features/restaurants/user_location_repository.dart';

@injectable
class RestaurantsVM extends ViewModel<RestaurantsModel> {
  RestaurantsVM(
    this._restaurantsRepository,
    this._userLocationRepository,
    this._favouritesStorageService,
    @factoryParam RestaurantsModel model,
  ) : super(model: model);

  final RestaurantsRepository _restaurantsRepository;
  final UserLocationRepository _userLocationRepository;
  final FavouritesStorageService _favouritesStorageService;

  @visibleForTesting
  late final StreamSubscription<(LocationEntity, bool)> streamSubscription;

  @override
  Future<void> onInit() async {
    registerErrorHandler<ViewStatusInvalidLocationError>(
      onInvalidLocationError,
    );
    streamSubscription = _userLocationRepository.watch().listen(
      (x) => computeRestaurantsBasedOnUserLocation(x.$1, x.$2),
    );
    _pauseOrResumerUserLocation(state.isUserLocationPaused);
  }

  @override
  Future<void> close() async {
    super.close();
    streamSubscription.cancel();
  }

  @override
  void didUpdateWidget(RestaurantsModel newModel) {
    if (state.isUserLocationPaused != newModel.isUserLocationPaused) {
      _pauseOrResumerUserLocation(newModel.isUserLocationPaused);
      emit(state.copyWith(isUserLocationPaused: newModel.isUserLocationPaused));
    }
  }

  @override
  void listener(RestaurantsModel model) {
    super.listener(model);
    if (model.viewStatus.isInitial) {
      _userLocationRepository.resume();
    }
  }

  Future<void> setFavourite(RestaurantId restaurantId, bool value) async {
    _favouritesStorageService.setFavourite(restaurantId.id, value);
    final newFavourites = Map<RestaurantId, bool>.from(state.favourites);
    newFavourites[restaurantId] = value;
    emit(state.copyWith(favourites: newFavourites));
  }

  @visibleForTesting
  Future<void> computeRestaurantsBasedOnUserLocation(
    LocationEntity location,
    bool isUserDirectionForward,
  ) async {
    await safeExecute(() async {
      final restaurants = await _restaurantsRepository.fetch(location);
      var favourites = {
        for (var item in restaurants)
          item.id: _favouritesStorageService.isFavourite(item.id.id),
      };
      emit(
        state.copyWith(
          userLocation: location,
          isInvalidLocation: false,
          isUserDirectionForward: isUserDirectionForward,
          restaurants: restaurants,
          favourites: favourites,
          viewStatus: viewStatusSuccess,
        ),
      );
    }, onError: (_) => _userLocationRepository.pause());
  }

  void resetLocation() {
    emit(state.copyWith(viewStatus: viewStatusLoading));
    _userLocationRepository.reset();
  }

  @visibleForTesting
  void onInvalidLocationError() =>
      emit(state.copyWith(isInvalidLocation: true));

  void _pauseOrResumerUserLocation(bool isUserLocationPaused) {
    if (isUserLocationPaused) {
      _userLocationRepository.pause();
    } else {
      _userLocationRepository.resume();
    }
  }
}
