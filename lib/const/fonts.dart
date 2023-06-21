import 'package:flutter/material.dart';

TextStyle textStyle(fontSize, screenWidth, screenHeight, fontColor,
    [fontWeight]) {
  Map textOptions = {
    0: {'size': 0.009, 'weight': FontWeight.w500},
    6: {'size': 0.012, 'weight': FontWeight.w500},
    1: {'size': 0.018, 'weight': FontWeight.w500},
    2: {'size': 0.021, 'weight': FontWeight.w400},
    3: {'size': 0.03, 'weight': FontWeight.w400},
    4: {'size': 0.039, 'weight': FontWeight.w300},
    5: {'size': 0.048, 'weight': FontWeight.w300},
  };

  // double scaleFactor = screenWidth * screenHeight / 2073600;
  double scaleFactor = screenWidth / 2700;
  double fontSize_ =
      (scaleFactor / textOptions[fontSize]['size']).round().toDouble();

  FontWeight fontWeight_ = textOptions[fontWeight ?? fontSize]['weight'];
  return TextStyle(
      fontFamily: 'Dubai',
      fontSize: fontSize_,
      fontWeight: fontWeight_,
      color: fontColor);
}
