// import 'package:flutter/material.dart';
// import '../const/colors.dart';
//
// TODO: check
//
// class CustomDropDownMenu extends StatelessWidget {
//   final String? hintText;
//   final double? fontSize;
//   final double? width;
//   final String? controller;
//   final List<String>? options;
//   final void Function(String)? onChanged;
//   final Widget? icon;
//   final String? errorText;
//   final Color? fillColor;
//   final Color? hintTextColor;
//
//   const CustomDropDownMenu(
//       {super.key,
//       this.hintText,
//       this.fontSize,
//       this.width,
//       this.controller,
//       this.options,
//       this.onChanged,
//       this.icon,
//       this.errorText,
//       this.fillColor,
//       this.hintTextColor});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: InputDecorator(
//             decoration: InputDecoration(
//               contentPadding: EdgeInsets.only(
//                 right: fontSize! * 2,
//                 left: 8,
//               ),
//               filled: true,
//               fillColor: fillColor,
//               errorText: errorText,
//               errorStyle:
//                   textStyle.copyWith(fontSize: fontSize! / 1.5, color: kRed),
//               border: roundedInputBorder(), //normal border
//               enabledBorder: roundedInputBorder(), //enabled border
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 dropdownColor: kLightGray,
//                 menuMaxHeight: fontSize! * 14,
//                 style: textStyle.copyWith(fontSize: fontSize),
//                 hint: Text(
//                   hintText!,
//                   style: textStyle.copyWith(
//                       fontSize: fontSize, color: hintTextColor),
//                 ),
//                 value: controller,
//                 isDense: false,
//                 icon: icon,
//                 onChanged: (text) {
//                   onChanged!(text!);
//                 },
//                 items: options!.map((String value) {
//                   return DropdownMenuItem<String>(
//                     alignment: Alignment.centerRight,
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//             )),
//       ),
//     );
//   }
// }
