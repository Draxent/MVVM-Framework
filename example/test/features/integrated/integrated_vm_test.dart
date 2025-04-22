import 'package:flutter_test/flutter_test.dart';
import 'package:example/src/features/integrated/integrated_vm.dart';
import 'package:example/src/features/integrated/integrated_model.dart';

void main() {
  group('IntegratedVM', () {
    late IntegratedVM uut;
    const initialModel = IntegratedModel(
      counterInputValue: 0,
      counterSubmittedValue: 0,
      isUserLocationPaused: false,
    );

    setUp(() {
      uut = IntegratedVM(initialModel);
    });

    test('should update initial counter input value', () {
      const newInitValue = 3;
      uut.updateCounterInitialInputValue(newInitValue);
      expect(uut.state.counterInitialInputValue, newInitValue);
    });

    test('should update counter input value', () {
      const newValue = 5;
      uut.updateCounterInputValue(newValue);
      expect(uut.state.counterInputValue, newValue);
    });

    test('should change counter submitted value to input value', () {
      const inputValue = 10;
      uut.updateCounterInputValue(inputValue);
      uut.changeCounterSubmittedValue();
      expect(uut.state.counterSubmittedValue, inputValue);
    });

    test('should toggle user location pause state', () {
      expect(uut.state.isUserLocationPaused, false);
      uut.toggleUserLocation();
      expect(uut.state.isUserLocationPaused, true);
      uut.toggleUserLocation();
      expect(uut.state.isUserLocationPaused, false);
    });
  });
}
