import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kBlack = const Color(0XFF181920);
Color kWhite = const Color(0XFFFFFFFF);
Color kPurple = const Color(0XFF6B6AEF);
// Color kOffPurple = const Color(0XFFA1A0FF);
Color kGray = const Color(0XFF252A34);
Color kOffWhite = const Color(0XFF9E9E9E);
Color kRed = const Color(0XFFF44336);

TextStyle textStyle = GoogleFonts.notoKufiArabic(
  fontWeight: FontWeight.w300,
  color: kWhite,
);

OutlineInputBorder roundedInputBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}

OutlineInputBorder roundedFocusedBorder() {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    borderSide: BorderSide(
      color: kPurple,
      width: 1,
    ),
  );
}

OutlineInputBorder inputBorder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  );
}

OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: kPurple,
      width: 1,
    ),
  );
}
