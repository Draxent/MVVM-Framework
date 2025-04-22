import 'package:flutter_test/flutter_test.dart';
import 'package:example/src/features/counter/counter_repository.dart';

void main() {
  group('CounterRepository', () {
    late CounterRepository uut;

    setUpAll(() {
      uut = CounterRepository();
    });

    test('should return the correct initial value', () async {
      final value = await uut.getValue();
      expect(value, 1);
    });

    test('should update the value correctly', () async {
      await uut.updateValue(5);
      final value = await uut.getValue();
      expect(value, 5);
    });

    test(
      'should throw an exception when isTriggeringException is true',
      () async {
        expect(() => uut.updateValue(5, true), throwsA(isA<Exception>()));
      },
    );

    test('should log the value', () async {
      await uut.logValue();
    });
  });
}
