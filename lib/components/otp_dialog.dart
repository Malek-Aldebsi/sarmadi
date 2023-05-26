import 'package:flutter/material.dart';

Future<bool> showOTPDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required Widget action,
}) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[action],
        ),
      ) ??
      false;
}
