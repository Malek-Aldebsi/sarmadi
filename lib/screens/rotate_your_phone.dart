import 'package:flutter/material.dart';
import '../const/colors.dart';

class RotateYourPhone extends StatefulWidget {
  const RotateYourPhone({Key? key}) : super(key: key);

  @override
  State<RotateYourPhone> createState() => _RotateYourPhoneState();
}

class _RotateYourPhoneState extends State<RotateYourPhone>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      lowerBound: 0,
      upperBound: 0.5,
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _startRotation();
  }

  void _startRotation() async {
    while (true) {
      if (!_controller.isAnimating) {
        _controller.reset();
        _controller.forward();
      }
      await Future.delayed(const Duration(seconds: 4)); // Add a 3-second delay
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: kDarkGray,
        body: SizedBox(
          height: height,
          width: width,
          child: Center(
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: (_controller.value) *
                          3.14159, // Rotate 180 degrees (pi radians)
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.phone_iphone,
                    size: width * 0.5,
                    color: kLightPurple,
                  ))),
        ));
  }
}
