import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double dashHeight;
  final double dashWidth;
  final Color dashColor;
  final double fillRate;
  final Axis direction;

  const CustomDivider(
      {super.key,
      this.dashHeight = 1,
      this.dashWidth = 8,
      this.dashColor = Colors.black,
      this.fillRate = 0.5,
      this.direction = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();
        final dCount = (boxSize * fillRate / dashWidth).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(dCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashWidth : dashHeight,
              height: direction == Axis.horizontal ? dashHeight : dashWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          }),
        );
      },
    );
  }
}
