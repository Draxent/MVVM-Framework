import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:example/src/features/counter/counter_model.dart';
import 'package:example/src/features/counter/counter_page.dart';
import 'package:example/src/features/counter/counter_vm.dart';
import 'package:example/src/widgets/widgets.dart';

import '../../app_wrapper.dart';
import '../../mocks.mocks.dart';

class MockCounterMVVM extends MVVM<CounterModel, CounterPageView, CounterVM> {
  const MockCounterMVVM({required super.viewModel, super.key})
    : super(view: const CounterPageView());
}

void main() {
  group('CounterPage', () {
    late final MockCounterVM vm;
    late Widget uut;
    const modelInit = CounterModel(viewStatus: viewStatusSuccess);
    var model = modelInit;

    setUpAll(() {
      vm = MockCounterVM();
      when(vm.state).thenAnswer((_) => model);
    });

    setUp(() => uut = AppWrapper(child: MockCounterMVVM(viewModel: vm)));

    tearDown(() => model = modelInit);

    testWidgets('should renders the page and display the initial count', (
      tester,
    ) async {
      model = model.copyWith(value: 2);
      await tester.pumpWidget(uut);
      expect(find.byType(CounterPageView), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text('Counter Feature'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
      'should calls increment when floating action button is pressed',
      (tester) async {
        await tester.pumpWidget(uut);
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pumpAndSettle();
        verify(vm.increment()).called(1);
      },
    );
  });
}
