import 'package:flutter/material.dart';

// RegExp exp = RegExp(r"^([+]962|0)7(7|8|9)[0-9]{7}");
// print(exp.hasMatch('+962785783785'));
// RegExp phone = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
// RegExp emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:sarmadi/const/colors.dart';

import 'const/fonts.dart';

int calculateStringWidth(str, fontOption, screenWidth, screenHeight) {
  final textPainter = TextPainter(
    text: TextSpan(
        text: str,
        style: textStyle(fontOption, screenWidth, screenHeight, kWhite)),
    textDirection: TextDirection.rtl,
  );

  textPainter.layout();
  final textWidth = textPainter.computeLineMetrics()[0].width.round() + 1;
  return textWidth;
}

double calculateBaseLine(str, fontOption, screenWidth, screenHeight) {
  final textPainter = TextPainter(
    text: TextSpan(
        text: str,
        style: textStyle(fontOption, screenWidth, screenHeight, kWhite)),
    textDirection: TextDirection.rtl,
  );
  textPainter.layout();
  final baseline = textPainter.computeLineMetrics()[0].baseline;
  return baseline;
}

List longLine(
    str, widgetWidth, fontOption, screenWidth, screenHeight, fontColor,
    [version = 0]) {
  if (version == 0) {
    String extra = '';
    while (widgetWidth <
        calculateStringWidth(str, fontOption, screenWidth, screenHeight)) {
      int spaceIndex = str.lastIndexOf(' ');
      extra = str.substring(spaceIndex) + extra;
      str = str.substring(0, spaceIndex);
    }

    if (extra == '') {
      return [
        Text(str,
            style: textStyle(fontOption, screenWidth, screenHeight, fontColor))
      ];
    }
    return [
      Text(str,
          style: textStyle(fontOption, screenWidth, screenHeight, fontColor)),
      ...longLine(
          extra, widgetWidth, fontOption, screenWidth, screenHeight, fontColor)
    ];
  } else {
    String extra = '';
    while (widgetWidth <
        calculateStringWidth(str, fontOption, screenWidth, screenHeight)) {
      int spaceIndex = str.lastIndexOf(' ');
      extra = str.substring(spaceIndex) + extra;
      str = str.substring(0, spaceIndex);
    }

    if (extra == '') {
      return [str];
    }
    return [
      str,
      ...longLine(extra, widgetWidth, fontOption, screenWidth, screenHeight,
          fontColor, 1)
    ];
  }
}

List<Widget> mathLine(
    str, widgetWidth, fontOption, screenWidth, screenHeight, fontColor) {
  int index = str.indexOf(r'@');
  String text = str.substring(0, index);
  String math = str
      .substring(index + 1, str.indexOf(r'@', index + 1))
      .replaceAll('#', ' ');
  String text2 = str.substring(str.indexOf(r'@', index + 1) + 1);

  if (!text2.contains(r'@')) {
    return [
      Text(text,
          style: textStyle(fontOption, screenWidth, screenHeight, fontColor)),
      Baseline(
        baseline:
        calculateBaseLine(text, fontOption, screenWidth, screenHeight),
        baselineType: TextBaseline.alphabetic,
        child: Math.tex(math,
            mathStyle: MathStyle.text,
            textStyle:
            textStyle(fontOption, screenWidth, screenHeight, fontColor)),
      ),
      Text(text2,
          style: textStyle(fontOption, screenWidth, screenHeight, fontColor))
    ];
  }
  return [
    Text(text,
        style: textStyle(fontOption, screenWidth, screenHeight, fontColor)),
    Baseline(
      baseline: calculateBaseLine(text, fontOption, screenWidth, screenHeight),
      baselineType: TextBaseline.alphabetic,
      child: Math.tex(math,
          mathStyle: MathStyle.text,
          textStyle:
          textStyle(fontOption, screenWidth, screenHeight, fontColor)),
    ),
    ...mathLine(
        text2, widgetWidth, fontOption, screenWidth, screenHeight, fontColor)
  ];
}

Widget stringWithLatex(
    str, widgetWidth, fontOption, screenWidth, screenHeight, fontColor) {
  List<Widget> widgets = [];
  str = str.split('\n');
  for (String line in str) {
    if (line.contains(r'$')) {
      while (line.contains(r'$')) {
        line = line.replaceRange(
            line.indexOf(r'$'),
            line.indexOf(r'$', line.indexOf(r'$') + 1) + 1,
            line
                .substring(line.indexOf(r'$'),
                line.indexOf(r'$', line.indexOf(r'$') + 1) + 1)
                .replaceAll(' ', '#'));
        line = line.replaceFirst(r'$', '@');
        line = line.replaceFirst(r'$', '@');
      }

      List tempLines = [
        ...longLine(line, widgetWidth, fontOption, screenWidth, screenHeight,
            fontColor, 1)
      ];
      print(tempLines);

      for (String tempLine in tempLines) {
        if (tempLine.contains('@')) {
          widgets = [
            ...widgets,
            ...mathLine(tempLine, widgetWidth, fontOption, screenWidth,
                screenHeight, fontColor)
          ];
        } else {
          widgets = [
            ...widgets,
            Text(tempLine,
                style:
                textStyle(fontOption, screenWidth, screenHeight, fontColor))
          ];
        }
      }
    } else {
      widgets = [
        ...widgets,
        ...longLine(
            line, widgetWidth, fontOption, screenWidth, screenHeight, fontColor)
      ];
    }
    widgets.add(Container());
  }
  return Wrap(
    children: widgets,
  );
}



// Directionality(
//   textDirection: TextDirection.ltr,
//   child: MathField(
//     keyboardType: MathKeyboardType.expression,
//     variables: const [
//       'x',
//       'y',
//       'z'
//     ], // Specify the variables the user can use (only in expression mode).
//     decoration:
//         const InputDecoration(), // Decorate the input field using the familiar InputDecoration.
//     onChanged: (String
//         value) {}, // Respond to changes in the input field.
//     onSubmitted: (String value) {
//       final mathExpression = TeXParser(value).parse();
//       print(mathExpression);
//       final texNode =
//           convertMathExpressionToTeXNode(mathExpression);
//       print(texNode);
//
//       final texString = texNode.buildTeXString();
//       print(texString);
//     }, // Respond to the user submitting their input.
//   ),
// ),
// SizedBox(height: 50),

// Timer widget
// class MyHomePage extends StatefulWidget {
//   MyHomePage();
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               height: 50.0,
//               child: Stack(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildHourPicker(),
//                       SizedBox(width: 10.0),
//                       buildDivider(),
//                       SizedBox(width: 10.0),
//                       buildMinutePicker(),
//                       SizedBox(width: 10.0),
//                       buildDivider(),
//                       SizedBox(width: 10.0),
//                       buildSecondsPicker(),
//                       SizedBox(width: 10.0),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   buildDivider() {
//     return Text(
//       ':',
//       style: TextStyle(
//         fontWeight: FontWeight.w600,
//         fontSize: 30.0,
//       ),
//     );
//   }
//
//   Widget _buildHourPicker() {
//     return Container(
//       width: 50.0,
//       height: 200.0,
//       child: ListWheelScrollView(
//         onSelectedItemChanged: (val) {},
//         controller: FixedExtentScrollController(initialItem: 00),
//         itemExtent: 40.0,
//         // useMagnifier: true,
//         children: List<Widget>.generate(
//           12,
//               (int index) {
//             final int displayHour = index + 1;
//
//             return _TimeText(text: displayHour.toString());
//           },
//         ),
//       ),
//     );
//   }
//
//   buildMinutePicker() {
//     return Container(
//       width: 50.0,
//       height: 200.0,
//       child: ListWheelScrollView(
//         onSelectedItemChanged: (val) {},
//         controller: FixedExtentScrollController(initialItem: 00),
//         itemExtent: 40.0,
//         // useMagnifier: true,
//         children: List<Widget>.generate(
//           60,
//               (int index) {
//             return _TimeText(text: index.toString());
//           },
//         ),
//       ),
//     );
//   }
//
//   buildSecondsPicker() {
//     return Container(
//       width: 50.0,
//       height: 200.0,
//       child: ListWheelScrollView(
//         onSelectedItemChanged: (val) {},
//         controller: FixedExtentScrollController(initialItem: 0),
//         itemExtent: 40.0,
//         // useMagnifier: true,
//         children: List<Widget>.generate(
//           60,
//               (int index) {
//             return _TimeText(text: index.toString());
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class _TimeText extends StatelessWidget {
//   final String text;
//
//   _TimeText({required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       text.padLeft(2, '0'),
//       style: TextStyle(
//         fontWeight: FontWeight.w600,
//         fontSize: 24.0,
//       ),
//     );
//   }
// }
