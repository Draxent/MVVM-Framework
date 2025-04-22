import 'package:example/src/widgets/gif.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/core/core.dart';
import 'package:example/src/features/restaurants/restaurant_entity.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';
import 'package:example/src/features/restaurants/restaurants_vm.dart';
import 'package:example/src/widgets/widgets.dart';

// coverage:ignore-start
class RestaurantsPage
    extends MVVM<RestaurantsModel, RestaurantsView, RestaurantsVM> {
  RestaurantsPage({required RestaurantsModel model, super.key})
    : super(
        view: const RestaurantsView(),
        viewModel: inject<RestaurantsVM>(model),
        isLoadingManagedAutomatically: false,
      );

  static const name = 'restaurants';
  static const path = '/$name';
}
// coverage:ignore-end

class RestaurantsView extends ViewWidget<RestaurantsVM> {
  const RestaurantsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Restaurants Feature',
      page: _RestaurantPageContent(),
    );
  }
}

class _RestaurantPageContent extends ViewWidget<RestaurantsVM> {
  const _RestaurantPageContent();

  @override
  Widget build(BuildContext context) {
    final isInvalidLocation = select(context, (x) => x.state.isInvalidLocation);
    if (isInvalidLocation) {
      return const _InvalidLocationView();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _UserLocationView(),
        const SizedBox(height: 5),
        Text('Restaurants:', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        const Expanded(child: _RestaurantListView()),
      ],
    );
  }
}

class _InvalidLocationView extends ViewWidget<RestaurantsVM> {
  const _InvalidLocationView();

  @override
  Widget build(BuildContext context) {
    final isLoading = select(context, (x) => x.state.viewStatus.isLoading);
    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('User Location is invalid: '),
          AppButton(
            label: 'Reset',
            isLoading: isLoading,
            onPressed: vm(context).resetLocation,
          ),
        ],
      ),
    );
  }
}

class _UserLocationView extends ViewWidget<RestaurantsVM> {
  const _UserLocationView();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Row(children: [_UserLocationText(), _UserLocationGif()]),
    );
  }
}

class _UserLocationText extends ViewWidget<RestaurantsVM> {
  const _UserLocationText();

  @override
  Widget build(BuildContext context) {
    final userLocation = select(context, (x) => x.state.userLocation);
    return Text(
      'User Location (latitude: ${userLocation.latitude}, longitude: ${userLocation.longitude})',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class _UserLocationGif extends ViewWidget<RestaurantsVM> {
  const _UserLocationGif();

  @override
  Widget build(BuildContext context) {
    final (isUserDirectionForward, isUserLocationPaused) = select(
      context,
      (x) => (x.state.isUserDirectionForward, x.state.isUserLocationPaused),
    );
    return Gif(
      path: 'assets/images/mario_walking.gif',
      size: Size(92, 67),
      isFlippedHorizontally: !isUserDirectionForward,
      isPaused: isUserLocationPaused,
    );
  }
}

class _RestaurantListView extends ViewWidget<RestaurantsVM> {
  const _RestaurantListView();

  @override
  Widget build(BuildContext context) {
    final isLoading = select(context, (x) => x.state.viewStatus.isLoading);
    if (isLoading) {
      return Text('Loading...', style: Theme.of(context).textTheme.bodyLarge);
    }
    final restaurants = select(context, (x) => x.state.restaurants);
    return ListView.separated(
      separatorBuilder:
          (_, i) => const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Divider(),
          ),
      itemCount: restaurants.length,
      itemBuilder: (_, i) => _RestaurantItemView(item: restaurants[i]),
    );
  }
}

class _RestaurantItemView extends ViewWidget<RestaurantsVM> {
  const _RestaurantItemView({required this.item});

  final RestaurantEntity item;

  @override
  Widget build(BuildContext context) {
    final isFavorite = select(
      context,
      (x) => x.state.favourites[item.id] ?? false,
    );
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.network(item.imageUrl),
          ),
        ),
      ),
      title: Text(item.name),
      subtitle: Text(item.description),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_outline),
        onPressed: () => vm(context).setFavourite(item.id, !isFavorite),
      ),
    );
  }
}
