import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/src/widgets/error_dialog.dart';

void main() {
  group('ErrorDialog', () {
    testWidgets(
      'should display the correct message and dismisses on button press',
      (tester) async {
        const message = 'Error message.';
        const description = 'Error description.';
        final testObserver = _TestNavigatorObserver();

        await tester.pumpWidget(
          MaterialApp(
            home: Navigator(
              observers: [testObserver],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      body: Builder(
                        builder: (context) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => ErrorDialog(
                                        msg: message,
                                        description: description,
                                        navigator: Navigator.of(context),
                                      ),
                                );
                              },
                              child: const Text('Show Error Dialog'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Show Error Dialog'));
        await tester.pumpAndSettle();
        expect(find.text('Error'), findsOneWidget);
        expect(find.text('$message\n$description'), findsOneWidget);
        expect(find.text('Ok'), findsOneWidget);
        await tester.tap(find.text('Ok'));
        await tester.pumpAndSettle();
        expect(testObserver.didPopCalled, true);
      },
    );
  });
}

class _TestNavigatorObserver extends NavigatorObserver {
  bool didPopCalled = false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    didPopCalled = true;
  }
}
