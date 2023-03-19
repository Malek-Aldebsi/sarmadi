import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import '../components/custom_divider.dart';
import '../const/borders.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../const/fonts.dart';
import '../const/colors.dart';
// import 'package:carousel_slider/carousel_slider.dart';

import '../utils/http_requests.dart';
import '../utils/session.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/Dashboard/';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool loaded = false;

  String userName = '';
  double profileCompletionPercentage = 0; //TODO:

  Widget quote = const SizedBox();

  List advertisements = [];

  String todayDate = '00-00-0000';
  Map tasks = {};
  double dailyTasksCompletionPercentage = 0;
  double weeklyTasksCompletionPercentage = 0; //TODO:
  bool tasksUpdated = false;

  Map subjects_color = {
    'التاريخ': {'color': kSkin, 'visible': false},
    'التربية الإسلامية': {'color': kRed, 'visible': false},
    'اللغة العربية': {'color': kBrown, 'visible': false},
    'اللغة الإنجليزية': {'color': kLightPurple, 'visible': false},
    'الكيمياء': {'color': kLightGreen, 'visible': false},
    'الأحياء': {'color': kBlue, 'visible': false},
    'الفيزياء': {'color': kPink, 'visible': false},
    'الرياضيات': {'color': kYellow, 'visible': false},
  };

  void getInfo() async {
    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('dashboard/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              userName = result['user_name'];
              quote = Image(
                image: NetworkImage(result['quote']),
                fit: BoxFit.contain,
              );
              todayDate = result['today_date'];
              for (String adv in result['advertisements']) {
                advertisements.add(adv);
              }
              dynamic totalTasks = 0;
              dynamic totalDone = 0;

              for (Map subject in result['tasks']) {
                totalTasks += subject['task'];
                totalDone += subject['done'];
                tasks[subject['subject']] = {
                  'task': subject['task'],
                  'done': subject['done']
                };
              }

              for (String subject in subjects_color.keys) {
                tasks[subject] == null
                    ? tasks[subject] = {'task': 0, 'done': 0}
                    : null;
              }

              dailyTasksCompletionPercentage =
                  totalTasks == 0 ? 0 : totalDone / totalTasks;

              loaded = true;
            });
    });
  }

  // int _current = 0;
  // final CarouselController _controller = CarouselController();

  @override
  void initState() {
    getInfo();
    super.initState();

    window.onBeforeUnload.listen((event) {
      if (tasksUpdated) {}
      // TODO:
    });

    forwardAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        upperBound: 1,
        lowerBound: 0);
    forwardAnimationCurve = CurvedAnimation(
        parent: forwardAnimationController!, curve: Curves.linear);

    backwardAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        upperBound: 1,
        lowerBound: 0);
    backwardAnimationCurve = CurvedAnimation(
        parent: backwardAnimationController!, curve: Curves.linear);

    forwardAnimationController!.forward();
    forwardAnimationCurve!.addListener(() => setState(() {
          forwardAnimationValue = forwardAnimationCurve!.value;
        }));
  }

  bool barVisibility = false;

  AnimationController? forwardAnimationController;
  CurvedAnimation? forwardAnimationCurve;
  dynamic forwardAnimationValue = 1;

  AnimationController? backwardAnimationController;
  CurvedAnimation? backwardAnimationCurve;
  dynamic backwardAnimationValue = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return loaded
        ? Scaffold(
            body: SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: CustomContainer(
                  onTap: null,
                  width: width,
                  height: height,
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  buttonColor: kLightBlack,
                  border: null,
                  borderRadius: null,
                  child: Column(
                    children: [
                      CustomContainer(
                        onTap: null,
                        width: width,
                        height: height * 0.1,
                        verticalPadding: 0,
                        horizontalPadding: 0,
                        buttonColor: kTransparent,
                        border: singleBottomBorder(kDarkGray),
                        borderRadius: null,
                        child: Row(
                          children: [
                            SizedBox(width: width * 0.005),
                            Image(
                              image: const AssetImage('images/logo.png'),
                              fit: BoxFit.contain,
                              width: width * 0.05,
                            ),
                            SizedBox(width: width * 0.0037),
                            CustomDivider(
                              dashHeight: 2,
                              dashWidth: width * 0.005,
                              dashColor: kDarkGray,
                              direction: Axis.vertical,
                              fillRate: 1,
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: width * 0.06),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * 0.06),
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.4,
                                      height: height * 0.25,
                                      verticalPadding: height * 0.03,
                                      horizontalPadding: width * 0.02,
                                      buttonColor: kDarkGray,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('أهلا $userName، صباح الخير',
                                                  style: textStyle(2, width,
                                                      height, kWhite)),
                                              SizedBox(width: width * 0.02),
                                              Icon(
                                                Icons.sunny,
                                                color: Colors.amber,
                                                size: width * 0.025,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('حسابك مكتمل بنسبة',
                                                  style: textStyle(3, width,
                                                      height, kWhite)),
                                              SizedBox(width: width * 0.02),
                                              CircularChart(
                                                width: width * 0.028,
                                                label:
                                                    profileCompletionPercentage,
                                                inActiveColor: kWhite,
                                                labelColor: kWhite,
                                              )
                                            ],
                                          ),
                                          Text('أظهر المزيد',
                                              style: textStyle(
                                                  5, width, height, kPurple)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height * 0.03),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomContainer(
                                          onTap: null,
                                          width: width * 0.4,
                                          height: height * 0.08,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          buttonColor: kTransparent,
                                          border: null,
                                          borderRadius: width * 0.005,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomContainer(
                                                onTap: null,
                                                width: width * 0.06,
                                                height: height * 0.035,
                                                verticalPadding: 0,
                                                horizontalPadding: 0,
                                                buttonColor: kPurple,
                                                border: null,
                                                borderRadius: width * 0.01,
                                                child: Center(
                                                  child: Text(todayDate,
                                                      style: textStyle(4, width,
                                                          height, kWhite)),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  for (MapEntry subject
                                                      in subjects_color
                                                          .entries) ...[
                                                    MouseRegion(
                                                      onHover: (isHover) {
                                                        setState(() {
                                                          subject.value[
                                                              'visible'] = true;
                                                        });
                                                      },
                                                      onExit: (e) {
                                                        setState(() {
                                                          subject.value[
                                                                  'visible'] =
                                                              false;
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Visibility(
                                                            visible:
                                                                subject.value[
                                                                    'visible'],
                                                            child:
                                                                CustomContainer(
                                                              onTap: null,
                                                              width:
                                                                  width * 0.05,
                                                              height:
                                                                  height * 0.04,
                                                              verticalPadding:
                                                                  0,
                                                              horizontalPadding:
                                                                  0,
                                                              buttonColor:
                                                                  kDarkGray,
                                                              border:
                                                                  fullBorder(
                                                                      kPurple),
                                                              borderRadius:
                                                                  width * 0.005,
                                                              child: Text(
                                                                  subject.key,
                                                                  style: textStyle(
                                                                      5,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                            ),
                                                          ),
                                                          CustomContainer(
                                                            onTap: null,
                                                            width:
                                                                height * 0.02,
                                                            height:
                                                                height * 0.02,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor: subject
                                                                .value['color'],
                                                            border: null,
                                                            borderRadius: width,
                                                            child: null,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * 0.008),
                                                  ]
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        CustomContainer(
                                          onTap: null,
                                          width: width * 0.4,
                                          height: height * 0.4,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          buttonColor: kDarkGray,
                                          border: null,
                                          borderRadius: width * 0.005,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: Text('الجدول اليومي',
                                                    style: textStyle(2, width,
                                                        height, kWhite)),
                                              ),
                                              for (String subject
                                                  in (tasks.keys).take(5))
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomContainer(
                                                      onTap: null,
                                                      width: width * 0.28,
                                                      height: height * 0.025,
                                                      verticalPadding: 0,
                                                      horizontalPadding: 0,
                                                      buttonColor: kLightGray,
                                                      border: null,
                                                      borderRadius:
                                                          width * 0.01,
                                                      child: Row(
                                                        children: [
                                                          CustomContainer(
                                                              onTap: null,
                                                              width: width * 0.28 * tasks[subject]['task'] == 0
                                                                  ? 0
                                                                  : (tasks[subject]['done'] / tasks[subject]['task']) *
                                                                      width *
                                                                      0.28,
                                                              height: height *
                                                                  0.025,
                                                              verticalPadding:
                                                                  0,
                                                              horizontalPadding:
                                                                  0,
                                                              buttonColor:
                                                                  subjects_color[subject]
                                                                      ['color'],
                                                              border: null,
                                                              borderRadius:
                                                                  width * 0.005,
                                                              child: (tasks[subject]['done'] / tasks[subject]['task'] * 100).toStringAsFixed(0) ==
                                                                      '100'
                                                                  ? Center(
                                                                      child: Text(
                                                                          '100%',
                                                                          style: textStyle(
                                                                              5,
                                                                              width,
                                                                              height,
                                                                              kLightBlack)))
                                                                  : const SizedBox()),
                                                          if ((tasks[subject][
                                                                      'done'] !=
                                                                  tasks[subject]
                                                                      [
                                                                      'task']) ||
                                                              tasks[subject][
                                                                      'task'] ==
                                                                  0) ...[
                                                            SizedBox(
                                                                width: width *
                                                                    0.005),
                                                            Text(
                                                                tasks[subject][
                                                                            'task'] ==
                                                                        0
                                                                    ? '0%'
                                                                    : '${(tasks[subject]['done'] / tasks[subject]['task'] * 100).toStringAsFixed(0)}%',
                                                                style: textStyle(
                                                                    5,
                                                                    width,
                                                                    height,
                                                                    kLightBlack)),
                                                          ]
                                                        ],
                                                      ),
                                                    ),
                                                    CustomContainer(
                                                      onTap: null,
                                                      width: width * 0.06,
                                                      height: height * 0.03,
                                                      verticalPadding: 0,
                                                      horizontalPadding: 0,
                                                      buttonColor: kWhite,
                                                      border: null,
                                                      borderRadius:
                                                          width * 0.01,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          CustomContainer(
                                                            onTap: () {
                                                              setState(() {
                                                                tasks[subject][
                                                                    'task'] += 1;
                                                              });
                                                            },
                                                            width:
                                                                height * 0.03,
                                                            height:
                                                                height * 0.03,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kPurple,
                                                            border: null,
                                                            borderRadius: width,
                                                            child: Icon(
                                                              Icons.add,
                                                              size:
                                                                  width * 0.01,
                                                              color: kWhite,
                                                            ),
                                                          ),
                                                          Text(
                                                              '${tasks[subject]['task']}',
                                                              style: textStyle(
                                                                  4,
                                                                  width,
                                                                  height,
                                                                  kLightBlack)),
                                                          CustomContainer(
                                                            onTap: () {
                                                              setState(() {
                                                                if (tasks[subject]
                                                                        [
                                                                        'task'] >
                                                                    tasks[subject]
                                                                        [
                                                                        'done']) {
                                                                  tasks[subject]
                                                                      [
                                                                      'task'] -= 1;
                                                                }
                                                              });
                                                            },
                                                            width:
                                                                height * 0.03,
                                                            height:
                                                                height * 0.03,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kPurple,
                                                            border: null,
                                                            borderRadius: width,
                                                            child: Icon(
                                                              Icons.remove,
                                                              size:
                                                                  width * 0.01,
                                                              color: kWhite,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              const SizedBox(),
                                              Row(
                                                children: [
                                                  Text('لقد أنجزت مهامك بنسبة:',
                                                      style: textStyle(3, width,
                                                          height, kWhite)),
                                                  SizedBox(width: width * 0.01),
                                                  CircularChart(
                                                    width: width * 0.028,
                                                    label:
                                                        dailyTasksCompletionPercentage,
                                                    inActiveColor: kWhite,
                                                    labelColor: kWhite,
                                                  ),
                                                  SizedBox(width: width * 0.03),
                                                  Text('معدل إنجازك الاسبوعي:',
                                                      style: textStyle(3, width,
                                                          height, kWhite)),
                                                  SizedBox(width: width * 0.01),
                                                  CircularChart(
                                                    width: width * 0.028,
                                                    label:
                                                        weeklyTasksCompletionPercentage,
                                                    inActiveColor: kWhite,
                                                    labelColor: kWhite,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * 0.06),
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.33,
                                      height: height * 0.27,
                                      verticalPadding: height * 0.02,
                                      horizontalPadding: width * 0.02,
                                      buttonColor: kDarkGray,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: null,
                                    ),
                                    SizedBox(height: height * 0.03),
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.33,
                                      height: height * 0.46,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      buttonColor: kTransparent,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.1,
                                            height: height * 0.46,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            buttonColor: kDarkGray,
                                            border: null,
                                            borderRadius: width * 0.005,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text('أكمل...',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                    Icon(
                                                      Icons.turn_left_rounded,
                                                      size: width * 0.03,
                                                      color: kPurple,
                                                    ),
                                                  ],
                                                ),
                                                Image(
                                                  image: const AssetImage(
                                                      'images/question_examplea.png'),
                                                  width: width * 0.08,
                                                  height: height * 0.35,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox()
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomContainer(
                                                  onTap: null,
                                                  width: width * 0.1,
                                                  height: height * 0.05,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  buttonColor: kDarkGray,
                                                  border: null,
                                                  borderRadius: width * 0.005,
                                                  child: Center(
                                                    child: Text('الأفضل',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  )),
                                              CustomContainer(
                                                onTap: null,
                                                width: width * 0.1,
                                                height: height * 0.4,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: 0,
                                                buttonColor: kDarkGray,
                                                border: null,
                                                borderRadius: width * 0.005,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: const AssetImage(
                                                              'images/question_answer_imoji.png'),
                                                          width: width * 0.04,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        CustomContainer(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          buttonColor:
                                                              kDarkGreen,
                                                          border: fullBorder(
                                                              kPurple),
                                                          borderRadius:
                                                              width * 0.005,
                                                          child: Center(
                                                            child: Text('30',
                                                                style: textStyle(
                                                                    3,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/man_mark_imoji.png'),
                                                          width: width * 0.04,
                                                          height: height * 0.06,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        CustomContainer(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          buttonColor:
                                                              kDarkGreen,
                                                          border: fullBorder(
                                                              kPurple),
                                                          borderRadius:
                                                              width * 0.005,
                                                          child: Center(
                                                            child: Text('10',
                                                                style: textStyle(
                                                                    3,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        CustomContainer(
                                                            onTap: null,
                                                            width: width * 0.08,
                                                            height:
                                                                height * 0.2,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kTransparent,
                                                            border: null,
                                                            borderRadius:
                                                                width * 0.005,
                                                            child: null),
                                                        Positioned(
                                                          top: height * 0.028,
                                                          left: 0,
                                                          right: 0,
                                                          child:
                                                              CustomContainer(
                                                                  onTap: null,
                                                                  width: width *
                                                                      0.08,
                                                                  height:
                                                                      height *
                                                                          0.16,
                                                                  verticalPadding:
                                                                      height *
                                                                          0.02,
                                                                  horizontalPadding:
                                                                      width *
                                                                          0.02,
                                                                  buttonColor:
                                                                      kTransparent,
                                                                  border:
                                                                      fullBorder(
                                                                          kWhite),
                                                                  borderRadius:
                                                                      width *
                                                                          0.01,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CustomContainer(
                                                                        onTap:
                                                                            null,
                                                                        width: width *
                                                                            0.08,
                                                                        height:
                                                                            0,
                                                                        verticalPadding:
                                                                            0,
                                                                        horizontalPadding:
                                                                            0,
                                                                        buttonColor:
                                                                            kTransparent,
                                                                        border:
                                                                            null,
                                                                        borderRadius:
                                                                            null,
                                                                      ),
                                                                      Text(
                                                                          'تفاضل',
                                                                          style: textStyle(
                                                                              4,
                                                                              width,
                                                                              height,
                                                                              kWhite)),
                                                                      Text(
                                                                          'النهايات',
                                                                          style: textStyle(
                                                                              4,
                                                                              width,
                                                                              height,
                                                                              kWhite)),
                                                                      Text(
                                                                          'الإشتقاق',
                                                                          style: textStyle(
                                                                              4,
                                                                              width,
                                                                              height,
                                                                              kWhite)),
                                                                    ],
                                                                  )),
                                                        ),
                                                        CustomContainer(
                                                            onTap: null,
                                                            width:
                                                                width * 0.049,
                                                            height: null,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kDarkGray,
                                                            border: null,
                                                            borderRadius:
                                                                width * 0.005,
                                                            child: Center(
                                                              child: Text(
                                                                  'الرياضيات',
                                                                  style: textStyle(
                                                                      3,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomContainer(
                                                  onTap: null,
                                                  width: width * 0.1,
                                                  height: height * 0.05,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  buttonColor: kDarkGray,
                                                  border: null,
                                                  borderRadius: width * 0.005,
                                                  child: Center(
                                                    child: Text('الأسوء',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  )),
                                              CustomContainer(
                                                onTap: null,
                                                width: width * 0.1,
                                                height: height * 0.4,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: 0,
                                                buttonColor: kDarkGray,
                                                border: null,
                                                borderRadius: width * 0.005,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: const AssetImage(
                                                              'images/question_answer_imoji.png'),
                                                          width: width * 0.04,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        CustomContainer(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          buttonColor: kRed,
                                                          border: fullBorder(
                                                              kPurple),
                                                          borderRadius:
                                                              width * 0.005,
                                                          child: Center(
                                                            child: Text('5',
                                                                style: textStyle(
                                                                    3,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/man_mark_imoji.png'),
                                                          width: width * 0.04,
                                                          height: height * 0.06,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        CustomContainer(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          buttonColor: kRed,
                                                          border: fullBorder(
                                                              kPurple),
                                                          borderRadius:
                                                              width * 0.005,
                                                          child: Center(
                                                            child: Text('1',
                                                                style: textStyle(
                                                                    3,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        CustomContainer(
                                                            onTap: null,
                                                            width: width * 0.08,
                                                            height:
                                                                height * 0.2,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kTransparent,
                                                            border: null,
                                                            borderRadius:
                                                                width * 0.005,
                                                            child: null),
                                                        Positioned(
                                                          top: height * 0.028,
                                                          left: 0,
                                                          right: 0,
                                                          child:
                                                              CustomContainer(
                                                                  onTap: null,
                                                                  width: width *
                                                                      0.08,
                                                                  height:
                                                                      height *
                                                                          0.16,
                                                                  verticalPadding:
                                                                      height *
                                                                          0.02,
                                                                  horizontalPadding:
                                                                      width *
                                                                          0.02,
                                                                  buttonColor:
                                                                      kTransparent,
                                                                  border:
                                                                      fullBorder(
                                                                          kWhite),
                                                                  borderRadius:
                                                                      width *
                                                                          0.01,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      CustomContainer(
                                                                        onTap:
                                                                            null,
                                                                        width: width *
                                                                            0.08,
                                                                        height:
                                                                            0,
                                                                        verticalPadding:
                                                                            0,
                                                                        horizontalPadding:
                                                                            0,
                                                                        buttonColor:
                                                                            kTransparent,
                                                                        border:
                                                                            null,
                                                                        borderRadius:
                                                                            null,
                                                                      ),
                                                                      Text(
                                                                          'المبتدأ',
                                                                          style: textStyle(
                                                                              4,
                                                                              width,
                                                                              height,
                                                                              kWhite)),
                                                                    ],
                                                                  )),
                                                        ),
                                                        CustomContainer(
                                                            onTap: null,
                                                            width:
                                                                width * 0.049,
                                                            height: null,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            buttonColor:
                                                                kDarkGray,
                                                            border: null,
                                                            borderRadius:
                                                                width * 0.005,
                                                            child: Center(
                                                              child: Text(
                                                                  'العربي',
                                                                  style: textStyle(
                                                                      3,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: height * 0.03),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(width * 0.01),
                                        topRight: Radius.circular(width * 0.01),
                                      ),
                                      child: Image(
                                        image: NetworkImage(advertisements[0]),
                                        fit: BoxFit.fill,
                                        width: width * 0.1,
                                        height: height * 0.83,
                                      ),
                                    ),
                                  ],
                                ),

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
                              ]),
                          Positioned(
                            top: height * 0.04,
                            right: width * 0.41,
                            child: SizedBox(
                                width: width * 0.2,
                                height: height * 0.3,
                                child: quote),
                          ),
                          MouseRegion(
                            onHover: (isHover) {
                              setState(() {
                                forwardAnimationController!.reverse();
                                forwardAnimationCurve!
                                    .addListener(() => setState(() {
                                          forwardAnimationValue =
                                              forwardAnimationCurve!.value;
                                        }));

                                backwardAnimationController!.forward();
                                backwardAnimationCurve!
                                    .addListener(() => setState(() {
                                          backwardAnimationValue =
                                              backwardAnimationCurve!.value;
                                        }));
                              });
                            },
                            onExit: (e) {
                              setState(() {
                                forwardAnimationController!.forward();
                                forwardAnimationCurve!
                                    .addListener(() => setState(() {
                                          forwardAnimationValue =
                                              forwardAnimationCurve!.value;
                                        }));

                                backwardAnimationController!.reverse();
                                backwardAnimationCurve!
                                    .addListener(() => setState(() {
                                          backwardAnimationValue =
                                              backwardAnimationCurve!.value;
                                        }));
                              });
                            },
                            child: CustomContainer(
                                onTap: null,
                                width: width *
                                    (0.06 * forwardAnimationValue +
                                        0.2 * backwardAnimationValue),
                                height: height * 0.9,
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                buttonColor: kLightBlack.withOpacity(0.95),
                                border: singleLeftBorder(kDarkGray),
                                borderRadius: null,
                                child: ListView(
                                  children: [
                                    SizedBox(height: height * 0.02),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('الصفحة الرئيسية',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.home_rounded,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.01,
                                            vertical: height * 0.01),
                                        child: CustomContainer(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, QuizSetting.route);
                                          },
                                          width: width *
                                              (0.032 * forwardAnimationValue +
                                                  0.16 *
                                                      backwardAnimationValue),
                                          height: null,
                                          verticalPadding: width * 0.01,
                                          horizontalPadding: null,
                                          buttonColor: kDarkBlack,
                                          border: null,
                                          borderRadius: width * 0.005,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (backwardAnimationValue == 1)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width *
                                                          0.015 *
                                                          backwardAnimationValue),
                                                  child: Text('معلوماتي',
                                                      style: textStyle(3, width,
                                                          height, kWhite)),
                                                ),
                                              if (backwardAnimationValue != 1)
                                                SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Icon(
                                                  Icons.account_circle_outlined,
                                                  size: width * 0.02,
                                                  color: kWhite,
                                                ),
                                              ),
                                              if (backwardAnimationValue != 1)
                                                SizedBox(),
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.02),
                                      child: Divider(
                                        thickness: 1,
                                        indent: width * 0.005,
                                        endIndent: width * 0.005,
                                        color: kDarkGray,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.01,
                                            vertical: height * 0.01),
                                        child: CustomContainer(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, Dashboard.route);
                                          },
                                          width: width *
                                              (0.032 * forwardAnimationValue +
                                                  0.16 *
                                                      backwardAnimationValue),
                                          height: null,
                                          verticalPadding: width * 0.01,
                                          horizontalPadding: null,
                                          buttonColor: kDarkBlack,
                                          border: null,
                                          borderRadius: width * 0.005,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (backwardAnimationValue == 1)
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width *
                                                          0.015 *
                                                          backwardAnimationValue),
                                                  child: Text(
                                                      'يلا نساعدك بالدراسة',
                                                      style: textStyle(3, width,
                                                          height, kWhite)),
                                                ),
                                              if (backwardAnimationValue != 1)
                                                SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Icon(
                                                  Icons.school_outlined,
                                                  size: width * 0.02,
                                                  color: kWhite,
                                                ),
                                              ),
                                              if (backwardAnimationValue != 1)
                                                SizedBox(),
                                            ],
                                          ),
                                        )),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('امتحانات وأسئلة',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.fact_check_outlined,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('نتائج وتحليلات',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.analytics_outlined,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('مجتمع مدارس',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.groups,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('قائمة المتصدرين',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.emoji_events_outlined,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.02),
                                      child: Divider(
                                        thickness: 1,
                                        indent: width * 0.005,
                                        endIndent: width * 0.005,
                                        color: kDarkGray,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('الإعدادات',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.settings_outlined,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.01,
                                          vertical: height * 0.01),
                                      child: CustomContainer(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        },
                                        width: width *
                                            (0.032 * forwardAnimationValue +
                                                0.16 * backwardAnimationValue),
                                        height: null,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: null,
                                        buttonColor: kDarkBlack,
                                        border: null,
                                        borderRadius: width * 0.005,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (backwardAnimationValue == 1)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width *
                                                        0.015 *
                                                        backwardAnimationValue),
                                                child: Text('تواصل معنا',
                                                    style: textStyle(3, width,
                                                        height, kWhite)),
                                              ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width *
                                                      0.015 *
                                                      backwardAnimationValue),
                                              child: Icon(
                                                Icons.phone_outlined,
                                                size: width * 0.02,
                                                color: kWhite,
                                              ),
                                            ),
                                            if (backwardAnimationValue != 1)
                                              SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ))
        : Scaffold(
            backgroundColor: kDarkGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}

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
