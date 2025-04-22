import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_framework/src/mvvm.dart';
import 'package:mvvm_framework/src/model.dart';
import 'package:flutter/material.dart';

import 'app_wrapper.dart';
import 'test_helper.dart';

class MockTestMVVM extends MVVM<TestModel, TestView, TestVM> {
  MockTestMVVM({TestVM? vm, super.isLoadingManagedAutomatically, super.key})
    : super(view: const TestView(), viewModel: vm ?? TestVM(const TestModel()));
}

void main() {
  group('MVVM', () {
    testWidgets('should initialize ViewModel and build View', (tester) async {
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM()));
      expect(find.text('Test View'), findsOneWidget);
    });

    testWidgets('should show loading indicator whe view state is loading', (
      tester,
    ) async {
      final vm = TestVM(const TestModel(viewStatusLoading));
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM(vm: vm)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should return correct widget when building', (tester) async {
      final vm = TestVM(const TestModel(viewStatusLoading));
      await tester.pumpWidget(
        AppWrapper(
          child: MockTestMVVM(vm: vm, isLoadingManagedAutomatically: false),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test View'), findsOneWidget);
    });

    testWidgets('should call didUpdateWidget in ViewModel', (tester) async {
      final vm = TestVM(const TestModel());
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM(vm: vm)));
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM(vm: vm)));
      expect(vm.didUpdateWidgetCalled, isTrue);
    });

    testWidgets('should call listener when state changes', (tester) async {
      final vm = TestVM(const TestModel());
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM(vm: vm)));
      vm.emit(const TestModel(viewStatusLoading));
      await tester.pump();
      expect(vm.didListenerCalled, isTrue);
    });

    testWidgets('should show dialog when showDialog is called', (tester) async {
      final vm = TestVM(const TestModel());
      await tester.pumpWidget(AppWrapper(child: MockTestMVVM(vm: vm)));
      vm.viewContext.showDialog(
        builder: (context) => const AlertDialog(title: Text('Test Dialog')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Dialog'), findsOneWidget);
    });
  });
}
