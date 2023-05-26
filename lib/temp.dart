import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
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

//SizedBox(
//                 width: width * 0.42,
//                 child: MathField(
//                   keyboardType: MathKeyboardType.expression,
//                   variables: const [
//                     'x',
//                     'y',
//                     'z'
//                   ], // Specify the variables the user can use (only in expression mode).
//                   decoration: InputDecoration(
//                     isDense: true,
//                     hintStyle:
//                         textStyle(3, width, height, kWhite.withOpacity(0.5)),
//                     hintText: 'أدخل جوابك',
//                     counterStyle: textStyle(3, width, height, kWhite),
//                     filled: true,
//                     fillColor: kDarkGray,
//                     border: outlineInputBorder(width * 0.005, kTransparent),
//                     focusedBorder:
//                         outlineInputBorder(width * 0.005, kLightPurple),
//                   ), // Decorate the input field using the familiar InputDecoration.
//                   onChanged: (String
//                       value) {}, // Respond to changes in the input field.
//                   onSubmitted: (String value) {
//                     final mathExpression = TeXParser(value).parse();
//                     final texNode =
//                         convertMathExpressionToTeXNode(mathExpression);
//                     final texString = texNode.buildTeXString();
//                     print(texString);
//                   }, // Respond to the user submitting their input.
//                 ),
//               ),
