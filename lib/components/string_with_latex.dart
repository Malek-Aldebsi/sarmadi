import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../const/fonts.dart';

Widget stringWithLatex(str, fontOption, width, height, fontColor,
    [copy = false]) {
  str = str ?? '';

  double getBaseline(str) {
    str = str != '' ? str : ' ';
    final textPainter = TextPainter(
      text: TextSpan(
          text: str, style: textStyle(fontOption, width, height, fontColor)),
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();

    return textPainter.computeLineMetrics()[0].baseline;
  }

  List<Widget> latexLineProcess(String line) {
    List<Widget> lineWidgets = [];
    int firstSign = line.indexOf('\$');
    int secondSing = line.indexOf('\$', firstSign + 1);

    if (secondSing != -1) {
      for (String word in line.substring(0, firstSign).split(' ')) {
        lineWidgets.add(InkWell(
          onTap: copy
              ? () async {
                  await Clipboard.setData(ClipboardData(text: word));
                }
              : null,
          child: Text('$word ',
              style: textStyle(fontOption, width, height, fontColor)),
        ));
      }
      lineWidgets.add(Directionality(
        textDirection: TextDirection.ltr,
        child: Baseline(
          baseline: getBaseline(line.substring(firstSign + 1, secondSing)),
          baselineType: TextBaseline.alphabetic,
          child: Math.tex(line.substring(firstSign + 1, secondSing),
              mathStyle: MathStyle.text,
              textStyle: textStyle(fontOption, width, height, fontColor)),
        ),
      ));
      lineWidgets += latexLineProcess(line.substring(secondSing + 1));
    } else {
      for (String word in line.split(' ')) {
        lineWidgets.add(InkWell(
          onTap: copy
              ? () async {
                  await Clipboard.setData(ClipboardData(text: word));
                }
              : null,
          child: Text('$word ',
              style: textStyle(fontOption, width, height, fontColor)),
        ));
      }
    }
    return lineWidgets;
  }

  List<Widget> widgets = [];
  List lines = str.split('\n');

  for (String line in lines) {
    widgets += latexLineProcess(line);
    widgets.add(Container());
  }

  // latexString(str);

  return Wrap(
    direction: Axis.horizontal,
    children: widgets,
  );
}

void latexString(str) {
  List latexLineProcess(String line) {
    List lineWidgets = [];
    int firstSign = line.indexOf('\$');
    int secondSing = line.indexOf('\$', firstSign + 1);
    if (secondSing != -1) {
      lineWidgets.add(line.substring(0, firstSign));
      lineWidgets.add(line.substring(firstSign + 1, secondSing));
      lineWidgets += latexLineProcess(line.substring(secondSing + 1));
    } else {
      lineWidgets.add(line);
    }
    return lineWidgets;
  }

  List widgets = [];
  List lines = str.split('\n');

  for (String line in lines) {
    widgets += latexLineProcess(line);
    // widgets.add('\n');
  }
  print(widgets);
}

// Widget stringWithLatex(str, fontOption, width, height, fontColor) {
//   str = str == ''
//       ? ' '
//       : str == null
//       ? ' '
//       : str;
//
//   final textPainter = TextPainter(
//     text: TextSpan(
//         text: str, style: textStyle(fontOption, width, height, fontColor)),
//     textDirection: TextDirection.rtl,
//   );
//   textPainter.layout();
//   final baseline = textPainter.computeLineMetrics()[0].baseline;
//
//   List<Widget> textWidgets = [];
//   int startIndex = str.indexOf(r'$');
//   int endIndex = str.indexOf(r'$', startIndex + 1);
//
//   if (endIndex == -1) {
//     if (str.contains('\n')) {
//       str = str.split('\n');
//       textWidgets.add(Text("${str[0]}",
//           style: textStyle(fontOption, width, height, fontColor)));
//       textWidgets.add(Container());
//       textWidgets.add(Text("${str[1]}",
//           style: textStyle(fontOption, width, height, fontColor)));
//     } else {
//       textWidgets.add(
//           Text(str, style: textStyle(fontOption, width, height, fontColor)));
//     }
//   } else {
//     do {
//       endIndex = str.indexOf(r'$', startIndex + 1);
//       dynamic text = str.substring(0, startIndex);
//       String math = str.substring(startIndex + 1, endIndex);
//       str = str.substring(endIndex + 1);
//       text = text.split(" ");
//
//       for (dynamic i in text) {
//         if (i.contains('\n')) {
//           i = i.split("\n");
//           textWidgets.add(Text("${i[0]}",
//               style: textStyle(fontOption, width, height, fontColor)));
//           textWidgets.add(Container());
//           textWidgets.add(Text("${i[1]}",
//               style: textStyle(fontOption, width, height, fontColor)));
//         } else {
//           textWidgets.add(Text("$i ",
//               style: textStyle(fontOption, width, height, fontColor)));
//         }
//       }
//       textWidgets.add(Baseline(
//         baseline: baseline,
//         baselineType: TextBaseline.alphabetic,
//         child: Math.tex(math,
//             mathStyle: MathStyle.text,
//             textStyle: textStyle(fontOption, width, height, fontColor)),
//       ));
//       startIndex = str.indexOf(r'$');
//     } while (startIndex != -1);
//     str = str.split(" ");
//     for (dynamic i in str) {
//       if (i.contains('\n')) {
//         i = i.split("\n");
//         textWidgets.add(Text("${i[0]}",
//             style: textStyle(fontOption, width, height, fontColor)));
//         textWidgets.add(Container());
//         textWidgets.add(Text("${i[1]}",
//             style: textStyle(fontOption, width, height, fontColor)));
//       } else {
//         textWidgets.add(Text("$i ",
//             style: textStyle(fontOption, width, height, fontColor)));
//       }
//     }
//   }
//   return Wrap(
//     direction: Axis.horizontal,
//     children: textWidgets,
//   );
// }
