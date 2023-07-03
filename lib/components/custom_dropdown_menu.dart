import 'package:flutter/material.dart';
import '../const/borders.dart';
import '../const/colors.dart';

class CustomDropDownMenu extends StatelessWidget {
  TextStyle textStyle;
  TextStyle hintTextStyle;
  double width;
  double menuMaxHeight;
  String? controller;
  List<String> options;
  Color fillColor;
  String hintText;
  InputBorder border;
  InputBorder focusedBorder;
  void Function(String) onChanged;

  CustomDropDownMenu({
    super.key,
    required this.hintText,
    required this.textStyle,
    required this.hintTextStyle,
    required this.width,
    required this.menuMaxHeight,
    required this.controller,
    required this.options,
    required this.fillColor,
    required this.border,
    required this.focusedBorder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: InputDecorator(
            decoration: InputDecoration(
              // contentPadding: EdgeInsets.only(
              //   right: fontSize! * 2,
              //   left: 8,
              // ),
              isDense: true,
              filled: true,
              fillColor: fillColor,
              border: border,
              enabledBorder: border,
              focusedBorder: focusedBorder,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                dropdownColor: fillColor,
                menuMaxHeight: menuMaxHeight,
                style: textStyle,
                hint: Text(
                  hintText,
                  style: hintTextStyle,
                ),
                value: controller,
                isDense: true,
                onChanged: (text) {
                  onChanged(text!);
                },
                items: options.map((String value) {
                  return DropdownMenuItem<String>(
                    alignment: Alignment.centerRight,
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }
}
