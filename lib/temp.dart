void main() {
  RegExp exp = RegExp(r"^([+]962|0)7(7|8|9)[0-9]{7}");
  print(exp.hasMatch('+962785783785'));
}
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
