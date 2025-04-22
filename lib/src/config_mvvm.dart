import 'package:flutter/material.dart';
import 'package:mvvm_framework/src/model.dart';
import 'package:mvvm_framework/src/view_context.dart';

/// A context object that provides information about a generic error that occurred for a mvvm component.
///
/// This context is used by the [ConfigMVVM.onGenericError] callback to handle generic errors in a centralized way.
class GenericErrorContext<M extends Model> {
  GenericErrorContext({
    required this.error,
    required this.viewContext,
    required this.emitViewStatus,
  });

  /// The error that occured.
  final ViewStatusError error;

  /// The [ViewContext] associated with the current view.
  final ViewContext viewContext;

  /// A callback function that emits a new [ViewStatus].
  final void Function(ViewStatus viewStatus) emitViewStatus;
}

/// A configuration class for the MVVM framework.
///
/// This class allows you to configure global settings for the framework,
/// such as the generic error handler and the loading view.
class ConfigMVVM {
  ConfigMVVM._({required this.onGenericError, required this.loadingView});

  static ConfigMVVM? _instance;

  /// A callback function that is called when a generic error occurs.
  ///
  /// The callback receives a [GenericErrorContext] object that contains information about the error.
  final void Function(GenericErrorContext errorContext) onGenericError;

  /// A function that returns a widget to display while the view is loading.
  final Widget Function(Widget view, bool isLoading) loadingView;

  /// Gets the singleton instance of [ConfigMVVM].
  ///
  /// Throws a [StateError] if the instance has not been initialized.
  static ConfigMVVM get instance {
    if (_instance == null) {
      throw StateError(
        'ConfigMVVM has not been initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initializes the [ConfigMVVM] singleton instance.
  ///
  /// This method should be called once at the beginning of the application.
  static void initialize({
    required void Function(GenericErrorContext errorContext) onGenericError,
    Widget Function(Widget view, bool isLoading)? loadingView,
  }) {
    if (_instance != null) {
      return;
    }
    _instance = ConfigMVVM._(
      onGenericError: onGenericError,
      loadingView: loadingView ?? _buildDefaultLoadingView,
    );
  }

  @visibleForTesting
  static void reset() => _instance = null;

  static Widget _buildDefaultLoadingView(Widget view, bool isLoading) =>
      _DefaultLoadingView(view: view, isLoading: isLoading);
}

/// A default loading view that displays a [CircularProgressIndicator] on top of the current view.
class _DefaultLoadingView extends StatelessWidget {
  const _DefaultLoadingView({required this.view, required this.isLoading});

  final Widget view;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        view,
        if (isLoading)
          const Positioned.fill(
            child: ColoredBox(
              color: Colors.black38,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
