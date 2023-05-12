// import 'package:carousel_slider/carousel_slider.dart';
// int _current = 0;
// final CarouselController _controller = CarouselController();
//     Row(
//       children: [
//     Button(
//         onTap: () {},
//         width: width * 0.35,
//         verticalPadding: height * 0.01,
//         horizontalPadding: 0,
//         borderRadius: 10,
//         border: 0,
//         buttonColor: kDarkGray,
//         child: Column(
//           children: [
//             CarouselSlider(
//               items: advList
//                   .map(
//                     (item) => Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: width * 0.01),
//                           child: Column(
//                             mainAxisAlignment:
//                                 MainAxisAlignment.center,
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item['title'],
//                                 style: textStyle.copyWith(
//                                   color: kWhite,
//                                   fontWeight:
//                                       FontWeight.w600,
//                                   fontSize: width * 0.02,
//                                 ),
//                               ),
//                               SizedBox(
//                                   height: height * 0.01),
//                               Text(
//                                 item['details'],
//                                 style: textStyle.copyWith(
//                                   color: kWhite,
//                                   fontWeight:
//                                       FontWeight.w400,
//                                   fontSize: width * 0.013,
//                                 ),
//                               ),
//                               Text(
//                                 'أظهر المزيد',
//                                 style: textStyle.copyWith(
//                                     fontSize: width / 130,
//                                     color: kPurple),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Image.asset(
//                           item['image'],
//                           fit: BoxFit.contain,
//                           alignment: Alignment.centerLeft,
//                           height: height * 0.3,
//                           width: width * 0.2,
//                         ),
//                       ],
//                     ),
//                   )
//                   .toList(),
//               options: CarouselOptions(
//                 onPageChanged: (index, reason) {
//                   setState(() {
//                     _current = index;
//                   });
//                 },
//                 viewportFraction: 1,
//                 autoPlay: true,
//               ),
//               carouselController: _controller,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children:
//                   advList.asMap().entries.map((entry) {
//                 return GestureDetector(
//                   onTap: () => _controller
//                       .animateToPage(entry.key),
//                   child: Container(
//                     width: width / 55,
//                     height: height / 55,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: _current == entry.key
//                             ? kPurple
//                             : kWhite),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         )),
//     Button(
//         onTap: () {},
//         width: width * 0.35,
//         verticalPadding: height * 0.01,
//         horizontalPadding: 0,
//         borderRadius: 10,
//         border: 0,
//         buttonColor: kDarkGray,
//         child: Container(height: height * 0.215)),
//   ],
// ),

// window.onBeforeUnload.listen((Event e) {
//   // display confirmation dialog
//   BeforeUnloadEvent event = e as BeforeUnloadEvent;
//   event.returnValue = 'Are you sure you want to leave?';
// });

// WillPopScope(
//                onWillPop: () async {
//                  // show confirmation dialog
//                  bool confirm = await showDialog(
//                    context: context,
//                    builder: (BuildContext context) {
//                      return AlertDialog(
//                        title: Text("Are you sure?"),
//                        content: Text("Do you want to exit the app?"),
//                        actions: <Widget>[
//                          TextButton(
//                            child: Text("CANCEL"),
//                            onPressed: () => Navigator.of(context).pop(false),
//                          ),
//                          TextButton(
//                            child: Text("YES"),
//                            onPressed: () => Navigator.of(context).pop(true),
//                          ),
//                        ],
//                      );
//                    },
//                  );
//                  // return true if user confirms action, false otherwise
//                  return confirm ?? false;
//                },
//                child:

// Padding(
//   padding:
//   EdgeInsets.symmetric(vertical: height / 40),
//   child: IconButton(
//     onPressed: () {
//       popUp(context, width * 0.3,
//           'هل حقاً تريد تسجيل الخروج', [
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Button(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   width: width * 0.13,
//                   verticalPadding: 8,
//                   horizontalPadding: 0,
//                   borderRadius: 8,
//                   buttonColor: kBlack,
//                   border: 0,
//                   child: Center(
//                     child: Text(
//                       'لا',
//                       style: textStyle,
//                     ),
//                   ),
//                 ),
//                 Button(
//                   onTap: () {
//                     delSession('sessionKey0');
//                     delSession('sessionKey1');
//                     delSession('sessionValue').then(
//                             (value) =>
//                             Navigator.pushNamed(
//                                 context,
//                                 Welcome.route));
//                   },
//                   width: width * 0.13,
//                   verticalPadding: 8,
//                   horizontalPadding: 0,
//                   borderRadius: 8,
//                   buttonColor: kOffWhite,
//                   border: 0,
//                   child: Center(
//                     child: Text(
//                       'نعم',
//                       style: textStyle.copyWith(
//                           color: kBlack),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ]);
//     }, //home dashboard
//     icon: Icon(
//       Icons.logout_rounded,
//       size: width * 0.02,
//       color: kWhite,
//     ),
//   ),
// ),
