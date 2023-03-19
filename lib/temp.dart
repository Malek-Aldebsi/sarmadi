import 'package:flutter/material.dart';

// RegExp exp = RegExp(r"^([+]962|0)7(7|8|9)[0-9]{7}");
// print(exp.hasMatch('+962785783785'));
// RegExp phone = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
// RegExp emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

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
