import 'package:flutter/material.dart';

popUp(
    context, width, height, child, backgroundColor, borderColor, borderRadius) {
  showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  borderRadius,
                ),
              ),
            ),
            content: SizedBox(width: width, height: height, child: child),
          ),
        );
      });
}
