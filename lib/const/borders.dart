import 'package:flutter/material.dart';

Border singleBottomBorder(borderColor) {
  return Border(
    bottom: BorderSide(
      color: borderColor,
      width: 2,
    ),
  );
}

Border singleLeftBorder(borderColor) {
  return Border(
    left: BorderSide(
      color: borderColor,
      width: 2,
    ),
  );
}

Border bottomRightTopBorder(borderColor) {
  return Border(
    bottom: BorderSide(
      color: borderColor,
      width: 2,
    ),
    top: BorderSide(
      color: borderColor,
      width: 2,
    ),
    right: BorderSide(
      color: borderColor,
      width: 2,
    ),
  );
}

Border fullBorder(borderColor) {
  return Border.all(width: 2, color: borderColor);
}

OutlineInputBorder outlineInputBorder(borderRadius, borderColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    borderSide: BorderSide(
      color: borderColor,
      width: 2,
    ),
  );
}
