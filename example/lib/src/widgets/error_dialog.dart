import 'package:flutter/material.dart';

class ErrorDialog extends AlertDialog {
  ErrorDialog({
    required String msg,
    required String description,
    required NavigatorState navigator,
    super.key,
  }) : super(
         title: const Text('Error'),
         content: Text('$msg\n$description'),
         actions: [
           TextButton(
             onPressed: () {
               navigator.pop();
             },
             child: const Text('Ok'),
           ),
         ],
       );
}
