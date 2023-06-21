// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../services/firebase_auth_methods.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class PhoneScreen extends StatefulWidget {
//   static String routeName = '/phone';
//   const PhoneScreen({Key? key}) : super(key: key);
//
//   @override
//   State<PhoneScreen> createState() => _PhoneScreenState();
// }
//
// class _PhoneScreenState extends State<PhoneScreen> {
//   final TextEditingController phoneController = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//     phoneController.dispose();
//   }
//
//   void phoneSignIn() {
//     context
//         .read<FirebaseAuthMethods>()
//         .phoneSignIn(context, phoneController.text);
//     // FirebaseAuthMethods(FirebaseAuth.instance)
//     //     .phoneSignIn(context, phoneController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CustomTextField(
//             controller: phoneController,
//             hintText: 'Enter phone number',
//           ),
//           CustomButton(
//             onTap: phoneSignIn,
//             text: 'SEND OTP',
//           ),
//         ],
//       ),
//     );
//   }
// }
