import 'package:injectable/injectable.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/integrated/integrated_model.dart';

@injectable
class IntegratedVM extends ViewModel<IntegratedModel> {
  IntegratedVM(@factoryParam IntegratedModel model) : super(model: model);

  void updateCounterInitialInputValue(int value) =>
      emit(state.copyWith(counterInitialInputValue: value));

  void updateCounterInputValue(int value) =>
      emit(state.copyWith(counterInputValue: value));

  void changeCounterSubmittedValue() =>
      emit(state.copyWith(counterSubmittedValue: state.counterInputValue));

  void toggleUserLocation() =>
      emit(state.copyWith(isUserLocationPaused: !state.isUserLocationPaused));
}
