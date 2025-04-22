// coverage:ignore-file

part 'model_freezed.dart';

/// The base class for all models in the MVVM framework.
///
/// Models represent the data and state of the application.
abstract class Model {
  /// The current view status of the model.
  ViewStatus get viewStatus;

  /// Creates a new instance of the model with the given view status.
  Model copyWithViewStatus(ViewStatus viewStatus);
}

/// Represents the status of a view.
class ViewStatus with _$ViewStatus {
  const factory ViewStatus.initial() = ViewStatusInitial;
  const factory ViewStatus.loading() = ViewStatusLoading;
  const factory ViewStatus.success() = ViewStatusSuccess;
  const factory ViewStatus.failure(ViewStatusError error) = ViewStatusFailure;
}

/// A base class for representing errors in the MVVM framework.
///
/// This class is designed to encapsulate error details that can occur during the lifecycle of a view.
/// Users can extend this class to define custom error types specific to their application needs.
///
/// Example:
/// ```dart
/// class ViewStatusValidationError extends ViewStatusError {
///   const ViewStatusValidationError({required super.message});
/// }
/// ```
///
/// Properties:
/// - [message]: A human-readable description of the error.
/// - [stackTrace]: The stack trace associated with the error, if available.
class ViewStatusError {
  const ViewStatusError({this.message, this.stackTrace});

  final String? message;
  final StackTrace? stackTrace;

  @override
  String toString() => 'ViewStatusError: $message';
}

/// A constant for the initial view status.
const viewStatusInitial = ViewStatusInitial();

/// A constant for the loading view status.
const viewStatusLoading = ViewStatusLoading();

/// A constant for the success view status.
const viewStatusSuccess = ViewStatusSuccess();

/// A constant for the failure view status with an empty error message.
const viewStatusFailure = ViewStatusFailure(ViewStatusError());

/// Provides extension methods for the [ViewStatus] class.
extension ViewStatusExtension on ViewStatus {
  /// Returns true if the view status is initial.
  bool get isInitial => this is ViewStatusInitial;

  /// Returns true if the view status is loading.
  bool get isLoading => this is ViewStatusLoading;

  /// Returns true if the view status is successful.
  bool get isSuccess => this is ViewStatusSuccess;

  /// Returns true if the view status is failure.
  bool get isFailure => this is ViewStatusFailure;
}
