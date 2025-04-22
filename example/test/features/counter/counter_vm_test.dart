import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/counter/counter_vm.dart';
import 'package:example/src/features/counter/counter_model.dart';

import '../../mocks.mocks.dart';

void main() {
  group('CounterVM', () {
    late final MockCounterRepository counterRepository;
    late final CounterVM uut;
    const initValue = 7;

    setUpAll(() async {
      counterRepository = MockCounterRepository();
      when(counterRepository.getValue()).thenAnswer((_) async => initValue);
      when(counterRepository.logValue()).thenAnswer((_) async {});
      uut = CounterVM(counterRepository, const CounterModel(), (_) {});
      uut.viewContext = MockViewContext();
      final scaffoldMessenger = MockScaffoldMessengerState();
      when(
        scaffoldMessenger.showSnackBar(any),
      ).thenReturn(MockScaffoldFeatureController());
      when(
        uut.viewContext.scaffoldMessenger,
      ).thenReturn(MockScaffoldMessengerState());
    });

    test('should start with loading status', () async {
      expect(uut.state.viewStatus, viewStatusLoading);
    });

    test('should have initial value', () async {
      await uut.onInit();
      expect(uut.state.value, initValue);
      expect(uut.state.viewStatus, viewStatusSuccess);
    });

    test('should increment value', () async {
      await uut.onInit();
      await uut.increment();
      expect(uut.state.value, initValue + 1);
      verify(counterRepository.updateValue(initValue + 1)).called(1);
    });

    test('should call logValue when value is divisible by 3', () async {
      await uut.listener(
        uut.state.copyWith(value: 8, viewStatus: viewStatusSuccess),
      );
      verifyNever(counterRepository.logValue());
      await uut.listener(
        uut.state.copyWith(value: 9, viewStatus: viewStatusSuccess),
      );
      verify(counterRepository.logValue()).called(1);
    });

    test(
      'should handle exception when incrementWithException is called',
      () async {
        when(
          counterRepository.updateValue(any, true),
        ).thenThrow(Exception('Test Exception'));
        await uut.incrementWithException();
        expect(uut.state.viewStatus.isFailure, true);
        expect(
          (uut.state.viewStatus as ViewStatusFailure).error.message,
          'Exception: Test Exception',
        );
      },
    );

    test(
      'should update state when didUpdateWidget is called with a new value',
      () async {
        const newValue = 10;
        final newModel = uut.state.copyWith(value: newValue);
        await uut.didUpdateWidget(newModel);
        expect(uut.state.viewStatus, viewStatusSuccess);
        expect(uut.state.value, newValue);
        verify(counterRepository.updateValue(newValue, false)).called(1);
      },
    );
  });
}
