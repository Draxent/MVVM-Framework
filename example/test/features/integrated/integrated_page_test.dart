import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:example/src/features/integrated/integrated_page.dart';
import 'package:example/src/features/integrated/integrated_model.dart';
import 'package:example/src/features/integrated/integrated_vm.dart';
import 'package:example/src/widgets/widgets.dart';
import 'package:example/src/core/core.dart';

import '../../app_wrapper.dart';
import '../../mocks.mocks.dart';

class MockIntegratedMVVM
    extends MVVM<IntegratedModel, IntegratedPageView, IntegratedVM> {
  const MockIntegratedMVVM({required super.viewModel, super.key})
    : super(view: const IntegratedPageView());
}

void main() {
  group('IntegratedPage', () {
    late final MockIntegratedVM vm;
    late Widget uut;
    const modelInit = IntegratedModel(
      counterInputValue: 0,
      counterSubmittedValue: 0,
      isUserLocationPaused: false,
    );
    var model = modelInit;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await configureDependencies();
      Utils.isUnitTest = true;
      vm = MockIntegratedVM();
      when(vm.state).thenAnswer((_) => model);
    });

    setUp(() => uut = AppWrapper(child: MockIntegratedMVVM(viewModel: vm)));

    tearDown(() => model = modelInit);

    testWidgets('should render the page and display the initial state', (
      tester,
    ) async {
      await tester.pumpWidget(uut);

      expect(find.byType(IntegratedPageView), findsOneWidget);
      expect(find.byType(AppScaffold), findsOneWidget);
      expect(find.text('Integrated Feature'), findsOneWidget);
    });

    testWidgets('should update counter input value when text field changes', (
      tester,
    ) async {
      await tester.pumpWidget(uut);
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, '5');
      await tester.pump();
      verify(vm.updateCounterInputValue(5)).called(1);
    });

    testWidgets(
      'should change counter submitted value when button is pressed',
      (tester) async {
        await tester.pumpWidget(uut);
        await tester.enterText(find.byType(TextField), '5');
        await tester.pump();
        await tester.tap(find.byType(AppButton).first);
        verify(vm.changeCounterSubmittedValue()).called(1);
      },
    );

    testWidgets(
      'should toggle user location state when pause button is pressed',
      (tester) async {
        await tester.pumpWidget(uut);
        final button = find.text('Pause User Location');
        expect(button, findsOneWidget);
        await tester.tap(button);
        await tester.pumpAndSettle();
        verify(vm.toggleUserLocation()).called(1);
      },
    );

    testWidgets(
      'should toggle user location state when resume button is pressed',
      (tester) async {
        model = model.copyWith(isUserLocationPaused: true);
        await tester.pumpWidget(uut);
        final button = find.text('Resume User Location');
        expect(button, findsOneWidget);
        await tester.tap(button);
        await tester.pumpAndSettle();
        verify(vm.toggleUserLocation()).called(1);
      },
    );
  });
}
