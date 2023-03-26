import 'dart:ui';

import 'package:flutter/material.dart';

popUp(
    context, width, height, child, backgroundColor, borderColor, borderRadius) {
  showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.grey.withOpacity(0.1),
                ),
              ),
            ),
            Directionality(
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
            ),
          ],
        );
      });
}
