import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

import 'const/colors.dart';
import 'const/fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(body: Test()),
  ));
}

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  FocusNode focus = FocusNode();
  bool open = false;
  @override
  void initState() {
    super.initState();
    focus.addListener(() {
      setState(() {
        if (focus.hasListeners) open = !open;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: 80,
              width: 500,
              color: Colors.deepPurpleAccent,
            ),
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      width: 500,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      height: 100,
                      width: 500,
                      child: MathField(
                        focusNode: focus,
                        keyboardType: MathKeyboardType.expression,
                        variables: const ['x', 'y', 'z', 'C', 't'],
                        decoration: InputDecoration(
                          isDense: true,
                          counterStyle: textStyle(3, 750, 1200, kWhite),
                        ),
                        onChanged: (String text) {},
                        onSubmitted: (String text) {},
                      ),
                    ),
                    Container(
                      height: 300,
                      width: 500,
                      color: Colors.green,
                    ),
                    Container(
                      height: 300,
                      width: 500,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 300,
                      width: 500,
                      color: Colors.red,
                    ),
                    if (open)
                      Container(
                        height: 800,
                        width: 500,
                        color: Colors.green,
                      )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
