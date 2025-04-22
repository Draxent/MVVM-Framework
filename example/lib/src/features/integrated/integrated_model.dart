// coverage:ignore-file

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

part 'integrated_model.freezed.dart';

@freezed
abstract class IntegratedModel with _$IntegratedModel implements Model {
  const factory IntegratedModel({
    @Default(viewStatusInitial) ViewStatus viewStatus,
    @Default(0) int counterInitialInputValue,
    @Default(0) int counterInputValue,
    @Default(0) int counterSubmittedValue,
    @Default(true) bool isUserLocationPaused,
  }) = _IntegratedModel;

  const IntegratedModel._();

  @override
  IntegratedModel copyWithViewStatus(ViewStatus viewStatus) =>
      copyWith(viewStatus: viewStatus);
}
