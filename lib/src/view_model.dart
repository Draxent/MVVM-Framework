import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_framework/src/config_mvvm.dart';
import 'package:mvvm_framework/src/model.dart';
import 'package:mvvm_framework/src/view_context.dart';

/// An abstract class that serves as the base for all ViewModels in the MVVM framework.
///
/// ViewModels are responsible for managing the state of the view and handling user interactions.
/// They interact with the model and expose data and methods that the view can use.
abstract class ViewModel<M extends Model> extends Cubit<M> {
  /// Creates a new [ViewModel].
  ViewModel({required M model}) : super(model);

  /// The [ViewContext] for the view.
  late ViewContext viewContext;

  /// A map of error handlers, where the key is the error type and the value is a callback function to handle the error.
  @visibleForTesting
  final Map<Type, VoidCallback> errorHandlers = {};

  /// Registers an error handler for a specific error type.
  void registerErrorHandler<T extends ViewStatusError>(VoidCallback handler) {
    errorHandlers[T] = handler;
  }

  /// Called when the view model is initialized.
  ///
  /// This method can be overridden to perform any necessary initialization tasks, such as loading data from a repository.
  Future<void> onInit() async {}

  /// Called when the widget associated with this [ViewModel] is updated with a new [Model].
  ///
  /// This method is triggered when the widget's configuration changes,
  /// as a new [Model] is provided to the [ViewModel].
  /// It allows the [ViewModel] to respond to changes in the [Model] and update its state accordingly.
  /// Override this method to handle any updates or reinitialization required when the [Model] changes.
  void didUpdateWidget(M newModel) {}

  /// Called when the state of the view model changes.
  ///
  /// This method can be overridden to perform any necessary actions when the state changes.
  /// The [model] parameter is the new state of the view model.
  @mustCallSuper
  void listener(M model) {
    if (model.viewStatus.isFailure) {
      final failure = model.viewStatus as ViewStatusFailure;
      final error = failure.error;
      final errorType = error.runtimeType;
      if (errorHandlers.containsKey(errorType)) {
        errorHandlers[errorType]!();
      } else {
        ConfigMVVM.instance.onGenericError(
          GenericErrorContext<M>(
            error: error,
            viewContext: viewContext,
            emitViewStatus: (viewStatus) =>
                emit(state.copyWithViewStatus(viewStatus) as M),
          ),
        );
      }
    }
  }

  /// Determines whether the [listener] method should be called when the state changes.
  ///
  /// This method can be overridden to control when the [listener] method is called.
  ///
  /// The [oldModel] parameter is the previous state of the view model.
  /// The [newModel] parameter is the new state of the view model.
  ///
  /// **Note**: When overriding this method, be sure to also consider changes to the [ViewStatus].
  ///
  /// Returns true if the [listener] method should be called, false otherwise.
  bool listenWhen(M oldModel, M newModel) => true;

  /// Determines whether the view should be rebuilt when the state changes.
  ///
  /// This method can be overridden to control when the view is rebuilt.
  ///
  /// The [oldModel] parameter is the previous state of the view model.
  /// The [newModel] parameter is the new state of the view model.
  ///
  /// **Note**: When overriding this method, be sure to also consider changes to the [ViewStatus].
  ///
  /// Returns true if the view should be rebuilt, false otherwise.
  bool buildWhen(M oldModel, M newModel) => true;

  /// Executes a given asynchronous action safely, handling exceptions and updating the view state accordingly.
  ///
  /// This method is designed to wrap potentially error-prone asynchronous operations, ensuring that any
  /// exceptions are caught and processed in a consistent manner. If an exception of type [ViewStatusError]
  /// is thrown, it will be handled and the view state will be updated with a failure status. For other
  /// exceptions, a generic [ViewStatusError] will be created and handled similarly.
  /// This method ensures that the view model's state is updated appropriately in case of errors,
  /// allowing the UI to respond to failure scenarios.
  ///
  /// [action]: The asynchronous function to execute.
  /// [onError]: An optional callback that will be invoked with the [ViewStatusError] if an error occurs.
  Future<void> safeExecute(
    Future<void> Function() action, {
    void Function(ViewStatusError)? onError,
  }) async {
    try {
      await action();
    } on ViewStatusError catch (e) {
      final failure = ViewStatus.failure(e);
      onError?.call(e);
      if (!isClosed) {
        emit(state.copyWithViewStatus(failure) as M);
      }
    } catch (e, stackTrace) {
      final error = ViewStatusError(
        message: e.toString(),
        stackTrace: stackTrace,
      );
      final failure = ViewStatus.failure(error);
      onError?.call(error);
      if (!isClosed) {
        emit(state.copyWithViewStatus(failure) as M);
      }
    }
  }
}
