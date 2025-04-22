[← Back](./README.md)

# Restaurants Feature

The Restaurants feature showcasing how the MVVM framework can handle advanced scenarios, such as managing dynamic user location updates, handling loading and error states manually, and implementing custom UI behaviors like displaying user movement direction and pausing location updates. It highlights the flexibility and scalability of the MVVM architecture for real-world applications.

This feature allows users to view a list of restaurants based on their current location, mark restaurants as favorites, and dynamically update the list as the user's location changes. The feature simulates three types of errors from the fetching restaurants API: generic, network, and business errors. Generic and network errors are managed generically using the MVVM framework's capabilities, while business errors, such as invalid user location, are handled specifically. In case of any error, location updates are paused until the error is resolved.

<img src='../doc/restaurants.gif' width='40%'>

---

## Code

### Model

The `RestaurantsModel` represents the state of the restaurant data, including the view status, the user location, the list of restaurants, and the user favorites.

```dart
@freezed
abstract class RestaurantsModel with _$RestaurantsModel implements Model {
  const factory RestaurantsModel({
    @Default(viewStatusLoading) ViewStatus viewStatus,
    @Default(locationZero) LocationEntity userLocation,
    @Default([]) List<RestaurantEntity> restaurants,
    @Default({}) Map<RestaurantId, bool> favourites,
```

- **`viewStatus`**: Tracks the current state of the view: initial, loading, success, failure.
- **`userLocation`**: The current location of the user.
- **`restaurants`**: A list of restaurant entities fetched from the repository.
- **`favourites`**: A map of restaurant IDs to their favorite status.

---

### ViewModel

The `RestaurantsVM` contains the business logic for fetching restaurant data and managing user interactions.

#### Fetch restaurants when user location changes

```dart
Future<void> computeRestaurantsBasedOnUserLocation(LocationEntity location, bool isUserDirectionForward) async {
  await safeExecute(
    () async {
      final restaurants = await _restaurantsRepository.fetch(location);
      var favourites = {
        for (var item in restaurants) item.id: _favouritesStorageService.isFavourite(item.id.id)
      };
      emit(state.copyWith(
        userLocation: location,
        isUserDirectionForward: isUserDirectionForward,
        restaurants: restaurants,
        favourites: favourites,
        viewStatus: viewStatusSuccess,
      ));
    },
    onError: (_) => _userLocationRepository.pause(),
  );
}
```

- Fetches restaurant data from the repository based on the user's location.
- Updates the state with the fetched data and sets the view status to success.
- Handles errors using the `safeExecute` utility method.

---

### View

The `RestaurantsPageView` provides the UI for the restaurant feature.

#### Restaurant list view

```dart
Widget build(BuildContext context) {
  final restaurants = select(context, (x) => x.state.restaurants);
  return ListView.separated(
    separatorBuilder: (_, i) => const Padding(
      padding: EdgeInsets.only(left: 30),
      child: Divider(),
    ),
    itemCount: restaurants.length,
    itemBuilder: (_, i) => _RestaurantItemView(item: restaurants[i]),
  );
}
```

It displays a list of restaurants using a `ListView` and allows users to mark them as favorites.

#### User location GIF

This component visualizes the user's movement using an animated GIF. The animation adapts to the user's movement direction and pauses when location updates are paused.

```dart
Widget build(BuildContext context) {
  final (isUserDirectionForward, isUserLocationPaused) = select(context,
    (x) => (x.state.isUserDirectionForward, x.state.isUserLocationPaused));
  return Gif(
    path: 'assets/images/mario_walking.gif',
    size: Size(92, 67),
    isFlippedHorizontally: !isUserDirectionForward,
    isPaused: isUserLocationPaused,
  );
```

- The GIF flips horizontally based on `isUserDirectionForward` to show the correct movement direction.
- When `isUserLocationPaused` is true, the animation pauses.
- Uses the `select` method to efficiently subscribe only to the relevant state properties.

This demonstrates a powerful MVVM integration pattern with stateful Flutter widgets. The MVVM architecture manages the high-level state (`isUserLocationPaused`) in the Model, while the stateful `Gif` widget handles the low-level animation details. When the Model updates this property:

1. The ViewModel propagates the change
2. The View passes it as a prop to the `Gif` widget
3. The `Gif` widget detects the change in `didUpdateWidget`
4. It responds by starting/stopping its internal animation controller

This separation of concerns allows complex UI behaviors to be controlled declaratively through your MVVM state, while encapsulating the implementation details within specialized widgets.

```dart
class _GifState extends State<Gif> with TickerProviderStateMixin {
  late final _controller = gif.GifController(vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Gif oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    }
  }
```

---

## Testing

The Restaurants feature includes unit and widget tests to ensure its functionality.

### Unit Tests

Unit tests verify the business logic in the `RestaurantsVM` class.

```dart
test('should fetch restaurants when location changes', () async {
  const isUserDirectionForward = true;
  final restaurant = RestaurantsTestHelper.buildDummyRestaurant(restaurantId.id);
  final restaurants = [restaurant];
  when(restaurantsRepository.fetch(locationZero)).thenAnswer((_) async => restaurants);
  when(favouritesStorageService.isFavourite('1')).thenReturn(true);

  await uut.computeRestaurantsBasedOnUserLocation(locationZero, isUserDirectionForward);

  expect(uut.state.userLocation, locationZero);
  expect(uut.state.isInvalidLocation, false);
  expect(uut.state.isUserDirectionForward, isUserDirectionForward);
  expect(uut.state.restaurants, restaurants);
  expect(uut.state.favourites[restaurantId], true);
  expect(uut.state.viewStatus.isSuccess, true);
});
```

- It ensures that the method fetches restaurant data when the user's location changes.
- It verifies that the state is updated with the correct location, direction, restaurants, favorites, and view status.

### Widget Tests

```dart
testWidgets('should show the list of restaurants', (tester) async {
  final restaurants = [
    RestaurantsTestHelper.buildDummyRestaurant('1'),
    RestaurantsTestHelper.buildDummyRestaurant('2'),
  ];
  model = model.copyWith(restaurants: restaurants);
  await provideMockedNetworkImages(() => tester.pumpWidget(uut));
  expect(find.byType(ListView), findsOneWidget);
  expect(find.byType(ListTile), findsNWidgets(2));
});
```

- It verifies that the UI displays a list of restaurants using a `ListView`.
- It ensures that the correct number of `ListTile` widgets is rendered based on the restaurant data.

