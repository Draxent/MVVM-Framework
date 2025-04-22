import 'package:injectable/injectable.dart';
import 'package:example/src/core/core.dart';

@singleton
class CounterRepository {
  int _value = 1;

  Future<int> getValue() async {
    await Utils.delay();
    return _value;
  }

  Future<void> updateValue(
    int newValue, [
    bool isTriggeringException = false,
  ]) async {
    await Utils.delay();
    _value = newValue;
    if (isTriggeringException) {
      throw Exception('Error message');
    }
  }

  Future<void> logValue() async {
    // Log the value into the server
    await Utils.delay();
  }
}
