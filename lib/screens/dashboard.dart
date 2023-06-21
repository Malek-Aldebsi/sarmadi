// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:sarmadi/providers/user_info_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../components/custom_divider.dart';
// import '../const/borders.dart';
// import '../providers/dashboard_provider.dart';
// import '../providers/tasks_provider.dart';
// import '../providers/website_provider.dart';
// import '../components/custom_circular_chart.dart';
// import '../components/custom_container.dart';
// import '../const/fonts.dart';
// import '../const/colors.dart';
//
// import '../utils/http_requests.dart';
// import '../utils/session.dart';
//
// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
//   List colors = [
//     kSkin,
//     kRed,
//     kBrown,
//     kLightPurple,
//     kLightGreen,
//     kBlue,
//     kPink,
//     kYellow,
//   ];
//   List subjectNameVisibility = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false
//   ];
//
//   void getInfo() async {
//     String? key0 = await getSession('sessionKey0');
//     String? key1 = await getSession('sessionKey1');
//     String? value = await getSession('sessionValue');
//     post('dashboard/', {
//       if (key0 != null) 'email': key0,
//       if (key1 != null) 'phone': key1,
//       'password': value,
//     }).then((value) {
//       dynamic result = decode(value);
//       result == 0
//           ?                                   context.pushReplacement('/Welcome')
//           : {
//               Provider.of<UserInfoProvider>(context, listen: false)
//                   .setUserFirstName(result['user_name']),
//               Provider.of<DashboardProvider>(context, listen: false)
//                   .setQuote(result['quote']),
//               Provider.of<DashboardProvider>(context, listen: false)
//                   .setAdvertisement(result['advertisements']),
//               Provider.of<DashboardProvider>(context, listen: false)
//                   .setTodayDate(result['today_date']),
//               Provider.of<WebsiteProvider>(context, listen: false)
//                   .setSubjects(result['subjects']),
//               reshapeTasks(result['tasks'], result['subjects']),
//               Provider.of<WebsiteProvider>(context, listen: false)
//                   .setLoaded(true)
//             };
//     });
//   }
//
//   void reshapeTasks(List tasks, List subjects) {
//     Map _tasks = {};
//     for (Map subject in tasks) {
//       _tasks[subject['subject']] = {
//         'task': subject['task'],
//         'done': subject['done']
//       };
//     }
//     for (Map subject in subjects) {
//       if (_tasks[subject['name']] == null) {
//         _tasks[subject['name']] = {'task': 0, 'done': 0};
//       }
//     }
//
//     Provider.of<TasksProvider>(context, listen: false).setTasks(_tasks);
//   }
//
//   @override
//   void initState() {
//     getInfo();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
//
//     return Provider.of<WebsiteProvider>(context, listen: true).loaded
//         ? Scaffold(
//             body: SafeArea(
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: CustomContainer(
//                   onTap: null,
//                   width: width,
//                   height: height,
//                   verticalPadding: 0,
//                   horizontalPadding: 0,
//                   buttonColor: kLightBlack,
//                   border: null,
//                   borderRadius: null,
//                   child: Column(
//                     children: [
//                       CustomContainer(
//                         onTap: null,
//                         width: width,
//                         height: height * 0.1,
//                         verticalPadding: 0,
//                         horizontalPadding: 0,
//                         buttonColor: kTransparent,
//                         border: singleBottomBorder(kDarkGray),
//                         borderRadius: null,
//                         child: Row(
//                           children: [
//                             SizedBox(width: width * 0.005),
//                             Image(
//                               image: const AssetImage('images/logo.png'),
//                               fit: BoxFit.contain,
//                               width: width * 0.05,
//                             ),
//                             SizedBox(width: width * 0.0037),
//                             CustomDivider(
//                               dashHeight: 2,
//                               dashWidth: width * 0.005,
//                               dashColor: kDarkGray,
//                               direction: Axis.vertical,
//                               fillRate: 1,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Stack(
//                         children: [
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(width: width * 0.06),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: height * 0.06),
//                                     CustomContainer(
//                                       onTap: null,
//                                       width: width * 0.4,
//                                       height: height * 0.25,
//                                       verticalPadding: height * 0.03,
//                                       horizontalPadding: width * 0.02,
//                                       buttonColor: kDarkGray,
//                                       border: null,
//                                       borderRadius: width * 0.005,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Text(
//                                                   'أهلا ${Provider.of<UserInfoProvider>(context, listen: true).firstName.text}، صباح الخير',
//                                                   style: textStyle(2, width,
//                                                       height, kWhite)),
//                                               SizedBox(width: width * 0.02),
//                                               Icon(
//                                                 Icons.sunny,
//                                                 color: Colors.amber,
//                                                 size: width * 0.025,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               Text('حسابك مكتمل بنسبة',
//                                                   style: textStyle(3, width,
//                                                       height, kWhite)),
//                                               SizedBox(width: width * 0.02),
//                                               CircularChart(
//                                                 width: width * 0.028,
//                                                 label: Provider.of<
//                                                             DashboardProvider>(
//                                                         context,
//                                                         listen: true)
//                                                     .profileCompletionPercentage,
//                                                 inActiveColor: kWhite,
//                                                 labelColor: kWhite,
//                                               )
//                                             ],
//                                           ),
//                                           Text('أظهر المزيد',
//                                               style: textStyle(
//                                                   5, width, height, kPurple)),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: height * 0.03),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         CustomContainer(
//                                           onTap: null,
//                                           width: width * 0.4,
//                                           height: height * 0.08,
//                                           verticalPadding: height * 0.02,
//                                           horizontalPadding: width * 0.02,
//                                           buttonColor: kTransparent,
//                                           border: null,
//                                           borderRadius: width * 0.005,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               CustomContainer(
//                                                 onTap: null,
//                                                 width: width * 0.06,
//                                                 height: height * 0.035,
//                                                 verticalPadding: 0,
//                                                 horizontalPadding: 0,
//                                                 buttonColor: kPurple,
//                                                 border: null,
//                                                 borderRadius: width * 0.01,
//                                                 child: Center(
//                                                   child: Text(
//                                                       Provider.of<DashboardProvider>(
//                                                               context,
//                                                               listen: true)
//                                                           .todayDate,
//                                                       style: textStyle(4, width,
//                                                           height, kWhite)),
//                                                 ),
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   for (int i = 0;
//                                                       i <
//                                                           Provider.of<WebsiteProvider>(
//                                                                   context,
//                                                                   listen: true)
//                                                               .subjects
//                                                               .length;
//                                                       i++) ...[
//                                                     // TODO: on click show the subject tasks
//                                                     MouseRegion(
//                                                       onHover: (isHover) {
//                                                         setState(() {
//                                                           subjectNameVisibility[
//                                                               i] = true;
//                                                         });
//                                                       },
//                                                       onExit: (e) {
//                                                         setState(() {
//                                                           subjectNameVisibility[
//                                                               i] = false;
//                                                         });
//                                                       },
//                                                       child: Stack(
//                                                         children: [
//                                                           Visibility(
//                                                             visible:
//                                                                 subjectNameVisibility[
//                                                                     i],
//                                                             child:
//                                                                 CustomContainer(
//                                                               onTap: null,
//                                                               width:
//                                                                   width * 0.05,
//                                                               height:
//                                                                   height * 0.04,
//                                                               verticalPadding:
//                                                                   0,
//                                                               horizontalPadding:
//                                                                   0,
//                                                               buttonColor:
//                                                                   kDarkGray,
//                                                               border:
//                                                                   fullBorder(
//                                                                       kPurple),
//                                                               borderRadius:
//                                                                   width * 0.005,
//                                                               child: Text(
//                                                                   Provider.of<WebsiteProvider>(
//                                                                               context,
//                                                                               listen:
//                                                                                   true)
//                                                                           .subjects[i]
//                                                                       ['name'],
//                                                                   style: textStyle(
//                                                                       5,
//                                                                       width,
//                                                                       height,
//                                                                       kWhite)),
//                                                             ),
//                                                           ),
//                                                           CustomContainer(
//                                                             onTap: null,
//                                                             width:
//                                                                 height * 0.02,
//                                                             height:
//                                                                 height * 0.02,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 colors[i],
//                                                             border: null,
//                                                             borderRadius: width,
//                                                             child: null,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * 0.008),
//                                                   ]
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         CustomContainer(
//                                           onTap: null,
//                                           width: width * 0.4,
//                                           height: height * 0.4,
//                                           verticalPadding: height * 0.02,
//                                           horizontalPadding: width * 0.02,
//                                           buttonColor: kDarkGray,
//                                           border: null,
//                                           borderRadius: width * 0.005,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Center(
//                                                 child: Text('الجدول اليومي',
//                                                     style: textStyle(2, width,
//                                                         height, kWhite)),
//                                               ),
//                                               for (String subject
//                                                   in Provider.of<TasksProvider>(
//                                                           context,
//                                                           listen: true)
//                                                       .tasks
//                                                       .keys
//                                                       .take(5)) ...{
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     CustomContainer(
//                                                       onTap: null,
//                                                       width: width * 0.28,
//                                                       height: height * 0.025,
//                                                       verticalPadding: 0,
//                                                       horizontalPadding: 0,
//                                                       buttonColor: kLightGray,
//                                                       border: null,
//                                                       borderRadius:
//                                                           width * 0.01,
//                                                       child: Row(
//                                                         children: [
//                                                           CustomContainer(
//                                                               onTap: null,
//                                                               width: width * 0.28 * Provider.of<TasksProvider>(context, listen: true).tasks[subject]['task'] == 0
//                                                                   ? 0
//                                                                   : (Provider.of<TasksProvider>(context, listen: true).tasks[subject]['done'] / Provider.of<TasksProvider>(context, listen: true).tasks[subject]['task']) *
//                                                                       width *
//                                                                       0.28,
//                                                               height: height *
//                                                                   0.025,
//                                                               verticalPadding:
//                                                                   0,
//                                                               horizontalPadding:
//                                                                   0,
//                                                               buttonColor:
//                                                                   colors[0],
//                                                               border: null,
//                                                               borderRadius:
//                                                                   width * 0.005,
//                                                               child: (Provider.of<TasksProvider>(context, listen: true).tasks[subject]['done'] / Provider.of<TasksProvider>(context, listen: true).tasks[subject]['task'] * 100).toStringAsFixed(0) == '100'
//                                                                   ? Center(
//                                                                       child: Text(
//                                                                           '100%',
//                                                                           style: textStyle(
//                                                                               5,
//                                                                               width,
//                                                                               height,
//                                                                               kLightBlack)))
//                                                                   : const SizedBox()),
//                                                           if ((Provider.of<TasksProvider>(
//                                                                               context,
//                                                                               listen:
//                                                                                   true)
//                                                                           .tasks[subject]
//                                                                       [
//                                                                       'done'] !=
//                                                                   Provider.of<TasksProvider>(
//                                                                               context,
//                                                                               listen:
//                                                                                   true)
//                                                                           .tasks[subject]
//                                                                       [
//                                                                       'task']) ||
//                                                               Provider.of<TasksProvider>(
//                                                                           context,
//                                                                           listen:
//                                                                               true)
//                                                                       .tasks[subject]['task'] ==
//                                                                   0) ...[
//                                                             SizedBox(
//                                                                 width: width *
//                                                                     0.005),
//                                                             Text(
//                                                                 Provider.of<TasksProvider>(context, listen: true).tasks[subject]
//                                                                             [
//                                                                             'task'] ==
//                                                                         0
//                                                                     ? '0%'
//                                                                     : '${(Provider.of<TasksProvider>(context, listen: true).tasks[subject]['done'] / Provider.of<TasksProvider>(context, listen: true).tasks[subject]['task'] * 100).toStringAsFixed(0)}%',
//                                                                 style: textStyle(
//                                                                     5,
//                                                                     width,
//                                                                     height,
//                                                                     kLightBlack)),
//                                                           ]
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     CustomContainer(
//                                                       onTap: null,
//                                                       width: width * 0.06,
//                                                       height: height * 0.03,
//                                                       verticalPadding: 0,
//                                                       horizontalPadding: 0,
//                                                       buttonColor: kWhite,
//                                                       border: null,
//                                                       borderRadius:
//                                                           width * 0.01,
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           CustomContainer(
//                                                             onTap: () {
//                                                               Provider.of<TasksProvider>(
//                                                                       context,
//                                                                       listen:
//                                                                           false)
//                                                                   .editTask(
//                                                                       subject,
//                                                                       1);
//                                                             },
//                                                             width:
//                                                                 height * 0.03,
//                                                             height:
//                                                                 height * 0.03,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kPurple,
//                                                             border: null,
//                                                             borderRadius: width,
//                                                             child: Icon(
//                                                               Icons.add,
//                                                               size:
//                                                                   width * 0.01,
//                                                               color: kWhite,
//                                                             ),
//                                                           ),
//                                                           Text(
//                                                               '${Provider.of<TasksProvider>(context, listen: true).tasks[subject]['task']}',
//                                                               style: textStyle(
//                                                                   4,
//                                                                   width,
//                                                                   height,
//                                                                   kLightBlack)),
//                                                           CustomContainer(
//                                                             onTap: () {
//                                                               if (Provider.of<TasksProvider>(
//                                                                               context,
//                                                                               listen:
//                                                                                   false)
//                                                                           .tasks[subject]
//                                                                       ['task'] >
//                                                                   Provider.of<TasksProvider>(
//                                                                           context,
//                                                                           listen:
//                                                                               false)
//                                                                       .tasks[subject]['done']) {
//                                                                 Provider.of<TasksProvider>(
//                                                                         context,
//                                                                         listen:
//                                                                             false)
//                                                                     .editTask(
//                                                                         subject,
//                                                                         -1);
//                                                               }
//                                                             },
//                                                             width:
//                                                                 height * 0.03,
//                                                             height:
//                                                                 height * 0.03,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kPurple,
//                                                             border: null,
//                                                             borderRadius: width,
//                                                             child: Icon(
//                                                               Icons.remove,
//                                                               size:
//                                                                   width * 0.01,
//                                                               color: kWhite,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     )
//                                                   ],
//                                                 )
//                                               },
//                                               const SizedBox(),
//                                               Row(
//                                                 children: [
//                                                   Text('لقد أنجزت مهامك بنسبة:',
//                                                       style: textStyle(3, width,
//                                                           height, kWhite)),
//                                                   SizedBox(width: width * 0.01),
//                                                   CircularChart(
//                                                     width: width * 0.028,
//                                                     label: Provider.of<
//                                                                 TasksProvider>(
//                                                             context,
//                                                             listen: true)
//                                                         .dailyTasksCompletionPercentage,
//                                                     inActiveColor: kWhite,
//                                                     labelColor: kWhite,
//                                                   ),
//                                                   SizedBox(width: width * 0.03),
//                                                   Text('معدل إنجازك الاسبوعي:',
//                                                       style: textStyle(3, width,
//                                                           height, kWhite)),
//                                                   SizedBox(width: width * 0.01),
//                                                   CircularChart(
//                                                     width: width * 0.028,
//                                                     label: Provider.of<
//                                                                 TasksProvider>(
//                                                             context,
//                                                             listen: true)
//                                                         .weeklyTasksCompletionPercentage,
//                                                     inActiveColor: kWhite,
//                                                     labelColor: kWhite,
//                                                   )
//                                                 ],
//                                               ),
//                                               const SizedBox(),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: height * 0.06),
//                                     CustomContainer(
//                                       onTap: null,
//                                       width: width * 0.33,
//                                       height: height * 0.27,
//                                       verticalPadding: height * 0.02,
//                                       horizontalPadding: width * 0.02,
//                                       buttonColor: kDarkGray,
//                                       border: null,
//                                       borderRadius: width * 0.005,
//                                       child: null,
//                                     ),
//                                     SizedBox(height: height * 0.03),
//                                     CustomContainer(
//                                       onTap: null,
//                                       width: width * 0.33,
//                                       height: height * 0.46,
//                                       verticalPadding: 0,
//                                       horizontalPadding: 0,
//                                       buttonColor: kTransparent,
//                                       border: null,
//                                       borderRadius: width * 0.005,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           CustomContainer(
//                                             onTap: null,
//                                             width: width * 0.1,
//                                             height: height * 0.46,
//                                             verticalPadding: 0,
//                                             horizontalPadding: 0,
//                                             buttonColor: kDarkGray,
//                                             border: null,
//                                             borderRadius: width * 0.005,
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 const SizedBox(),
//                                                 Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Text('أكمل...',
//                                                         style: textStyle(
//                                                             3,
//                                                             width,
//                                                             height,
//                                                             kWhite)),
//                                                     Icon(
//                                                       Icons.turn_left_rounded,
//                                                       size: width * 0.03,
//                                                       color: kPurple,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Image(
//                                                   image: const AssetImage(
//                                                       'images/question_examplea.png'),
//                                                   width: width * 0.08,
//                                                   height: height * 0.35,
//                                                   fit: BoxFit.fill,
//                                                 ),
//                                                 const SizedBox()
//                                               ],
//                                             ),
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               CustomContainer(
//                                                   onTap: null,
//                                                   width: width * 0.1,
//                                                   height: height * 0.05,
//                                                   verticalPadding: 0,
//                                                   horizontalPadding: 0,
//                                                   buttonColor: kDarkGray,
//                                                   border: null,
//                                                   borderRadius: width * 0.005,
//                                                   child: Center(
//                                                     child: Text('الأفضل',
//                                                         style: textStyle(
//                                                             3,
//                                                             width,
//                                                             height,
//                                                             kWhite)),
//                                                   )),
//                                               CustomContainer(
//                                                 onTap: null,
//                                                 width: width * 0.1,
//                                                 height: height * 0.4,
//                                                 verticalPadding: height * 0.02,
//                                                 horizontalPadding: 0,
//                                                 buttonColor: kDarkGray,
//                                                 border: null,
//                                                 borderRadius: width * 0.005,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Image(
//                                                           image: const AssetImage(
//                                                               'images/question_answer_imoji.png'),
//                                                           width: width * 0.04,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                         CustomContainer(
//                                                           onTap: null,
//                                                           width: width * 0.035,
//                                                           height: height * 0.05,
//                                                           verticalPadding: 0,
//                                                           horizontalPadding: 0,
//                                                           buttonColor:
//                                                               kDarkGreen,
//                                                           border: fullBorder(
//                                                               kPurple),
//                                                           borderRadius:
//                                                               width * 0.005,
//                                                           child: Center(
//                                                             child: Text('30',
//                                                                 style: textStyle(
//                                                                     3,
//                                                                     width,
//                                                                     height,
//                                                                     kWhite)),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Image(
//                                                           image: const AssetImage(
//                                                               'images/man_mark_imoji.png'),
//                                                           width: width * 0.04,
//                                                           height: height * 0.06,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                         CustomContainer(
//                                                           onTap: null,
//                                                           width: width * 0.035,
//                                                           height: height * 0.05,
//                                                           verticalPadding: 0,
//                                                           horizontalPadding: 0,
//                                                           buttonColor:
//                                                               kDarkGreen,
//                                                           border: fullBorder(
//                                                               kPurple),
//                                                           borderRadius:
//                                                               width * 0.005,
//                                                           child: Center(
//                                                             child: Text('10',
//                                                                 style: textStyle(
//                                                                     3,
//                                                                     width,
//                                                                     height,
//                                                                     kWhite)),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Stack(
//                                                       alignment:
//                                                           Alignment.topCenter,
//                                                       children: [
//                                                         CustomContainer(
//                                                             onTap: null,
//                                                             width: width * 0.08,
//                                                             height:
//                                                                 height * 0.2,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kTransparent,
//                                                             border: null,
//                                                             borderRadius:
//                                                                 width * 0.005,
//                                                             child: null),
//                                                         Positioned(
//                                                           top: height * 0.028,
//                                                           left: 0,
//                                                           right: 0,
//                                                           child:
//                                                               CustomContainer(
//                                                                   onTap: null,
//                                                                   width: width *
//                                                                       0.08,
//                                                                   height:
//                                                                       height *
//                                                                           0.16,
//                                                                   verticalPadding:
//                                                                       height *
//                                                                           0.02,
//                                                                   horizontalPadding:
//                                                                       width *
//                                                                           0.02,
//                                                                   buttonColor:
//                                                                       kTransparent,
//                                                                   border:
//                                                                       fullBorder(
//                                                                           kWhite),
//                                                                   borderRadius:
//                                                                       width *
//                                                                           0.01,
//                                                                   child: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       CustomContainer(
//                                                                         onTap:
//                                                                             null,
//                                                                         width: width *
//                                                                             0.08,
//                                                                         height:
//                                                                             0,
//                                                                         verticalPadding:
//                                                                             0,
//                                                                         horizontalPadding:
//                                                                             0,
//                                                                         buttonColor:
//                                                                             kTransparent,
//                                                                         border:
//                                                                             null,
//                                                                         borderRadius:
//                                                                             null,
//                                                                       ),
//                                                                       Text(
//                                                                           'تفاضل',
//                                                                           style: textStyle(
//                                                                               4,
//                                                                               width,
//                                                                               height,
//                                                                               kWhite)),
//                                                                       Text(
//                                                                           'النهايات',
//                                                                           style: textStyle(
//                                                                               4,
//                                                                               width,
//                                                                               height,
//                                                                               kWhite)),
//                                                                       Text(
//                                                                           'الإشتقاق',
//                                                                           style: textStyle(
//                                                                               4,
//                                                                               width,
//                                                                               height,
//                                                                               kWhite)),
//                                                                     ],
//                                                                   )),
//                                                         ),
//                                                         CustomContainer(
//                                                             onTap: null,
//                                                             width:
//                                                                 width * 0.049,
//                                                             height: null,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kDarkGray,
//                                                             border: null,
//                                                             borderRadius:
//                                                                 width * 0.005,
//                                                             child: Center(
//                                                               child: Text(
//                                                                   'الرياضيات',
//                                                                   style: textStyle(
//                                                                       3,
//                                                                       width,
//                                                                       height,
//                                                                       kWhite)),
//                                                             )),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               CustomContainer(
//                                                   onTap: null,
//                                                   width: width * 0.1,
//                                                   height: height * 0.05,
//                                                   verticalPadding: 0,
//                                                   horizontalPadding: 0,
//                                                   buttonColor: kDarkGray,
//                                                   border: null,
//                                                   borderRadius: width * 0.005,
//                                                   child: Center(
//                                                     child: Text('الأسوء',
//                                                         style: textStyle(
//                                                             3,
//                                                             width,
//                                                             height,
//                                                             kWhite)),
//                                                   )),
//                                               CustomContainer(
//                                                 onTap: null,
//                                                 width: width * 0.1,
//                                                 height: height * 0.4,
//                                                 verticalPadding: height * 0.02,
//                                                 horizontalPadding: 0,
//                                                 buttonColor: kDarkGray,
//                                                 border: null,
//                                                 borderRadius: width * 0.005,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Image(
//                                                           image: const AssetImage(
//                                                               'images/question_answer_imoji.png'),
//                                                           width: width * 0.04,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                         CustomContainer(
//                                                           onTap: null,
//                                                           width: width * 0.035,
//                                                           height: height * 0.05,
//                                                           verticalPadding: 0,
//                                                           horizontalPadding: 0,
//                                                           buttonColor: kRed,
//                                                           border: fullBorder(
//                                                               kPurple),
//                                                           borderRadius:
//                                                               width * 0.005,
//                                                           child: Center(
//                                                             child: Text('5',
//                                                                 style: textStyle(
//                                                                     3,
//                                                                     width,
//                                                                     height,
//                                                                     kWhite)),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Image(
//                                                           image: const AssetImage(
//                                                               'images/man_mark_imoji.png'),
//                                                           width: width * 0.04,
//                                                           height: height * 0.06,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                         CustomContainer(
//                                                           onTap: null,
//                                                           width: width * 0.035,
//                                                           height: height * 0.05,
//                                                           verticalPadding: 0,
//                                                           horizontalPadding: 0,
//                                                           buttonColor: kRed,
//                                                           border: fullBorder(
//                                                               kPurple),
//                                                           borderRadius:
//                                                               width * 0.005,
//                                                           child: Center(
//                                                             child: Text('1',
//                                                                 style: textStyle(
//                                                                     3,
//                                                                     width,
//                                                                     height,
//                                                                     kWhite)),
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Stack(
//                                                       alignment:
//                                                           Alignment.topCenter,
//                                                       children: [
//                                                         CustomContainer(
//                                                             onTap: null,
//                                                             width: width * 0.08,
//                                                             height:
//                                                                 height * 0.2,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kTransparent,
//                                                             border: null,
//                                                             borderRadius:
//                                                                 width * 0.005,
//                                                             child: null),
//                                                         Positioned(
//                                                           top: height * 0.028,
//                                                           left: 0,
//                                                           right: 0,
//                                                           child:
//                                                               CustomContainer(
//                                                                   onTap: null,
//                                                                   width: width *
//                                                                       0.08,
//                                                                   height:
//                                                                       height *
//                                                                           0.16,
//                                                                   verticalPadding:
//                                                                       height *
//                                                                           0.02,
//                                                                   horizontalPadding:
//                                                                       width *
//                                                                           0.02,
//                                                                   buttonColor:
//                                                                       kTransparent,
//                                                                   border:
//                                                                       fullBorder(
//                                                                           kWhite),
//                                                                   borderRadius:
//                                                                       width *
//                                                                           0.01,
//                                                                   child: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       CustomContainer(
//                                                                         onTap:
//                                                                             null,
//                                                                         width: width *
//                                                                             0.08,
//                                                                         height:
//                                                                             0,
//                                                                         verticalPadding:
//                                                                             0,
//                                                                         horizontalPadding:
//                                                                             0,
//                                                                         buttonColor:
//                                                                             kTransparent,
//                                                                         border:
//                                                                             null,
//                                                                         borderRadius:
//                                                                             null,
//                                                                       ),
//                                                                       Text(
//                                                                           'المبتدأ',
//                                                                           style: textStyle(
//                                                                               4,
//                                                                               width,
//                                                                               height,
//                                                                               kWhite)),
//                                                                     ],
//                                                                   )),
//                                                         ),
//                                                         CustomContainer(
//                                                             onTap: null,
//                                                             width:
//                                                                 width * 0.049,
//                                                             height: null,
//                                                             verticalPadding: 0,
//                                                             horizontalPadding:
//                                                                 0,
//                                                             buttonColor:
//                                                                 kDarkGray,
//                                                             border: null,
//                                                             borderRadius:
//                                                                 width * 0.005,
//                                                             child: Center(
//                                                               child: Text(
//                                                                   'العربي',
//                                                                   style: textStyle(
//                                                                       3,
//                                                                       width,
//                                                                       height,
//                                                                       kWhite)),
//                                                             )),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: height * 0.03),
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.only(
//                                         bottomRight:
//                                             Radius.circular(width * 0.01),
//                                         topRight: Radius.circular(width * 0.01),
//                                       ),
//                                       child: Image(
//                                         image: NetworkImage(Provider.of<
//                                                     DashboardProvider>(context,
//                                                 listen: true)
//                                             .advertisements
//                                             .first['image']), //TODO: multi adv
//                                         fit: BoxFit.fill,
//                                         width: width * 0.1,
//                                         height: height * 0.83,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ]),
//                           Positioned(
//                             top: height * 0.04,
//                             right: width * 0.41,
//                             child: Image(
//                               image: NetworkImage(
//                                   Provider.of<DashboardProvider>(context,
//                                           listen: true)
//                                       .quote),
//                               fit: BoxFit.contain,
//                               width: width * 0.2,
//                               height: height * 0.3,
//                             ),
//                           ),
//                           CustomContainer(
//                             width: width * 0.06,
//                             height: height * 0.9,
//                             border: singleLeftBorder(kDarkGray),
//                             buttonColor: kLightBlack,
//
//                             child: Column(
//                               mainAxisAlignment:MainAxisAlignment.spaceBetween,
//                               children: [
//
//                               Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: height * 0.02),
//                                 child: CustomContainer(
//                                   onTap: () {
//                                     websiteProvider.setLoaded(false);
//                                     context.pushReplacement('/Dashboard');
//                                   },
//                                   buttonColor: kDarkBlack,
//                                   border: null,
//                                   width: width*0.035,
//                                   height:height*0.06,
//                                   borderRadius: width * 0.005,
//                                   child: Icon(
//                                     Icons.home_rounded,
//                                     size: width * 0.02,
//                                     color: kLightPurple,
//                                   ),
//                                 ),
//                               ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: height * 0.02),
//                                   child: CustomContainer(
//                                     onTap: () {
//                                       websiteProvider.setLoaded(false);
//                                       context.pushReplacement('/QuizHistory');
//                                     },
//                                     buttonColor: kDarkBlack,
//                                     border: null,
//                                     width: width*0.035,
//                                     height:height*0.06,
//                                     borderRadius: width * 0.005,
//                                     child: Icon(
//                                       Icons.history_edu,
//                                       size: width * 0.02,
//                                       color: kLightPurple,
//                                     ),
//                                   ),
//                                 ),
//                               Column(children:[
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: height * 0.02),
//                                   child: Divider(
//                                     thickness: 1,
//                                     indent: width * 0.005,
//                                     endIndent: width * 0.005,
//                                     color: kDarkGray,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: height * 0.02),
//                                   child: CustomContainer(
//                                       onTap: () {},
//                                       buttonColor: kDarkBlack,
//                                       border: null,
//                                       width: width*0.035,
//                                       height:height*0.06,
//                                       borderRadius: width * 0.005,
//                                       child: Image(
//                                         image: const AssetImage('images/phone_bar.png'),
//                                         fit: BoxFit.contain,
//                                         width: width * 0.02,
//                                         height: width*0.02,
//                                       )
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: height * 0.02),
//                                   child: CustomContainer(
//                                       onTap: () {
//                                         launchUrl(Uri.parse('https://www.facebook.com/malook.akram'));
//                                       },
//                                       buttonColor: kDarkBlack,
//                                       border: null,
//                                       width: width*0.035,
//                                       height:height*0.06,
//                                       borderRadius: width * 0.005,
//                                       child: Image(
//                                         image: const AssetImage('images/facebook_bar.png'),
//                                         fit: BoxFit.contain,
//                                         width: width * 0.02,
//                                         height: width*0.02,
//
//                                       )
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: height * 0.02),
//                                   child: CustomContainer(
//                                     onTap: () {
//                                       launchUrl(Uri.parse('https://wa.me/+962786636678'));
//                                     },
//                                     buttonColor: kDarkBlack,
//                                     border: null,
//                                       width: width*0.035,
//                                       height:height*0.06,
//                                     borderRadius: width * 0.005,
//                                     child: Image(
//                                       image: const AssetImage('images/whats_bar.png'),
//                                       fit: BoxFit.contain,
//                                       width: width * 0.02,
//                                       height: width*0.02,
//                                     )
//                                   ),
//                                 )
//                               ])
//                             ],),
//                           ),
//                         ],
//                       ),
//                     ],
//                   )),
//             ),
//           ))
//         : Scaffold(
//             backgroundColor: kDarkGray,
//             body: Center(
//                 child: CircularProgressIndicator(
//                     color: kPurple, strokeWidth: width * 0.05)));
//   }
// }
