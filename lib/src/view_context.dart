// coverage:ignore-file

import 'package:flutter/material.dart';

/// An abstract class that represents additional context information for a view.
///
/// This class can be extended to provide custom context information to views.
abstract class ViewAdditionalContext {
  const ViewAdditionalContext();
}

/// A class that represents an empty [ViewAdditionalContext].
class ViewEmptyAdditionalContext implements ViewAdditionalContext {
  const ViewEmptyAdditionalContext();
}

/// A class that provides access to various context information for a view.
class ViewContext {
  /// Creates a new [ViewContext].
  const ViewContext({
    required this.navigator,
    required this.scaffoldMessenger,
    required this.focusScopeNode,
    required this.showDialog,
    required this.theme,
    required this.mediaQuery,
    required this.textDirection,
    required this.others,
  });

  /// The [NavigatorState] for the view.
  final NavigatorState navigator;

  /// The [ScaffoldMessengerState] for the view.
  final ScaffoldMessengerState scaffoldMessenger;

  /// The [FocusScopeNode] for the view.
  final FocusScopeNode focusScopeNode;

  /// A function that shows a dialog.
  final Future<T?> Function<T>({
    required WidgetBuilder builder,
    bool barrierDismissible,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea,
    bool useRootNavigator,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  })
  showDialog;

  /// The [ThemeData] for the view.
  final ThemeData theme;

  /// The [MediaQueryData] for the view.
  final MediaQueryData mediaQuery;

  /// The [TextDirection] for the view.
  final TextDirection textDirection;

  /// A custom [ViewAdditionalContext].
  final ViewAdditionalContext others;
}
