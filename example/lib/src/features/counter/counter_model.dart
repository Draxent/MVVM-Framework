// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

part 'counter_model.freezed.dart';

@freezed
abstract class CounterModel with _$CounterModel implements Model {
  const factory CounterModel({
    @Default(viewStatusLoading) ViewStatus viewStatus,
    @Default(0) int value,
  }) = _CounterModel;

  const CounterModel._();

  @override
  CounterModel copyWithViewStatus(ViewStatus viewStatus) =>
      copyWith(viewStatus: viewStatus);
}
