// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:mvvm_framework/mvvm_framework.dart';
import 'package:example/src/app.dart';
import 'package:example/src/core/injection.dart';
import 'package:example/src/generic_error_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConfigMVVM.initialize(
    onGenericError:
        (errorContext) => GenericErrorManager(errorContext).manageError(),
  );
  await configureDependencies();
  runApp(const MyApp());
}
