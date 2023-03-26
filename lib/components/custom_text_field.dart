import 'package:flutter/material.dart';

import '../const/colors.dart';
import '../const/fonts.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;

  final double? width;

  final double? fontOption;
  final Color? fontColor;
  final TextAlign? textAlign;

  final bool? obscure;
  final bool? readOnly;

  final FocusNode? focusNode;

  final int? maxLines;
  final int? maxLength;

  final TextInputType? keyboardType;

  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  final Color? backgroundColor;

  final double? horizontalPadding;
  final double? verticalPadding;

  final bool? isDense;

  final String? innerText;

  final String? errorText;
  final String? hintText;
  final Color? hintTextColor;

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
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.backgroundColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.isDense,
    this.innerText,
    this.errorText,
    this.hintText,
    this.hintTextColor,
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
    super.initState(); //TODO: check without
    widget.controller!.text = widget.innerText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: widget.width,
      child: TextField(
        controller: widget.controller,
        style: textStyle(widget.fontOption, width, height, widget.fontColor),
        textAlign: widget.textAlign ?? TextAlign.start,
        cursorColor: kDarkPurple,
        obscureText: widget.obscure ?? false,
        readOnly: widget.readOnly ?? false,
        focusNode: widget.focusNode,
        minLines: 1,
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
          hintStyle:
              textStyle(widget.fontOption, width, height, widget.hintTextColor),

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
