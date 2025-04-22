import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_framework/mvvm_framework.dart';

import 'test_helper.dart';

class ViewStatusUnhandledError extends ViewStatusError {
  const ViewStatusUnhandledError();
}

void main() {
  group('ViewModel', () {
    late TestVM uut;
    const initialModel = TestModel();
    const error = ViewStatusError();

    setUp(() {
      uut = TestVM(initialModel);
    });

    test('should set initial state correctly', () {
      expect(uut.state, equals(initialModel));
    });

    test('should call didUpdateWidget when widget is updated', () {
      const newModel = TestModel();
      uut.didUpdateWidget(newModel);
      expect(uut.state, equals(newModel));
    });

    test('should call error handler for specific error type', () {
      bool isErrorHandlerCalled = false;
      uut.registerErrorHandler<ViewStatusError>(
        () => isErrorHandlerCalled = true,
      );
      const failure = ViewStatus.failure(error);
      uut.emit(uut.state.copyWithViewStatus(failure) as TestModel);
      uut.listener(uut.state);
      expect(isErrorHandlerCalled, isTrue);
    });

    test('should handle error generically for unregistered error types', () {
      bool onGenericErrorCalled = false;
      ConfigMVVM.initialize(
        onGenericError: (errorContext) {
          onGenericErrorCalled = true;
          errorContext.emitViewStatus(viewStatusInitial);
        },
      );
      const unhandledError = ViewStatusUnhandledError();
      const failure = ViewStatus.failure(unhandledError);
      uut.emit(uut.state.copyWithViewStatus(failure) as TestModel);
      uut.viewContext = MockViewContext();
      uut.listener(uut.state);
      expect(onGenericErrorCalled, isTrue);
    });

    test(
      'should safely execute a function handling ViewStatusError exceptions',
      () async {
        bool isOnErrorCalled = false;
        await uut.safeExecute(
          () => throw error,
          onError: (_) => isOnErrorCalled = true,
        );
        expect(uut.state.viewStatus.isFailure, isTrue);
        expect(
          (uut.state.viewStatus as ViewStatusFailure).error,
          equals(error),
        );
        expect(isOnErrorCalled, isTrue);
      },
    );

    test(
      'should safely execute a function handling generic exceptions',
      () async {
        bool isOnErrorCalled = false;
        const exceptionMessage = 'Generic exception';
        await uut.safeExecute(
          () => throw Exception(exceptionMessage),
          onError: (_) => isOnErrorCalled = true,
        );
        expect(uut.state.viewStatus.isFailure, isTrue);
        final failure = uut.state.viewStatus as ViewStatusFailure;
        expect(failure.error.message, equals('Exception: $exceptionMessage'));
        expect(isOnErrorCalled, isTrue);
      },
    );
  });
}
