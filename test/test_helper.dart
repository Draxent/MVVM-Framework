import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

class TestModel implements Model {
  const TestModel([this.viewStatus = viewStatusInitial]);

  @override
  final ViewStatus viewStatus;

  @override
  Model copyWithViewStatus(ViewStatus viewStatus) => TestModel(viewStatus);
}

class TestView extends ViewWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Test View');
  }
}

class TestVM extends ViewModel<TestModel> {
  TestVM(TestModel model) : super(model: model);

  bool didUpdateWidgetCalled = false;
  bool didListenerCalled = false;

  @override
  void didUpdateWidget(TestModel newModel) {
    super.didUpdateWidget(newModel);
    didUpdateWidgetCalled = true;
  }

  @override
  void listener(TestModel model) {
    super.listener(model);
    didListenerCalled = true;
  }
}

class MockViewContext extends ViewContext {
  MockViewContext()
    : super(
        navigator: NavigatorState(),
        scaffoldMessenger: ScaffoldMessengerState(),
        focusScopeNode: FocusScopeNode(),
        showDialog:
            <T>({
              Offset? anchorPoint,
              Color? barrierColor,
              bool barrierDismissible = true,
              String? barrierLabel,
              required WidgetBuilder builder,
              RouteSettings? routeSettings,
              TraversalEdgeBehavior? traversalEdgeBehavior,
              bool useRootNavigator = true,
              bool useSafeArea = true,
            }) async => null,
        theme: ThemeData(),
        mediaQuery: const MediaQueryData(),
        textDirection: TextDirection.ltr,
        others: const ViewEmptyAdditionalContext(),
      );
}
