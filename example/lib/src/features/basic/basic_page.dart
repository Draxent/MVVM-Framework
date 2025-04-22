// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/widgets/widgets.dart';

class BasicModel implements Model {
  const BasicModel(this.viewStatus, this.value);

  @override
  final ViewStatus viewStatus;
  final int value;

  BasicModel copyWith({ViewStatus? viewStatus, int? value}) =>
      BasicModel(viewStatus ?? this.viewStatus, value ?? this.value);

  @override
  BasicModel copyWithViewStatus(ViewStatus viewStatus) =>
      copyWith(viewStatus: viewStatus);
}

class BasicVM extends ViewModel<BasicModel> {
  BasicVM() : super(model: const BasicModel(viewStatusInitial, 0));

  Future<void> increment() async =>
      emit(state.copyWith(value: state.value + 1));
}

class BasicPage extends MVVM<BasicModel, BasicPageView, BasicVM> {
  BasicPage({super.key})
    : super(view: const BasicPageView(), viewModel: BasicVM());

  static const name = 'basic';
  static const path = '/$name';
}

class BasicPageView extends ViewWidget<BasicVM> {
  const BasicPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final count = select(context, (vm) => vm.state.value);
    return AppScaffold(
      title: 'Basic Feature',
      page: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You have pushed the button this many times: $count  '),
            AppButton(label: 'Add', onPressed: vm(context).increment),
          ],
        ),
      ),
    );
  }
}
