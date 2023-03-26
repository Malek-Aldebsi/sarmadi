import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../const/fonts.dart';

// Widget stringWithLatex(str, fontOption, width, height, fontColor) {
//   List<InlineSpan> textSpan = [];
//   int startIndex = str.indexOf(r'$');
//   if (startIndex == -1) {
//     textSpan.add(TextSpan(
//         text: str, style: textStyle(fontOption, width, height, fontColor)));
//   } else {
//     int endIndex;
//     do {
//       endIndex = str.indexOf(r'$', startIndex + 1);
//       String text = str.substring(0, startIndex);
//       String math = str.substring(startIndex + 1, endIndex);
//       str = str.substring(endIndex + 1);
//       textSpan.add(TextSpan(
//           text: text, style: textStyle(fontOption, width, height, fontColor)));
//       textSpan.add(WidgetSpan(
//         alignment: PlaceholderAlignment.middle,
//         child: Math.tex(math,
//             mathStyle: MathStyle.text,
//             textStyle: textStyle(fontOption, width, height, fontColor)),
//       ));
//       startIndex = str.indexOf(r'$');
//     } while (startIndex != -1);
//   }
//   return RichText(
//     textAlign: TextAlign.start,
//     text: TextSpan(
//       text: '',
//       children: textSpan,
//     ),
//   );
// }

Widget stringWithLatex(str, fontOption, width, height, fontColor) {
  final textPainter = TextPainter(
    text: TextSpan(
        text: str, style: textStyle(fontOption, width, height, fontColor)),
    textDirection: TextDirection.rtl,
  );
  textPainter.layout();
  final baseline = textPainter.computeLineMetrics()[0].baseline;

  List<Widget> textSpan = [];
  int startIndex = str.indexOf(r'$');
  if (startIndex == -1) {
    textSpan
        .add(Text(str, style: textStyle(fontOption, width, height, fontColor)));
  } else {
    int endIndex;
    do {
      endIndex = str.indexOf(r'$', startIndex + 1);
      dynamic text = str.substring(0, startIndex);
      String math = str.substring(startIndex + 1, endIndex);
      str = str.substring(endIndex + 1);
      text = text.split(" ");
      print(text);
      for (dynamic i in text) {
        if (i.contains('\n')) {
          i = i.split("\n");
          textSpan.add(Text("${i[0]}",
              style: textStyle(fontOption, width, height, fontColor)));
          textSpan.add(Container());
          textSpan.add(Text("${i[1]}",
              style: textStyle(fontOption, width, height, fontColor)));
        } else {
          textSpan.add(Text("$i ",
              style: textStyle(fontOption, width, height, fontColor)));
        }
      }
      textSpan.add(Baseline(
        baseline: baseline,
        baselineType: TextBaseline.alphabetic,
        child: Math.tex(math,
            mathStyle: MathStyle.text,
            textStyle: textStyle(fontOption, width, height, fontColor)),
      ));
      startIndex = str.indexOf(r'$');
    } while (startIndex != -1);
    str = str.split(" ");
    for (dynamic i in str) {
      if (i.contains('\n')) {
        i = i.split("\n");
        textSpan.add(Text("${i[0]}",
            style: textStyle(fontOption, width, height, fontColor)));
        textSpan.add(Container());
        textSpan.add(Text("${i[1]}",
            style: textStyle(fontOption, width, height, fontColor)));
      } else {
        textSpan.add(Text("$i ",
            style: textStyle(fontOption, width, height, fontColor)));
      }
    }
  }
  return Wrap(
    direction: Axis.horizontal,
    children: textSpan,
  );
}
