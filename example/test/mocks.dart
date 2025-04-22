import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/router.dart';
import 'package:example/src/features/counter/counter_vm.dart';
import 'package:example/src/features/counter/counter_repository.dart';
import 'package:example/src/features/restaurants/favourites_storage_service.dart';
import 'package:example/src/features/restaurants/location_entity.dart';
import 'package:example/src/features/restaurants/restaurants_repository.dart';
import 'package:example/src/features/restaurants/user_location_repository.dart';
import 'package:example/src/features/restaurants/restaurants_vm.dart';
import 'package:example/src/features/integrated/integrated_vm.dart';

@GenerateNiceMocks([MockSpec<AppRouter>()])
@GenerateNiceMocks([MockSpec<CounterVM>()])
@GenerateNiceMocks([MockSpec<CounterRepository>()])
@GenerateNiceMocks([MockSpec<FavouritesStorageService>()])
@GenerateNiceMocks([MockSpec<GenericErrorContext>()])
@GenerateNiceMocks([MockSpec<IntegratedVM>()])
@GenerateNiceMocks([MockSpec<NavigatorState>()])
@GenerateNiceMocks([MockSpec<ScaffoldFeatureController>()])
@GenerateNiceMocks([MockSpec<ScaffoldMessengerState>()])
@GenerateNiceMocks([MockSpec<Stream<(LocationEntity, bool)>>()])
@GenerateNiceMocks([MockSpec<StreamSubscription<(LocationEntity, bool)>>()])
@GenerateNiceMocks([MockSpec<Random>()])
@GenerateNiceMocks([MockSpec<RestaurantsRepository>()])
@GenerateNiceMocks([MockSpec<RestaurantsVM>()])
@GenerateNiceMocks([MockSpec<ViewContext>()])
@GenerateNiceMocks([MockSpec<UserLocationRepository>()])
export 'mocks.mocks.dart';
