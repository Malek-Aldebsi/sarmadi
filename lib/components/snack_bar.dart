import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content:
          Directionality(textDirection: TextDirection.rtl, child: Text(text)),
    ),
  );
}
