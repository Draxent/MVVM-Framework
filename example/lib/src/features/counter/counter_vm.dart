import 'package:injectable/injectable.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/features/counter/counter_model.dart';
import 'package:example/src/features/counter/counter_repository.dart';
import 'package:example/src/widgets/widgets.dart';

typedef OnUpdateCounter = void Function(int);

@injectable
class CounterVM extends ViewModel<CounterModel> {
  CounterVM(
    this._counterRepository,
    @factoryParam CounterModel model,
    @factoryParam this.onUpdateCounter,
  ) : super(model: model);

  final CounterRepository _counterRepository;
  final OnUpdateCounter? onUpdateCounter;

  @override
  Future<void> onInit() async {
    final value = await _counterRepository.getValue();
    emit(state.copyWith(value: value, viewStatus: viewStatusSuccess));
  }

  @override
  Future<void> didUpdateWidget(CounterModel newModel) async {
    if (state.value != newModel.value) {
      emit(state.copyWith(viewStatus: viewStatusLoading));
      await _counterRepository.updateValue(newModel.value, false);
      emit(
        state.copyWith(value: newModel.value, viewStatus: viewStatusSuccess),
      );
    }
  }

  @override
  Future<void> listener(CounterModel model) async {
    super.listener(model);

    /// While the check and logging could be integrated into CounterRepository.updateValue,
    /// they are demonstrated here to illustrate listener usage
    if (model.viewStatus.isSuccess && model.value % 3 == 0) {
      await _counterRepository.logValue();
      viewContext.scaffoldMessenger.showSnackBar(
        SnackBarDefault('Value ${model.value} has been logged!'),
      );
    }
  }

  Future<void> increment([bool isTriggeringException = false]) async {
    emit(state.copyWith(viewStatus: viewStatusLoading));
    final newValue = state.value + 1;
    await _counterRepository.updateValue(newValue, isTriggeringException);
    onUpdateCounter?.call(newValue);
    emit(state.copyWith(value: newValue, viewStatus: viewStatusSuccess));
  }

  Future<void> incrementWithException() => safeExecute(() => increment(true));
}
