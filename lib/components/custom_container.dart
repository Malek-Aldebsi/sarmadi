import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Function()? onTap;
  final Widget? child;

  final double? width;
  final double? height;

  final Color? buttonColor;

  final Border? border;
  final double? borderRadius;

  final double? verticalPadding;
  final double? horizontalPadding;

  const CustomContainer({
    super.key,
    this.onTap,
    this.child,
    this.width,
    this.height,
    this.buttonColor,
    this.border,
    this.borderRadius,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: buttonColor,
          border: border,
          borderRadius: borderRadius == null
              ? null
              : BorderRadius.circular(borderRadius!)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: MaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? 0,
                horizontal: horizontalPadding ?? 0),
            onPressed: onTap,
            child: child),
      ),
    );
  }
}
