import 'package:flutter/material.dart';

TextStyle textStyle(fontOption, screenWidth, screenHeight, fontColor) {
  Map textOptions = {
    1: {'size': 0.018, 'weight': FontWeight.w500},
    2: {'size': 0.021, 'weight': FontWeight.w400},
    3: {'size': 0.03, 'weight': FontWeight.w400},
    4: {'size': 0.039, 'weight': FontWeight.w300},
    5: {'size': 0.048, 'weight': FontWeight.w300},
  };

  double scaleFactor = screenWidth * screenHeight / 2073600;
  double fontSize =
      (scaleFactor / textOptions[fontOption]['size']).round().toDouble();

  FontWeight fontWeight = textOptions[fontOption]['weight'];

  return TextStyle(
      fontFamily: 'Dubai',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: fontColor);
}
