import 'package:mvvm_framework/src/config_mvvm.dart';
import 'package:mvvm_framework/src/model.dart';
import 'package:mvvm_framework/src/view.dart';
import 'package:mvvm_framework/src/view_model.dart';
import 'package:mvvm_framework/src/view_context.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

/// A base class for creating MVVM (Model-View-ViewModel) widgets in Flutter.
///
/// This class simplifies the process of creating widgets that follow the MVVM architectural pattern.
/// It handles the creation of the [ViewModel], provides access to the [ViewContext], and manages the lifecycle of the [View].
abstract class MVVM<
  M extends Model,
  V extends ViewWidget,
  VM extends ViewModel<M>
>
    extends StatefulWidget {
  /// Creates a new MVVM widget.
  const MVVM({
    required this.view,
    required this.viewModel,
    this.isLoadingManagedAutomatically = true,
    this.viewContextBuilder,
    super.key,
  });

  /// The widget that represents the view.
  final V view;

  /// The view model that provides data and logic to the view.
  final VM viewModel;

  /// Indicates whether the framework should automatically manage the loading state.
  final bool isLoadingManagedAutomatically;

  /// A function that creates a custom [ViewAdditionalContext].
  final ViewAdditionalContext Function(BuildContext context)?
  viewContextBuilder;

  @override
  State<MVVM<M, V, VM>> createState() => MVVMState<M, V, VM>();
}

/// The state for the [MVVM] widget.
class MVVMState<M extends Model, V extends ViewWidget, VM extends ViewModel<M>>
    extends State<MVVM<M, V, VM>> {
  /// The view model for the widget.
  late final VM viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    viewModel.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.close();
  }

  @override
  void didUpdateWidget(covariant MVVM<M, V, VM> oldWidget) {
    super.didUpdateWidget(oldWidget);
    viewModel.didUpdateWidget(widget.viewModel.state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    viewModel.viewContext = ViewContext(
      navigator: Navigator.of(context),
      scaffoldMessenger: ScaffoldMessenger.of(context),
      focusScopeNode: FocusScope.of(context),
      showDialog:
          <T>({
            required WidgetBuilder builder,
            bool barrierDismissible = true,
            Color? barrierColor,
            String? barrierLabel,
            bool useSafeArea = true,
            bool useRootNavigator = true,
            RouteSettings? routeSettings,
            Offset? anchorPoint,
            TraversalEdgeBehavior? traversalEdgeBehavior,
          }) => showDialog<T>(
            context: context,
            builder: builder,
            barrierDismissible: barrierDismissible,
            barrierColor: barrierColor,
            barrierLabel: barrierLabel,
            useSafeArea: useSafeArea,
            useRootNavigator: useRootNavigator,
            routeSettings: routeSettings,
            anchorPoint: anchorPoint,
            traversalEdgeBehavior: traversalEdgeBehavior,
          ),
      theme: Theme.of(context),
      mediaQuery: MediaQuery.of(context),
      textDirection: Directionality.of(context),
      others:
          widget.viewContextBuilder?.call(context) ??
          const ViewEmptyAdditionalContext(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocConsumer<VM, M>(
        listener: (_, state) => viewModel.listener(state),
        builder: _onBuild,
        bloc: viewModel,
        listenWhen: viewModel.listenWhen,
        buildWhen: viewModel.buildWhen,
      ),
    );
  }

  Widget _onBuild(BuildContext context, M state) {
    return widget.isLoadingManagedAutomatically
        ? ConfigMVVM.instance.loadingView(
          widget.view,
          state.viewStatus.isLoading,
        )
        : widget.view;
  }
}
