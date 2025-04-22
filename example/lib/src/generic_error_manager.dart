// coverage:ignore-file

import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/widgets/widgets.dart';

class ViewStatusNetworkError extends ViewStatusError {
  const ViewStatusNetworkError({super.message});
}

class GenericErrorManager {
  const GenericErrorManager(this.errorContext);

  final GenericErrorContext errorContext;

  void manageError() {
    if (errorContext.error is ViewStatusNetworkError) {
      errorContext.viewContext.scaffoldMessenger
          .showSnackBar(
            SnackBarDefault(errorContext.error.message ?? 'Network Error'),
          )
          .closed
          .then((_) => errorContext.emitViewStatus(viewStatusInitial));
    } else {
      errorContext.viewContext
          .showDialog(
            builder:
                (_) => ErrorDialog(
                  msg: errorContext.error.message ?? 'Error',
                  description: errorContext.error.stackTrace?.toString() ?? '',
                  navigator: errorContext.viewContext.navigator,
                ),
          )
          .then((_) => errorContext.emitViewStatus(viewStatusInitial));
    }
  }
}
