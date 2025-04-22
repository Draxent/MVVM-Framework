import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_framework/src/config_mvvm.dart';
import 'package:mvvm_framework/src/view_context.dart';
import 'package:mvvm_framework/src/model.dart';

import 'app_wrapper.dart';

void main() {
  group('ConfigMVVM', () {
    tearDown(() => ConfigMVVM.reset());

    test('should throw a StateError if initialize has not been called', () {
      expect(() => ConfigMVVM.instance, throwsA(isA<StateError>()));
    });

    test('should set the instance', () {
      onGenericError(GenericErrorContext context) {}
      loadingView(Widget view, bool isLoading) => const Placeholder();

      ConfigMVVM.initialize(
        onGenericError: onGenericError,
        loadingView: loadingView,
      );

      expect(ConfigMVVM.instance, isNotNull);
      expect(ConfigMVVM.instance.onGenericError, onGenericError);
      expect(ConfigMVVM.instance.loadingView, loadingView);
    });

    test(
      'should use default loading view if no custom loading view is provided',
      () {
        onGenericError(GenericErrorContext context) {}
        ConfigMVVM.initialize(onGenericError: onGenericError);

        expect(ConfigMVVM.instance.loadingView, isNotNull);
      },
    );

    test('should handle GenericErrorContext correctly', () {
      final errorContext = GenericErrorContext(
        error: const ViewStatusError(), // Adjusted to match the constructor
        viewContext: ViewContext(
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
              }) => Future.value(null),
          theme: ThemeData(),
          mediaQuery: const MediaQueryData(),
          textDirection: TextDirection.ltr,
          others: const ViewEmptyAdditionalContext(),
        ),
        emitViewStatus: (viewStatus) {},
      );

      expect(errorContext.error, isA<ViewStatusError>());
      expect(errorContext.viewContext, isA<ViewContext>());
    });

    testWidgets('should display default loading view', (tester) async {
      ConfigMVVM.initialize(onGenericError: (_) {});
      final widget = ConfigMVVM.instance.loadingView(const Placeholder(), true);
      await tester.pumpWidget(AppWrapper(child: widget));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
