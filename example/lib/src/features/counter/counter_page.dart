import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/core/injection.dart';
import 'package:example/src/features/counter/counter_model.dart';
import 'package:example/src/features/counter/counter_vm.dart';
import 'package:example/src/widgets/widgets.dart';

// coverage:ignore-start
class CounterPage extends MVVM<CounterModel, CounterPageView, CounterVM> {
  CounterPage({
    required CounterModel model,
    OnUpdateCounter? onUpdateCounter,
    super.key,
  }) : super(
         view: const CounterPageView(),
         viewModel: inject<CounterVM>(model, onUpdateCounter),
       );

  static const name = 'counter';
  static const path = '/$name';
}
// coverage:ignore-end

class CounterPageView extends ViewWidget<CounterVM> {
  const CounterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Counter Feature',
      page: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          const _CounterValueView(),
          const SizedBox(height: 10),
          AppButton(
            onPressed: vm(context).incrementWithException,
            label: 'Increment with Exception',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm(context).increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CounterValueView extends ViewWidget<CounterVM> {
  const _CounterValueView();

  @override
  Widget build(BuildContext context) {
    final count = select(context, (vm) => vm.state.value);
    return Text(
      count.toString(),
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
