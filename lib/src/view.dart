// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An abstract class that serves as the base for all view widgets in the MVVM framework.
///
/// View widgets are responsible for displaying the UI and interacting with the user.
/// They receive data and methods from the [VM] and use them to render the UI.
abstract class ViewWidget<VM> extends StatelessWidget {
  /// Creates a new [ViewWidget].
  const ViewWidget({super.key});

  /// Retrieves the [VM] instance from the [BuildContext].
  ///
  /// This method uses [context.read] to access the [VM] provided by a [BlocProvider].
  /// It allows the [ViewWidget] to easily access the [VM] and its properties.
  VM vm(BuildContext context) => context.read<VM>();

  /// Retrieves the [VM] instance from the [BuildContext] and listens for changes.
  ///
  /// This method uses [context.watch] to access the [VM] provided by a [BlocProvider].
  /// It establishes a subscription to the [VM], ensuring that the [ViewWidget] rebuilds
  /// whenever the [VM] emits a new state.
  /// Use this method when the entire [ViewWidget] depends on the [VM] and should
  /// rebuild whenever the [VM] changes.
  VM watch(BuildContext context) => context.watch<VM>();

  /// Allows the [ViewWidget] to selectively rebuild when specific parts of the [VM] change.
  ///
  /// This method uses [context.select] to listen to specific properties of the [VM].
  /// When the selected property changes, the [ViewWidget] will rebuild.
  /// This is more efficient than rebuilding the entire [ViewWidget] when any part of the [VM] changes.
  R select<R>(BuildContext context, R Function(VM) selector) =>
      context.select<VM, R>(selector);
}
