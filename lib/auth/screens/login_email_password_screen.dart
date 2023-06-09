// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../widgets/custom_button.dart';
//
// import '../services/firebase_auth_methods.dart';
// import '../widgets/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class EmailPasswordLogin extends StatefulWidget {
//   static String routeName = '/login-email-password';
//   const EmailPasswordLogin({Key? key}) : super(key: key);
//
//   @override
//   _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
// }
//
// class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   void loginUser() {
//     context.read<FirebaseAuthMethods>().loginWithEmail(
//           email: emailController.text,
//           password: passwordController.text,
//           context: context,
//         );
//     // FirebaseAuthMethods(FirebaseAuth.instance).loginWithEmail(
//     //     email: emailController.text,
//     //     password: passwordController.text,
//     //     context: context);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             "Login",
//             style: TextStyle(fontSize: 30),
//           ),
//           SizedBox(height: MediaQuery.of(context).size.height * 0.08),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child: CustomTextField(
//               controller: emailController,
//               hintText: 'Enter your email',
//             ),
//           ),
//           const SizedBox(height: 20),
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             child: CustomTextField(
//               controller: passwordController,
//               hintText: 'Enter your password',
//             ),
//           ),
//           const SizedBox(height: 40),
//           CustomButton(onTap: loginUser, text: 'Login')
//           // ElevatedButton(
//           //   onPressed: loginUser,
//           //   style: ButtonStyle(
//           //     backgroundColor: MaterialStateProperty.all(Colors.blue),
//           //     textStyle: MaterialStateProperty.all(
//           //       const TextStyle(color: Colors.white),
//           //     ),
//           //     minimumSize: MaterialStateProperty.all(
//           //       Size(MediaQuery.of(context).size.width / 2.5, 50),
//           //     ),
//           //   ),
//           //   child: const Text(
//           //     "Login",
//           //     style: TextStyle(color: Colors.white, fontSize: 16),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
