// import 'package:flutter/material.dart';
// import 'package:flutter_dash/flutter_dash.dart';
// import '../components/string_with_latex.dart';
// import '../const.dart';
// import 'dashboard.dart';
// import 'quiz_setting.dart';
// import 'welcome.dart';
// import '../components/custom_circular_chart.dart';
// import '../components/custom_container.dart';
// import '../components/custom_pop_up.dart';
// import '../utils/http_requests.dart';
// import '../utils/session.dart';
//
// class QuizResult extends StatefulWidget {
//   static const String route = '/QuizResult/';
//   const QuizResult({Key? key}) : super(key: key);
//
//   @override
//   State<QuizResult> createState() => _QuizResultState();
// }
//
// class _QuizResultState extends State<QuizResult> {
//   bool loaded = true;
//
//   String userName = '';
//
//   String subject = 'الرياضيات';
//
//   Map quizContent = {
//     'modules': ['النهايات', 'التفاضل', 'التكامل', 'الاشتقاق'],
//     'lessons': ['الاحصاء', 'الاحتمالات'],
//     'skills': ['المعادلات التفاضلية', 'التطبيقات العامة'],
//     'generalSkills': ['الرسم البياني', 'الحساب الذهني'],
//   };
//
//   Map quizResult = {
//     'all_question': 18,
//     'correct_question': 4,
//     'full_time': 600,
//     'used_time': 303,
//   };
//
//   void getUser() async {
//     String? key0 = await getSession('sessionKey0');
//     String? key1 = await getSession('sessionKey1');
//     String? value = await getSession('sessionValue');
//     post('user_name/', {
//       if (key0 != null) 'email': key0,
//       if (key1 != null) 'phone': key1,
//       'password': value,
//     }).then((value) {
//       dynamic result = decode(value);
//       result == 0
//           ? Navigator.pushNamed(context, Welcome.route)
//           : setState(() {
//               userName = result;
//               loaded = true;
//             });
//     });
//   }
//
//   @override
//   void initState() {
//     // getUser();
//     super.initState();
//   }
//
//   List questions = [
//     {
//       'answer': r'$\left(5x+7\right)^2$',
//       'id': '2d94f4c7-bcae-4043-bf84-ec613e38f5c4',
//       'body': r' أوجد ناتج الضرب بأبسط صورة\n$\left(5x+7\right)^2$',
//       'image': null,
//       'correct_answer': r'$\left(5x+7\right)^2$',
//       'choices': [],
//       'solution': ''
//     },
//     {
//       'answer': r'$\left(5x+7\right)^2$',
//       'id': '1f87a81e-7102-4cc0-9269-d3f4e4fb42d4',
//       'body': r' أوجد ناتج الضرب بأبسط صورة\n$\left(x^3-4y^2\right)^2$',
//       'image': null,
//       'correct_answer': r'$\left(5x\right)^2$',
//       'choices': [],
//       'solution': ''
//     },
//     {
//       'answer': r'$\left(5x+7\right)^2$',
//       'id': '6b762c73-3467-453d-af52-9cf3c1c8d048',
//       'body':
//           r' أوجد ناتج ما يلي بأبسط صورة\n$\left(5k+4\right)\left(5k-4\right)$',
//       'image': null,
//       'correct_answer': r'$\left(5x+7\right)^2$',
//       'choices': [],
//       'solution':
//           r'حلل المعادلات للحصول على العبارة التالية $\left(5x+7\right)^2$'
//     },
//     {
//       'answer': r'$x-1$',
//       'id': '23625188-055a-40a1-ac04-a29dd7134bce',
//       'body': r' الصورة الأبسط للكسر الاتي هي:\n$\frac{x^2-3x+2}{\:x-2}$',
//       'image': 'https://picsum.photos/250?image=9',
//       'correct_answer': r'$x-1$',
//       'choices': [
//         {'id': 'eb1f5c18-ecfd-4b36-b095-b1f7970f9771', 'body': r'$x-1$'},
//         {'id': '2d91e5c4-ec04-48a7-a4b2-608f55498c0b', 'body': r'$x+1$'},
//         {'id': '59625396-a65e-47d0-ac85-ae2d48e951b8', 'body': r'$x+2$'},
//         {'id': '804a16ef-7811-474f-91b7-367eeb470a92', 'body': r'$x-2$'}
//       ],
//       'solution': 'قم بإشتقاق المعادلات ثم عوض قيمة 3 في كل من المتغيرات'
//     }
//   ];
//
//   int questionIndex = 4;
//
//   ScrollController cont = ScrollController();
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     return loaded
//         ? Scaffold(
//             body: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("images/home_dashboard_background.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                             height: double.infinity,
//                             width: width * 0.06,
//                             decoration: BoxDecoration(
//                                 border: Border(
//                                     left: BorderSide(
//                                         color: kLightGray, width: 1))),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Image(
//                                   image: const AssetImage('images/logo.png'),
//                                   width: width * 0.05,
//                                 ),
//                                 Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {
//                                           Navigator.pushNamed(
//                                               context, Dashboard.route);
//                                         }, //home dashboard
//                                         icon: Icon(
//                                           Icons.home_outlined,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {}, //userprofile
//                                         icon: Icon(
//                                           Icons.person_outline_rounded,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {
//                                           Navigator.pushNamed(
//                                               context, QuizSetting.route);
//                                         }, //home dashboard
//                                         icon: Icon(
//                                           Icons.school_outlined,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {}, //analysis
//                                         icon: Icon(
//                                           Icons.pie_chart_outline_rounded,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {}, //community
//                                         icon: Icon(
//                                           Icons.forum_outlined,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {}, //leaderboard
//                                         icon: Icon(
//                                           Icons.leaderboard_outlined,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           vertical: height / 40),
//                                       child: IconButton(
//                                         onPressed: () {}, //settings
//                                         icon: Icon(
//                                           Icons.settings_outlined,
//                                           size: width * 0.02,
//                                           color: kWhite,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 // Padding(
//                                 //   padding: EdgeInsets.symmetric(
//                                 //       vertical: height / 40),
//                                 //   child: IconButton(
//                                 //     onPressed: () {
//                                 //       popUp(context, width * 0.3,
//                                 //           'هل حقاً تريد تسجيل الخروج', [
//                                 //         Row(
//                                 //           mainAxisAlignment:
//                                 //               MainAxisAlignment.spaceBetween,
//                                 //           children: [
//                                 //             Button(
//                                 //               onTap: () {
//                                 //                 Navigator.of(context).pop();
//                                 //               },
//                                 //               width: width * 0.13,
//                                 //               verticalPadding: 8,
//                                 //               horizontalPadding: 0,
//                                 //               borderRadius: 8,
//                                 //               buttonColor: kBlack,
//                                 //               border: 0,
//                                 //               child: Center(
//                                 //                 child: Text(
//                                 //                   'لا',
//                                 //                   style: textStyle,
//                                 //                 ),
//                                 //               ),
//                                 //             ),
//                                 //             Button(
//                                 //               onTap: () {
//                                 //                 delSession('sessionKey0');
//                                 //                 delSession('sessionKey1');
//                                 //                 delSession('sessionValue').then(
//                                 //                     (value) =>
//                                 //                         Navigator.pushNamed(
//                                 //                             context,
//                                 //                             Welcome.route));
//                                 //               },
//                                 //               width: width * 0.13,
//                                 //               verticalPadding: 8,
//                                 //               horizontalPadding: 0,
//                                 //               borderRadius: 8,
//                                 //               buttonColor: kOffWhite,
//                                 //               border: 0,
//                                 //               child: Center(
//                                 //                 child: Text(
//                                 //                   'نعم',
//                                 //                   style: textStyle.copyWith(
//                                 //                       color: kBlack),
//                                 //                 ),
//                                 //               ),
//                                 //             ),
//                                 //           ],
//                                 //         )
//                                 //       ]);
//                                 //     }, //home dashboard
//                                 //     icon: Icon(
//                                 //       Icons.logout_rounded,
//                                 //       size: width * 0.02,
//                                 //       color: kWhite,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                               ],
//                             )),
//                         SizedBox(
//                           width: width * 0.87,
//                           child: ListView(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     subject,
//                                     style: textStyle.copyWith(
//                                       color: kWhite,
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: width * 0.025,
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         width: width * 0.01,
//                                         height: width * 0.01,
//                                         decoration: BoxDecoration(
//                                             color: kOrange,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.002)),
//                                       ),
//                                       SizedBox(width: width * 0.005),
//                                       Text(
//                                         'وحدة كاملة',
//                                         style: textStyle.copyWith(
//                                           color: kWhite,
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: width * 0.008,
//                                         ),
//                                       ),
//                                       SizedBox(width: width * 0.02),
//                                       Container(
//                                         width: width * 0.01,
//                                         height: width * 0.01,
//                                         decoration: BoxDecoration(
//                                             color: kBlue,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.002)),
//                                       ),
//                                       SizedBox(width: width * 0.005),
//                                       Text(
//                                         'درس كامل',
//                                         style: textStyle.copyWith(
//                                           color: kWhite,
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: width * 0.008,
//                                         ),
//                                       ),
//                                       SizedBox(width: width * 0.02),
//                                       Container(
//                                         width: width * 0.01,
//                                         height: width * 0.01,
//                                         decoration: BoxDecoration(
//                                             color: kGreen,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.002)),
//                                       ),
//                                       SizedBox(width: width * 0.005),
//                                       Text(
//                                         'مهارة خاصة',
//                                         style: textStyle.copyWith(
//                                           color: kWhite,
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: width * 0.008,
//                                         ),
//                                       ),
//                                       SizedBox(width: width * 0.02),
//                                       Container(
//                                         width: width * 0.01,
//                                         height: width * 0.01,
//                                         decoration: BoxDecoration(
//                                             color: kPink,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.002)),
//                                       ),
//                                       SizedBox(width: width * 0.005),
//                                       Text(
//                                         'مهارة عامة',
//                                         style: textStyle.copyWith(
//                                           color: kWhite,
//                                           fontWeight: FontWeight.w200,
//                                           fontSize: width * 0.008,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Wrap(
//                                 spacing: width * 0.005,
//                                 children: [
//                                   for (String key in quizContent.keys)
//                                     for (String tag in quizContent[key])
//                                       CustomContainer(
//                                           onTap: () {},
//                                           verticalPadding: height * 0.01,
//                                           horizontalPadding: width * 0.01,
//                                           borderRadius: width * 0.005,
//                                           border: 0,
//                                           buttonColor: key == 'modules'
//                                               ? kOrange
//                                               : key == 'lessons'
//                                                   ? kGreen
//                                                   : key == 'skills'
//                                                       ? kPink
//                                                       : kBlue,
//                                           child: Text(
//                                             tag,
//                                             style: textStyle.copyWith(
//                                                 color: kWhite,
//                                                 fontSize: width * 0.009,
//                                                 fontWeight: FontWeight.w500),
//                                           ))
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   SizedBox(
//                                     height: height * 0.55,
//                                     width: width * 0.43,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             CustomContainer(
//                                                 width: width * 0.21,
//                                                 onTap: () {},
//                                                 verticalPadding: height * 0.01,
//                                                 horizontalPadding: width * 0.01,
//                                                 borderRadius: width * 0.005,
//                                                 border: 0,
//                                                 buttonColor: kLightGray,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       'جاوبت على ${quizResult['correct_question']} أسئلة من اصل ${quizResult['all_question']}',
//                                                       style: textStyle.copyWith(
//                                                           color: kWhite,
//                                                           fontSize:
//                                                               width * 0.009,
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                     CircularChart(
//                                                       width: width * 0.04,
//                                                       label: double.parse((100 *
//                                                               quizResult[
//                                                                   'correct_question'] /
//                                                               quizResult[
//                                                                   'all_question'])
//                                                           .toStringAsFixed(1)),
//                                                       activeColor: kPurple,
//                                                       inActiveColor: kWhite,
//                                                       labelColor: kWhite,
//                                                     )
//                                                   ],
//                                                 )),
//                                             CustomContainer(
//                                                 width: width * 0.21,
//                                                 onTap: () {},
//                                                 verticalPadding: height * 0.01,
//                                                 horizontalPadding: width * 0.01,
//                                                 borderRadius: width * 0.005,
//                                                 border: 0,
//                                                 buttonColor: kLightGray,
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Text(
//                                                       'أنهيت الامتحان ب${Duration(seconds: quizResult['used_time']).inMinutes} دقائق من أصل ${Duration(seconds: quizResult['full_time']).inMinutes}',
//                                                       style: textStyle.copyWith(
//                                                           color: kWhite,
//                                                           fontSize:
//                                                               width * 0.009,
//                                                           fontWeight:
//                                                               FontWeight.w500),
//                                                     ),
//                                                     CircularChart(
//                                                       width: width * 0.04,
//                                                       label: double.parse((100 *
//                                                               quizResult[
//                                                                   'used_time'] /
//                                                               quizResult[
//                                                                   'full_time'])
//                                                           .toStringAsFixed(1)),
//                                                       activeColor: kPurple,
//                                                       inActiveColor: kWhite,
//                                                       labelColor: kWhite,
//                                                     )
//                                                   ],
//                                                 )),
//                                           ],
//                                         ),
//                                         CustomContainer(
//                                             width: width * 0.43,
//                                             onTap: () {},
//                                             verticalPadding: 0,
//                                             horizontalPadding: 0,
//                                             borderRadius: width * 0.005,
//                                             border: 0,
//                                             buttonColor: kLightGray,
//                                             child: Padding(
//                                               padding: EdgeInsets.only(
//                                                   right: width * 0.03),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     'إعادة الامتحان',
//                                                     style: textStyle.copyWith(
//                                                         color: kWhite,
//                                                         fontSize: width * 0.018,
//                                                         fontWeight:
//                                                             FontWeight.w700),
//                                                   ),
//                                                   Image(
//                                                     image: const AssetImage(
//                                                         'images/requiz.png'),
//                                                     width: width * 0.25,
//                                                     height: height * 0.2,
//                                                     fit: BoxFit.contain,
//                                                     alignment:
//                                                         Alignment.bottomLeft,
//                                                   )
//                                                 ],
//                                               ),
//                                             )),
//                                         CustomContainer(
//                                             width: width * 0.43,
//                                             onTap: () {},
//                                             verticalPadding: 0,
//                                             horizontalPadding: 0,
//                                             borderRadius: width * 0.005,
//                                             border: 0,
//                                             buttonColor: kLightGray,
//                                             child: Padding(
//                                               padding: EdgeInsets.only(
//                                                   right: width * 0.03),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     'جميع التحليلات',
//                                                     style: textStyle.copyWith(
//                                                         color: kWhite,
//                                                         fontSize: width * 0.018,
//                                                         fontWeight:
//                                                             FontWeight.w700),
//                                                   ),
//                                                   Image(
//                                                     image: const AssetImage(
//                                                         'images/quiz_analysis.png'),
//                                                     width: width * 0.25,
//                                                     height: height * 0.2,
//                                                     fit: BoxFit.contain,
//                                                     alignment:
//                                                         Alignment.bottomLeft,
//                                                   )
//                                                 ],
//                                               ),
//                                             )),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(width: width * 0.01),
//                                   CustomContainer(
//                                       width: width * 0.43,
//                                       onTap: () {},
//                                       verticalPadding: 0,
//                                       horizontalPadding: 0,
//                                       borderRadius: width * 0.005,
//                                       border: 0,
//                                       buttonColor: kLightGray,
//                                       child: SizedBox(
//                                         height: height * 0.55,
//                                       ))
//                                 ],
//                               ),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       SizedBox(
//                                         width: width * 0.16,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               'الأسئلة',
//                                               style: textStyle.copyWith(
//                                                   color: kWhite,
//                                                   fontSize: width * 0.018,
//                                                   fontWeight: FontWeight.w700),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 CustomContainer(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         questionIndex++;
//                                                       });
//                                                     },
//                                                     width: width * 0.03,
//                                                     verticalPadding:
//                                                         height * 0.008,
//                                                     horizontalPadding:
//                                                         width * 0.004,
//                                                     borderRadius: width * 0.005,
//                                                     border: 0,
//                                                     buttonColor: kLightGray,
//                                                     child: Icon(
//                                                       Icons
//                                                           .keyboard_arrow_down_rounded,
//                                                       size: width * 0.015,
//                                                       color: kWhite,
//                                                     )),
//                                                 SizedBox(width: width * 0.005),
//                                                 CustomContainer(
//                                                     onTap: () {
//                                                       setState(() {
//                                                         questionIndex--;
//                                                       });
//                                                     },
//                                                     width: width * 0.03,
//                                                     verticalPadding:
//                                                         height * 0.008,
//                                                     horizontalPadding:
//                                                         width * 0.004,
//                                                     borderRadius: width * 0.005,
//                                                     border: 0,
//                                                     buttonColor: kLightGray,
//                                                     child: Icon(
//                                                       Icons
//                                                           .keyboard_arrow_up_rounded,
//                                                       size: width * 0.015,
//                                                       color: kWhite,
//                                                     ))
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                           height: height * 0.94,
//                                           width: width * 0.16,
//                                           child: Theme(
//                                             data: Theme.of(context).copyWith(
//                                               scrollbarTheme:
//                                                   ScrollbarThemeData(
//                                                 minThumbLength: 1,
//                                                 mainAxisMargin: 55,
//                                                 crossAxisMargin: 2,
//                                                 thumbVisibility:
//                                                     MaterialStateProperty.all<
//                                                         bool>(true),
//                                                 trackVisibility:
//                                                     MaterialStateProperty.all<
//                                                         bool>(true),
//                                                 thumbColor:
//                                                     MaterialStateProperty.all<
//                                                         Color>(Colors.green),
//                                                 trackColor:
//                                                     MaterialStateProperty.all<
//                                                         Color>(Colors.yellow),
//                                                 trackBorderColor:
//                                                     MaterialStateProperty.all<
//                                                         Color>(Colors.red),
//                                               ),
//                                             ),
//                                             child: Directionality(
//                                               textDirection: TextDirection.ltr,
//                                               child: ListView(
//                                                 children: [
//                                                   for (int j = 1; j <= 10; j++)
//                                                     for (int i = 1;
//                                                         i <= questions.length;
//                                                         i++) ...[
//                                                       CustomContainer(
//                                                           onTap: () {
//                                                             setState(() {
//                                                               questionIndex = i;
//                                                             });
//                                                           },
//                                                           width: 0.16,
//                                                           verticalPadding:
//                                                               height * 0.01,
//                                                           horizontalPadding:
//                                                               width * 0.01,
//                                                           borderRadius:
//                                                               width * 0.005,
//                                                           border: 0,
//                                                           buttonColor:
//                                                               questionIndex == i
//                                                                   ? kPurple
//                                                                   : kLightGray,
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               Text(
//                                                                 'سؤال #$i',
//                                                                 style: textStyle.copyWith(
//                                                                     color:
//                                                                         kWhite,
//                                                                     fontSize:
//                                                                         width *
//                                                                             0.009,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w500),
//                                                               ),
//                                                               questions[i - 1][
//                                                                           'correct_answer'] ==
//                                                                       questions[i -
//                                                                               1]
//                                                                           [
//                                                                           'answer']
//                                                                   ? Icon(
//                                                                       Icons
//                                                                           .check_rounded,
//                                                                       size: width *
//                                                                           0.015,
//                                                                       color:
//                                                                           kGreen,
//                                                                     )
//                                                                   : Icon(
//                                                                       Icons
//                                                                           .close,
//                                                                       size: width *
//                                                                           0.015,
//                                                                       color:
//                                                                           kRed,
//                                                                     )
//                                                             ],
//                                                           )),
//                                                       SizedBox(
//                                                           height:
//                                                               height * 0.01),
//                                                     ]
//                                                 ],
//                                               ),
//                                             ),
//                                           )),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: height,
//                                     child: VerticalDivider(
//                                       thickness: 1,
//                                       color: kLightGray,
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'نص السؤال',
//                                         style: textStyle.copyWith(
//                                             color: kWhite,
//                                             fontSize: width * 0.018,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                       Container(
//                                         width: width * 0.68,
//                                         decoration: BoxDecoration(
//                                             color: kLightGray,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.01)),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: width * 0.02,
//                                             vertical: height * 0.01),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   bottom: height / 64),
//                                               child: SizedBox(
//                                                 width: width * 0.64,
//                                                 child: stringWithLatex(
//                                                     questions[questionIndex - 1]
//                                                         ['body'],
//                                                     width * 0.012,
//                                                     kWhite),
//                                               ),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Column(
//                                                   children: [
//                                                     for (int i = 0;
//                                                         i <
//                                                             questions[questionIndex -
//                                                                         1]
//                                                                     ['choices']
//                                                                 .length;
//                                                         i++)
//                                                       Padding(
//                                                         padding:
//                                                             EdgeInsets.only(
//                                                                 bottom: height /
//                                                                     64),
//                                                         child: CustomContainer(
//                                                             onTap: null,
//                                                             verticalPadding:
//                                                                 height * 0.01,
//                                                             horizontalPadding:
//                                                                 width * 0.02,
//                                                             width: questions[questionIndex - 1]['image'] == null
//                                                                 ? width * 0.64
//                                                                 : width * 0.32,
//                                                             borderRadius: 8,
//                                                             border: 0,
//                                                             buttonColor: questions[questionIndex - 1]['choices'][i]['body'] ==
//                                                                     questions[questionIndex - 1][
//                                                                         'correct_answer']
//                                                                 ? kGreen
//                                                                 : questions[questionIndex - 1]['choices'][i]['body'] ==
//                                                                         questions[questionIndex - 1][
//                                                                             'answer']
//                                                                     ? kRed
//                                                                     : kBlack,
//                                                             child: stringWithLatex(
//                                                                 questions[questionIndex - 1]['choices'][i]['body'],
//                                                                 width * 0.012,
//                                                                 kWhite)),
//                                                       ),
//                                                     if (questions[
//                                                             questionIndex -
//                                                                 1]['choices']
//                                                         .isEmpty)
//                                                       CustomContainer(
//                                                           onTap: null,
//                                                           verticalPadding:
//                                                               height * 0.01,
//                                                           horizontalPadding:
//                                                               width * 0.02,
//                                                           width: questions[
//                                                                           questionIndex -
//                                                                               1]
//                                                                       [
//                                                                       'image'] ==
//                                                                   null
//                                                               ? width * 0.64
//                                                               : width * 0.32,
//                                                           borderRadius: 8,
//                                                           border: 0,
//                                                           buttonColor: kBlack,
//                                                           child: Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               stringWithLatex(
//                                                                   questions[
//                                                                           questionIndex -
//                                                                               1]
//                                                                       [
//                                                                       'answer'],
//                                                                   width * 0.012,
//                                                                   kWhite),
//                                                               questions[questionIndex -
//                                                                               1]
//                                                                           [
//                                                                           'correct_answer'] ==
//                                                                       questions[questionIndex -
//                                                                               1]
//                                                                           [
//                                                                           'answer']
//                                                                   ? Icon(
//                                                                       Icons
//                                                                           .check_rounded,
//                                                                       size: width *
//                                                                           0.015,
//                                                                       color:
//                                                                           kGreen,
//                                                                     )
//                                                                   : Icon(
//                                                                       Icons
//                                                                           .close,
//                                                                       size: width *
//                                                                           0.015,
//                                                                       color:
//                                                                           kRed,
//                                                                     )
//                                                             ],
//                                                           ))
//                                                   ],
//                                                 ),
//                                                 if (questions[questionIndex - 1]
//                                                         ['image'] !=
//                                                     null) ...[
//                                                   Dash(
//                                                       direction: Axis.vertical,
//                                                       dashThickness: 0.4,
//                                                       length: height * 0.3,
//                                                       dashLength: height * 0.01,
//                                                       dashColor: kPurple
//                                                           .withOpacity(0.6)),
//                                                   Image(
//                                                     image: NetworkImage(
//                                                         questions[
//                                                             questionIndex -
//                                                                 1]['image']),
//                                                     height: height * 0.3,
//                                                     width: width * 0.3,
//                                                     fit: BoxFit.contain,
//                                                     alignment: Alignment.center,
//                                                   ),
//                                                 ]
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: width * 0.68,
//                                         child: Divider(
//                                           thickness: 1,
//                                           color: kLightGray,
//                                         ),
//                                       ),
//                                       Text(
//                                         'طريقة الحل',
//                                         style: textStyle.copyWith(
//                                             color: kWhite,
//                                             fontSize: width * 0.018,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                       Container(
//                                         width: width * 0.68,
//                                         decoration: BoxDecoration(
//                                             color: kLightGray,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * 0.01)),
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: width * 0.02,
//                                             vertical: height * 0.01),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             SizedBox(
//                                               width: width * 0.64,
//                                               height: height * 0.3,
//                                               child: stringWithLatex(
//                                                   questions[questionIndex - 1]
//                                                       ['solution'],
//                                                   width * 0.012,
//                                                   kWhite),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 MaterialButton(
//                                                   onPressed: () {},
//                                                   child: Icon(
//                                                     Icons.fullscreen_rounded,
//                                                     size: width * 0.015,
//                                                     color: kWhite,
//                                                   ),
//                                                 )
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                         const SizedBox()
//                       ]),
//                 )))
//         : Scaffold(
//             backgroundColor: kLightGray,
//             body: Center(
//                 child: CircularProgressIndicator(
//                     color: kPurple, strokeWidth: width * 0.05)));
//   }
// }
