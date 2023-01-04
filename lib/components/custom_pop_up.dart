import 'package:flutter/material.dart';

popUp(context, width, title, child) {
  showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: child,
                ),
              ),
            ),
          ),
        );
      });
}
