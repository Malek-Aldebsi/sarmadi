import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color? borderColor;
  final int border; // 0 no boarder 1 single border 2 full boarder
  final Color? buttonColor;
  final Widget child;
  final Function? onTap;
  final double width;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;

  const Button(
      {super.key,
      required this.child,
      this.onTap,
      required this.width,
      required this.borderRadius,
      required this.border,
      required this.verticalPadding,
      required this.horizontalPadding,
      this.buttonColor,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              onTap!();
            }
          : null,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.transparent,
            border: border == 0
                ? null
                : border == 1
                    ? Border(
                        bottom: BorderSide(
                          color: borderColor!,
                          width: 1,
                        ),
                      )
                    : Border.all(width: 1, color: borderColor!),
            borderRadius:
                border == 1 ? null : BorderRadius.circular(borderRadius)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: verticalPadding, horizontal: horizontalPadding),
          child: child,
        ),
      ),
    );
  }
}
