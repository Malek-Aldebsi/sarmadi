import 'package:flutter/material.dart';
import '../const.dart';

class CustomCheckBox extends StatelessWidget {
  final double width;
  final Function onTap;
  final bool checked;
  const CustomCheckBox(
      {super.key,
      required this.width,
      required this.onTap,
      required this.checked});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: checked ? kBlack : kOffWhite),
            shape: BoxShape.circle,
            color: checked ? kPurple : kLightGray),
        child: Padding(
          padding: EdgeInsets.all(width / 500),
          child: Icon(
            Icons.check,
            color: checked ? kBlack : kOffWhite,
            size: width / 50,
          ),
        ),
      ),
    );
  }
}
