import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/core/core.dart';
import 'package:example/src/features/integrated/integrated_model.dart';
import 'package:example/src/features/integrated/integrated_vm.dart';
import 'package:example/src/features/counter/counter_page.dart';
import 'package:example/src/features/restaurants/restaurants_page.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:example/src/features/counter/counter_model.dart';
import 'package:example/src/features/restaurants/restaurants_model.dart';

// coverage:ignore-start
class IntegratedPage
    extends MVVM<IntegratedModel, IntegratedPageView, IntegratedVM> {
  IntegratedPage({required IntegratedModel model, super.key})
    : super(
        view: const IntegratedPageView(),
        viewModel: inject<IntegratedVM>(model),
      );

  static const name = 'integrated';
  static const path = '/$name';
}
// coverage:ignore-end

class IntegratedPageView extends ViewWidget<IntegratedVM> {
  const IntegratedPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Integrated Feature',
      page: SingleChildScrollView(
        child: Column(
          children: [
            _IntegratedInputCounter(),
            SizedBox(height: 10),
            _IntegratedStartStopButton(),
            _Divider(),
            _IntegratedCounterPage(),
            _Divider(),
            _IntegratedRestaurantsPage(),
          ],
        ),
      ),
    );
  }
}

class _IntegratedInputCounter extends ViewWidget<IntegratedVM> {
  const _IntegratedInputCounter();

  @override
  Widget build(BuildContext context) {
    final initialValue = select(
      context,
      (vm) => vm.state.counterInitialInputValue.toString(),
    );
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            key: ValueKey(initialValue),
            initialValue: initialValue,
            decoration: const InputDecoration(labelText: 'Counter Value'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final intValue = int.tryParse(value) ?? 0;
              vm(context).updateCounterInputValue(intValue);
            },
          ),
        ),
        AppButton(
          onPressed: vm(context).changeCounterSubmittedValue,
          label: 'Change Counter Value',
        ),
      ],
    );
  }
}

class _IntegratedStartStopButton extends ViewWidget<IntegratedVM> {
  const _IntegratedStartStopButton();

  @override
  Widget build(BuildContext context) {
    final isPaused = select(context, (vm) => vm.state.isUserLocationPaused);
    return AppButton(
      onPressed: vm(context).toggleUserLocation,
      label: '${isPaused ? 'Resume' : 'Pause'} User Location',
    );
  }
}

class _IntegratedCounterPage extends ViewWidget<IntegratedVM> {
  const _IntegratedCounterPage();

  @override
  Widget build(BuildContext context) {
    final counter = select(context, (vm) => vm.state.counterSubmittedValue);
    return SizedBox(
      height: 300,
      child: MockWidget(
        child: CounterPage(
          model: CounterModel(value: counter),
          onUpdateCounter: vm(context).updateCounterInitialInputValue,
        ),
      ),
    );
  }
}

class _IntegratedRestaurantsPage extends ViewWidget<IntegratedVM> {
  const _IntegratedRestaurantsPage();

  @override
  Widget build(BuildContext context) {
    final isPaused = select(context, (vm) => vm.state.isUserLocationPaused);
    return SizedBox(
      height: 600,
      child: MockWidget(
        child: RestaurantsPage(
          model: RestaurantsModel(isUserLocationPaused: isPaused),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(),
    );
  }
}
