import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kLightBlack = const Color(0XFF181920);
Color kLightGray = const Color(0XFF252A34);
Color kBlack = const Color(0XFF0F0F0F);
Color kWhite = const Color(0XFFFFFFFF);
Color kPurple = const Color(0XFF6B6AEF);
Color kGray = const Color(0XFF343943);
Color kOffBlack = const Color(0XFF56585C);
Color kSkin = const Color(0XFFFFB997);
Color kDarkGreen = const Color(0XFF3FAD47);
Color kDarkRed = const Color(0XFFEB4335);
Color kLightGreen = const Color(0XFF3EC28F);
Color kDarkPink = const Color(0XFFC23E9D);
Color kDarkYellow = const Color(0XFFF5B700);
Color kOffPurple = const Color(0XFFA1A0FF);

///////////////////

Color kDarkPurple = const Color(0XFF3A398C);
Color kOrange = const Color(0XFFAF6C00);
// Color kDarkGreen = const Color(0XFF009D81);
Color kGreen = const Color(0XFF95D975);
Color kPink = const Color(0xFF9A4CB6);
Color kBlue = const Color(0XFF0C5CB7);
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
