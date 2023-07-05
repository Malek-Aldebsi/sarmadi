import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class CustomTextField extends StatefulWidget {
  final dynamic? controller;

  final double? width;

  final double? fontOption;
  final Color? fontColor;
  final TextAlign? textAlign;

  final bool? obscure;
  final bool? readOnly;

  final FocusNode? focusNode;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  final TextInputType? keyboardType;
  final String? keyboardSubject;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final Color? backgroundColor;

  final double? horizontalPadding;
  final double? verticalPadding;

  final bool? isDense;

  final String? errorText;
  final String? hintText;
  final Color? hintTextColor;

  final List<String>? variables;

  final Widget? suffixIcon;
  final Widget? prefixIcon;

  final OutlineInputBorder? border;
  final OutlineInputBorder? focusedBorder;

  const CustomTextField({
    super.key,
    this.controller,
    this.width,
    this.fontOption,
    this.fontColor,
    this.textAlign,
    this.obscure,
    this.readOnly,
    this.focusNode,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.keyboardSubject,
    this.onChanged,
    this.onSubmitted,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.isDense,
    this.errorText,
    this.hintText,
    this.hintTextColor,
    this.variables,
    this.suffixIcon,
    this.prefixIcon,
    this.border,
    this.focusedBorder,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return widget.keyboardSubject == 'math'
        ? Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: widget.width,
              child: MathField(
                controller: widget.controller,
                keyboardType: MathKeyboardType.expression,
                variables: widget.variables!,
                decoration: InputDecoration(
                  isDense: widget.isDense,
                  counterStyle: textStyle(
                      widget.fontOption, width, height, widget.fontColor),
                  filled: true,
                  fillColor: widget.backgroundColor,
                  border: widget.border,
                  focusedBorder: widget.focusedBorder,
                ),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
              ),
            ),
          )
        : SizedBox(
            width: widget.width,
            child: TextField(
              controller: widget.controller,
              style:
                  textStyle(widget.fontOption, width, height, widget.fontColor),
              textAlign: widget.textAlign ?? TextAlign.start,
              cursorColor: kDarkPurple,
              obscureText: widget.obscure ?? false,
              readOnly: widget.readOnly ?? false,
              focusNode: widget.focusNode,
              minLines: widget.minLines ?? 1,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              keyboardType: widget.keyboardType ?? TextInputType.multiline,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.backgroundColor,

                counterText: '',

                contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding ?? 0,
                    vertical: widget.verticalPadding ?? 0),
                isDense: widget.isDense,

                errorText: widget.errorText,
                errorStyle: textStyle(5, width, height, kRed),
                hintText: widget.hintText,
                hintStyle: textStyle(
                    widget.fontOption, width, height, widget.hintTextColor),

                suffixIcon: widget.suffixIcon,
                prefixIcon: widget.prefixIcon,

                border: widget.border, //normal border
                enabledBorder: widget.border, //enabled border
                focusedBorder: widget.focusedBorder, //focused border
              ),
            ),
          );
  }
}
