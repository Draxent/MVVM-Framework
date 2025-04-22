import 'package:flutter/material.dart';

class SnackBarLogging extends SnackBar {
  SnackBarLogging(int value, {super.key})
    : super(content: Text('Value $value has been logged!'));
}
