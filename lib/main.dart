import 'dart:ui';

import 'package:flutter/material.dart';
import 'screens/advance_quiz_setting.dart';
import 'screens/dashboard.dart';
import 'screens/log_in.dart';
import 'screens/question.dart';
import 'screens/quiz_setting.dart';
import 'screens/sign_up.dart';
import 'screens/welcome.dart';

void main() {
  runApp(const Sarmadi());
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     body: Stack(
  //       children: [
  //         // Add your widgets here as the foreground content
  //         Container(
  //           height: 1000,
  //           width: 1000,
  //           color: Colors.blue,
  //           child: Center(
  //             child: Text(
  //               'Foreground Content',
  //               style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // Add your widgets here as the background content
  //         Positioned.fill(
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Container(
  //               color: Colors.grey.withOpacity(0.1),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // ));
}
// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(body: tesst()),
//   ));
// }
//
// class tesst extends StatefulWidget {
//   const tesst({Key? key}) : super(key: key);
//
//   @override
//   State<tesst> createState() => _tesstState();
// }
//
// class _tesstState extends State<tesst> {
//   Widget t = RichText(
//     text: TextSpan(
//       text: 'no way', // Arabic text
//
//       children: [TextSpan(text: 'mmm')],
//     ),
//   );
//
//   void editT() {
//     setState(() {
//       t = RichText(
//         text: TextSpan(
//           text: 'no way', // Arabic text
//
//           children: [
//             TextSpan(text: '       mmm'),
//             WidgetSpan(
//               child: Math.tex(
//                 '2^2',
//               ),
//             )
//           ],
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     editT();
//     return t;
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 50.0,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHourPicker(),
                      SizedBox(width: 10.0),
                      buildDivider(),
                      SizedBox(width: 10.0),
                      buildMinutePicker(),
                      SizedBox(width: 10.0),
                      buildDivider(),
                      SizedBox(width: 10.0),
                      buildSecondsPicker(),
                      SizedBox(width: 10.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDivider() {
    return Text(
      ':',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 30.0,
      ),
    );
  }

  Widget _buildHourPicker() {
    return Container(
      width: 50.0,
      height: 200.0,
      child: ListWheelScrollView(
        onSelectedItemChanged: (val) {},
        controller: FixedExtentScrollController(initialItem: 00),
        itemExtent: 40.0,
        // useMagnifier: true,
        children: List<Widget>.generate(
          12,
          (int index) {
            final int displayHour = index + 1;

            return _TimeText(text: displayHour.toString());
          },
        ),
      ),
    );
  }

  buildMinutePicker() {
    return Container(
      width: 50.0,
      height: 200.0,
      child: ListWheelScrollView(
        onSelectedItemChanged: (val) {},
        controller: FixedExtentScrollController(initialItem: 00),
        itemExtent: 40.0,
        // useMagnifier: true,
        children: List<Widget>.generate(
          60,
          (int index) {
            return _TimeText(text: index.toString());
          },
        ),
      ),
    );
  }

  buildSecondsPicker() {
    return Container(
      width: 50.0,
      height: 200.0,
      child: ListWheelScrollView(
        onSelectedItemChanged: (val) {},
        controller: FixedExtentScrollController(initialItem: 0),
        itemExtent: 40.0,
        // useMagnifier: true,
        children: List<Widget>.generate(
          60,
          (int index) {
            return _TimeText(text: index.toString());
          },
        ),
      ),
    );
  }
}

class _TimeText extends StatelessWidget {
  final String text;

  _TimeText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.padLeft(2, '0'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      ),
    );
  }
}

class Sarmadi extends StatelessWidget {
  const Sarmadi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Dashboard.route,
      routes: {
        Welcome.route: (context) => const Welcome(),
        SignUp.route: (context) => const SignUp(),
        LogIn.route: (context) => const LogIn(),
        Dashboard.route: (context) => const Dashboard(),
        QuizSetting.route: (context) => const QuizSetting(),
        AdvanceQuizSetting.route: (context) => const AdvanceQuizSetting(),
        Question.route: (context) => const Question(),
      },
    );
  }
}
