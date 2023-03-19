// import 'package:flutter/material.dart';
// import 'sign_up.dart';
// import '../components/custom_container.dart';
// import '../components/custom_text_field.dart';
// import '../const.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// import '../utils/session.dart';
// import '../utils/hashCode.dart';
// import '../utils/http_requests.dart';
//
// import 'dashboard.dart';
//
// class LogIn extends StatefulWidget {
//   static const String route = '/LogIn/';
//
//   const LogIn({Key? key}) : super(key: key);
//
//   @override
//   State<LogIn> createState() => _LogInState();
// }
//
// class _LogInState extends State<LogIn> {
//   final CarouselController controller = CarouselController();
//
//   TextEditingController email = TextEditingController();
//
//   TextEditingController phone = TextEditingController();
//
//   TextEditingController password = TextEditingController();
//
//   bool obscurePassword = true;
//
//   int current = 0;
//   int loginMethod = 0; // 0 email 1 phone
//
//   void logIn(password, [email, phone]) {
//     email == ''
//         ? post('log_in/', {
//             'phone': phone,
//             'password': password,
//           }).then((value) {
//             dynamic result = decode(value);
//             switch (result) {
//               case 0:
//                 setSession('sessionKey1', phone);
//                 setSession('sessionValue', password).then(
//                     (value) => Navigator.pushNamed(context, Dashboard.route));
//                 break;
//               case 1:
//                 print('phone or password are wrong');
//                 break;
//               case 404:
//                 print('check your connection');
//                 break;
//               default:
//                 print('sth goes wrong, try later');
//                 break;
//             }
//           })
//         : post('log_in/', {
//             'email': email,
//             'password': password,
//           }).then((value) {
//             dynamic result = decode(value);
//             switch (result) {
//               case 0:
//                 setSession('sessionKey0', email);
//                 setSession('sessionValue', password).then(
//                     (value) => Navigator.pushNamed(context, Dashboard.route));
//                 break;
//               case 1:
//                 print('email or password are wrong');
//                 break;
//               case 404:
//                 print('check your connection');
//                 break;
//               default:
//                 print('sth goes wrong, try later');
//                 break;
//             }
//           });
//   }
//
//   @override
//   void initState() {
//     delSession('sessionKey0');
//     delSession('sessionKey1');
//     delSession('sessionValue');
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//         body: Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage("images/signup_background.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(vertical: height / 15),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 RichText(
//                     text: TextSpan(
//                   text: textList[current][1],
//                   style: textStyle.copyWith(
//                       fontSize: width / 40,
//                       color: kBlack,
//                       fontWeight: FontWeight.w800),
//                   children: <TextSpan>[
//                     TextSpan(
//                       text: textList[current][0],
//                       style: textStyle.copyWith(
//                         fontSize: width / 40,
//                         color: kPurple,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 )),
//                 SizedBox(
//                   width: width * 0.39,
//                   child: CarouselSlider(
//                     items: imgList
//                         .map(
//                           (item) => Image.asset(
//                             item,
//                             fit: BoxFit.contain,
//                             alignment: Alignment.center,
//                             width: width * 0.4,
//                           ),
//                         )
//                         .toList(),
//                     options: CarouselOptions(
//                       onPageChanged: (index, reason) {
//                         setState(() {
//                           current = index;
//                         });
//                       },
//                       viewportFraction: 1,
//                       autoPlay: true,
//                     ),
//                     carouselController: controller,
//                   ),
//                 ),
//                 Row(
//                   children: imgList.asMap().entries.map((entry) {
//                     return GestureDetector(
//                       onTap: () => controller.animateToPage(entry.key),
//                       child: Container(
//                         width: width / 55,
//                         height: height / 55,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: kBlack
//                                 .withOpacity(current == entry.key ? 0.9 : 0.4)),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: width * 0.04),
//               child: Row(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: height * 0.12),
//                       CustomContainer(
//                         onTap: () {},
//                         width: width * 0.035,
//                         verticalPadding: 0,
//                         horizontalPadding: 0,
//                         borderRadius: 8,
//                         buttonColor: kLightGray,
//                         border: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(width * 0.0025),
//                           child: const Image(
//                             image: AssetImage('images/facebook_logo.png'),
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.03),
//                       CustomContainer(
//                         onTap: () {},
//                         width: width * 0.035,
//                         verticalPadding: 0,
//                         horizontalPadding: 0,
//                         borderRadius: 8,
//                         buttonColor: kLightGray,
//                         border: 0,
//                         child: Padding(
//                           padding: EdgeInsets.all(width * 0.0025),
//                           child: const Image(
//                             image: AssetImage('images/google_logo.png'),
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: width * 0.02),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: height * 0.12),
//                       SizedBox(
//                         height: height * 0.1,
//                         child: VerticalDivider(
//                           thickness: 1,
//                           color: kLightGray,
//                         ),
//                       ),
//                       Text(
//                         'أو',
//                         textDirection: TextDirection.rtl,
//                         style: textStyle.copyWith(
//                           color: kLightGray,
//                           fontWeight: FontWeight.w800,
//                           fontSize: width / 90,
//                         ),
//                       ),
//                       SizedBox(
//                         height: height * 0.1,
//                         child: VerticalDivider(
//                           thickness: 1,
//                           color: kLightGray,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(width: width * 0.02),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12),
//                         child: Text(
//                           'تسجيل الدخول',
//                           textDirection: TextDirection.rtl,
//                           style: textStyle.copyWith(
//                             color: kPurple,
//                             fontWeight: FontWeight.w800,
//                             fontSize: width / 90,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(bottom: height / 32, right: 12),
//                         child: Text(
//                           'أهـلا فيـك مرة تانية!',
//                           textDirection: TextDirection.rtl,
//                           style: textStyle.copyWith(
//                             fontWeight: FontWeight.w800,
//                             fontSize: width / 50,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: height / 32, bottom: height / 32),
//                         child: Row(
//                           children: [
//                             CustomContainer(
//                               onTap: () {
//                                 setState(() {
//                                   email.text = '';
//                                   password.text = '';
//                                   loginMethod = 1;
//                                 });
//                               },
//                               width: width / 4.84,
//                               verticalPadding: 8,
//                               horizontalPadding: 0,
//                               buttonColor: kTransparent,
//                               borderRadius: 20,
//                               borderColor:
//                                   loginMethod == 1 ? kPurple : kOffWhite,
//                               border: 1,
//                               child: Center(
//                                 child: Text(
//                                   'رقم الهاتف',
//                                   style: textStyle.copyWith(
//                                     color:
//                                         loginMethod == 1 ? kPurple : kOffWhite,
//                                     fontSize: width / 85,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CustomContainer(
//                               onTap: () {
//                                 setState(() {
//                                   phone.text = '';
//                                   password.text = '';
//                                   loginMethod = 0;
//                                 });
//                               },
//                               width: width / 4.84,
//                               verticalPadding: 8,
//                               buttonColor: kTransparent,
//                               horizontalPadding: 0,
//                               borderRadius: 20,
//                               borderColor:
//                                   loginMethod == 0 ? kPurple : kOffWhite,
//                               border: 1,
//                               child: Center(
//                                 child: Text(
//                                   'البريد الإلكتروني',
//                                   style: textStyle.copyWith(
//                                     color:
//                                         loginMethod == 0 ? kPurple : kOffWhite,
//                                     fontSize: width / 85,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: height / 64),
//                         child: CustomTextField(
//                           innerText: null,
//                           hintText: loginMethod == 0
//                               ? 'البريد الإلكتروني'
//                               : 'رقم الهاتف',
//                           fontSize: width / 85,
//                           width: width / 2.42,
//                           controller: loginMethod == 0 ? email : phone,
//                           onChanged: (text) {},
//                           readOnly: false,
//                           obscure: false,
//                           suffixIcon: null,
//                           keyboardType: loginMethod == 0
//                               ? TextInputType.emailAddress
//                               : TextInputType.phone,
//                           color: kLightGray,
//                           verticalPadding: width / 170,
//                           horizontalPadding: width / 42.5,
//                           border: roundedInputBorder(),
//                           focusedBorder: roundedFocusedBorder(),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(vertical: height / 64),
//                         child: CustomTextField(
//                           innerText: null,
//                           hintText: 'كلمة السر',
//                           fontSize: width / 85,
//                           width: width / 2.42,
//                           controller: password,
//                           onChanged: (text) {},
//                           readOnly: false,
//                           obscure: obscurePassword,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscurePassword
//                                   ? Icons.visibility_off_outlined
//                                   : Icons.visibility_outlined,
//                               size: width / 65,
//                               color: kOffWhite,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 obscurePassword = !obscurePassword;
//                               });
//                             },
//                           ),
//                           keyboardType: null,
//                           color: kLightGray,
//                           verticalPadding: width / 170,
//                           horizontalPadding: width / 42.5,
//                           border: roundedInputBorder(),
//                           focusedBorder: roundedFocusedBorder(),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: height / 32, bottom: height / 64),
//                         child: CustomContainer(
//                           onTap: () async {
//                             if ((email.text != '' || phone.text != '') &&
//                                 password.text != '') {
//                               String passwordSha256 = hashCode(password.text);
//                               logIn(passwordSha256, email.text, phone.text);
//                             }
//                           },
//                           width: width / 2.42,
//                           verticalPadding: 8,
//                           horizontalPadding: 0,
//                           borderRadius: 20,
//                           border: 0,
//                           buttonColor: kPurple,
//                           child: Center(
//                             child: Text(
//                               'سجل دخولك',
//                               style: textStyle.copyWith(
//                                 fontSize: width / 85,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Directionality(
//                         textDirection: TextDirection.rtl,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pushNamed(context, SignUp.route);
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 12.0),
//                             child: RichText(
//                                 text: TextSpan(
//                               text: 'ما عندك حساب؟ ',
//                               style: textStyle.copyWith(
//                                   fontSize: width / 100,
//                                   color: kWhite,
//                                   fontWeight: FontWeight.w800),
//                               children: [
//                                 TextSpan(
//                                   text: 'أنشئ حساب جديد!',
//                                   style: textStyle.copyWith(
//                                     fontSize: width / 100,
//                                     color: kPurple,
//                                     fontWeight: FontWeight.w800,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ));
//   }
// }
//
// final List<String> imgList = [
//   'images/clock.png',
//   'images/led.png',
//   'images/magnifying_glass.png'
// ];
//
// final List<List<String>> textList = [
//   ['وقتك المحدود', 'استغل '],
//   ['من ذكائك', 'زيد '],
//   ['نقاط ضعفك', 'اكتشف ']
// ];
