import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/const/borders.dart';
import '../components/custom_divider.dart';
import '../components/string_with_latex.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import 'dashboard.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class QuizResult extends StatefulWidget {
  static const String route = '/QuizResult/';
  const QuizResult({Key? key}) : super(key: key);

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> with TickerProviderStateMixin {
  bool loaded = false;

  String subject = '';

  List questions = [];
  int questionIndex = 1;
  String quizTime = '';

  Map quizContent = {
    'modules': ['النهايات', 'التفاضل', 'التكامل', 'الاشتقاق'],
    'lessons': ['الاحصاء', 'الاحتمالات'],
    'skills': ['المعادلات التفاضلية', 'التطبيقات العامة'],
    'generalSkills': ['الرسم البياني', 'الحساب الذهني'],
  };

  Map quizResult = { //TODO
    'correct_question': 1,
  };

  void getResult() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('quiz_review/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'quiz_id': Provider.of<QuizProvider>(context, listen: false).quizID
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              subject=result['quiz_subject'];
              quizTime= result['quiz_duration'];
              questions = result['answers'];
              loaded = true;
            });
    });
  }

  @override
  void initState() {
    getResult();
    super.initState();

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

  ScrollController scrollController = ScrollController();

  Duration toDuration(String time) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = time.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return loaded
        ? Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/home_dashboard_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: width * 0.09),
                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                SizedBox(height: height * 0.1),
                                SizedBox(
                                  width: width * 0.93,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: height * 0.4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(subject,
                                                style: textStyle(
                                                    1, width, height, kWhite)),
                                            Row(
                                              children: [
                                                CustomContainer(
                                                    width: width * 0.2,
                                                    height: height * 0.18,
                                                    onTap: null,
                                                    verticalPadding:
                                                        height * 0.02,
                                                    horizontalPadding:
                                                        width * 0.02,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kDarkGray,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('علامة الامتحان',
                                                            style: textStyle(
                                                                3,
                                                                width,
                                                                height,
                                                                kWhite)),
                                                        SizedBox(
                                                            height:
                                                                height * 0.01),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'جاوبت على ${quizResult['correct_question']} أسئلة من أصل ${questions.length}',
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            CircularChart(
                                                              width:
                                                                  width * 0.035,
                                                              label: double.parse((100 *
                                                                      quizResult[
                                                                          'correct_question'] /
                                                                  questions.length)
                                                                  .toStringAsFixed(
                                                                      1)),
                                                              inActiveColor:
                                                                  kWhite,
                                                              labelColor:
                                                                  kWhite,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                SizedBox(width: width * 0.02),
                                                CustomContainer(
                                                    width: width * 0.2,
                                                    height: height * 0.18,
                                                    onTap: null,
                                                    verticalPadding:
                                                        height * 0.02,
                                                    horizontalPadding:
                                                        width * 0.02,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kDarkGray,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('الوقت المستهلك',
                                                            style: textStyle(
                                                                3,
                                                                width,
                                                                height,
                                                                kWhite)),
                                                        SizedBox(
                                                            height:
                                                                height * 0.01),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'أنهيت الامتحان ب${Duration(seconds: questions.fold(0, (prev, curr) => prev + toDuration(curr['duration']).inSeconds)).inMinutes} دقائق\nمن أصل ${toDuration(quizTime==null?'00:00:00': quizTime).inMinutes}',
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            CircularChart(
                                                              width:
                                                                  width * 0.035,
                                                              label: double.parse((100 *
                                                                  questions.fold(0, (prev, curr) => prev + toDuration(curr['duration']).inSeconds) /
                                                                  toDuration(quizTime==null?'00:00:00': quizTime).inSeconds)
                                                                  .toStringAsFixed(
                                                                      1)),
                                                              inActiveColor:
                                                                  kWhite,
                                                              labelColor:
                                                                  kWhite,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            ),
                                            CustomContainer(
                                                width: width * 0.42,
                                                height: height * 0.08,
                                                onTap: () {
                                                  scrollController.animateTo(
                                                    scrollController.position
                                                        .maxScrollExtent,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.easeOut,
                                                  );
                                                },
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.01,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kDarkGray,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('مراجعة الأسئلة',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                    SizedBox(
                                                      width: width * 0.05,
                                                    ),
                                                    Image(
                                                      image: const AssetImage(
                                                          'images/quiz_revision.png'),
                                                      fit: BoxFit.contain,
                                                      width: width * 0.035,
                                                      height: height * 0.07,
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      SizedBox(
                                        height: height * 0.36,
                                        child: CustomDivider(
                                          dashHeight: 2,
                                          dashWidth: width * 0.005,
                                          dashColor: kDarkGray.withOpacity(0.6),
                                          direction: Axis.vertical,
                                          fillRate: 0.6,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      SizedBox(
                                        height: height * 0.4,
                                        width: width * 0.42,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'معدل التحصيل لكل مهارات الامتحان',
                                                          style: textStyle(
                                                              3,
                                                              width,
                                                              height,
                                                              kLightPurple)),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: width * 0.01,
                                                            height:
                                                                width * 0.01,
                                                            decoration: BoxDecoration(
                                                                color: kOrange,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(width *
                                                                            0.002)),
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.005),
                                                          Text('وحدة كاملة',
                                                              style: textStyle(
                                                                  5,
                                                                  width,
                                                                  height,
                                                                  kWhite)),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.02),
                                                          Container(
                                                            width: width * 0.01,
                                                            height:
                                                                width * 0.01,
                                                            decoration: BoxDecoration(
                                                                color: kBlue,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(width *
                                                                            0.002)),
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.005),
                                                          Text(
                                                            'درس',
                                                            style: textStyle(
                                                                5,
                                                                width,
                                                                height,
                                                                kWhite),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.02),
                                                          Container(
                                                            width: width * 0.01,
                                                            height:
                                                                width * 0.01,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    kLightGreen,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(width *
                                                                            0.002)),
                                                          ),
                                                          SizedBox(
                                                              width: width *
                                                                  0.005),
                                                          Text(
                                                            'مهارة خاصة',
                                                            style: textStyle(
                                                                4,
                                                                width,
                                                                height,
                                                                kWhite),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  Wrap(
                                                    spacing: width * 0.005,
                                                    runSpacing: height * 0.01,
                                                    children: [
                                                      for (String key
                                                          in quizContent.keys)
                                                        for (String tag
                                                            in quizContent[key])
                                                          Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              CustomContainer(
                                                                onTap: null,
                                                                width: width *
                                                                        0.055 +
                                                                    (tag.length *
                                                                        4),
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                border: null,
                                                                buttonColor:
                                                                    kDarkGray,
                                                                child: Row(
                                                                  children: [
                                                                    CustomContainer(
                                                                        onTap:
                                                                            null,
                                                                        width: width *
                                                                                0.055 *
                                                                                0.5 +
                                                                            (tag.length *
                                                                                4),
                                                                        verticalPadding: height *
                                                                            0.01,
                                                                        horizontalPadding:
                                                                            width *
                                                                                0.01,
                                                                        borderRadius:
                                                                            width *
                                                                                0.005,
                                                                        border:
                                                                            null,
                                                                        buttonColor: key ==
                                                                                'modules'
                                                                            ? kOrange
                                                                            : key == 'lessons'
                                                                                ? kLightGreen
                                                                                : kBlue,
                                                                        child: const SizedBox()),
                                                                  ],
                                                                ),
                                                              ),
                                                              CustomContainer(
                                                                onTap: null,
                                                                width: width *
                                                                        0.055 +
                                                                    (tag.length *
                                                                        4),
                                                                verticalPadding:
                                                                    height *
                                                                        0.01,
                                                                horizontalPadding:
                                                                    width *
                                                                        0.01,
                                                                borderRadius: 0,
                                                                border: null,
                                                                buttonColor: Colors
                                                                    .transparent,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      tag,
                                                                      style: textStyle(
                                                                          5,
                                                                          width,
                                                                          height,
                                                                          kWhite),
                                                                    ),
                                                                    Text(
                                                                      '50%',
                                                                      style: textStyle(
                                                                          5,
                                                                          width,
                                                                          height,
                                                                          kWhite),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                    ],
                                                  ),
                                                ]),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'مهامك اكتملت بنسبة :',
                                                  style: textStyle(3, width,
                                                      height, kLightPurple),
                                                ),
                                                SizedBox(height: height * 0.02),
                                                Row(
                                                  children: [
                                                    CustomContainer(
                                                      onTap: null,
                                                      height: height * 0.022,
                                                      width: width * 0.35,
                                                      verticalPadding: 0,
                                                      horizontalPadding: 0,
                                                      borderRadius:
                                                          width * 0.005,
                                                      border: null,
                                                      buttonColor: kLightGray,
                                                      child: Row(
                                                        children: [
                                                          CustomContainer(
                                                              onTap: null,
                                                              height: height *
                                                                  0.022,
                                                              width:
                                                                  width * 0.12,
                                                              verticalPadding:
                                                                  0,
                                                              horizontalPadding:
                                                                  0,
                                                              borderRadius:
                                                                  width * 0.005,
                                                              border: null,
                                                              buttonColor:
                                                                  kSkin,
                                                              child:
                                                                  const SizedBox()),
                                                          SizedBox(
                                                              width: width *
                                                                  0.005),
                                                          Text(
                                                            '25%',
                                                            style: textStyle(
                                                                5,
                                                                width,
                                                                height,
                                                                kLightBlack),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.02,
                                                    ),
                                                    Text(
                                                      'أظهر المزيد',
                                                      style: textStyle(5, width,
                                                          height, kLightPurple),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        CustomContainer(
                                            width: width * 0.88,
                                            height: height * 0.4),
                                        CustomContainer(
                                            width: width * 0.7,
                                            height: height * 0.4,
                                            onTap: null,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kDarkGray,
                                            child: SizedBox()),
                                        Positioned(
                                          left: 0,
                                          bottom: 0,
                                          child: Image(
                                            image: const AssetImage(
                                                'images/advises.png'),
                                            width: width * 0.4,
                                            height: height * 0.38,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.bottomLeft,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: height * 0.04),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('سجل الأسئلة',
                                            style: textStyle(
                                                2, width, height, kWhite)),
                                        SizedBox(height: height * 0.01),
                                        SizedBox(
                                          width: width * 0.14,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('الأسئلة',
                                                  style: textStyle(3, width,
                                                      height, kWhite)),
                                              Row(
                                                children: [
                                                  CustomContainer(
                                                      onTap: () {
                                                        setState(() {
                                                          questionIndex =
                                                              questionIndex ==
                                                                      questions
                                                                          .length
                                                                  ? 1
                                                                  : questionIndex +
                                                                      1;
                                                        });
                                                      },
                                                      width: width * 0.022,
                                                      height: width * 0.022,
                                                      verticalPadding:
                                                          height * 0.008,
                                                      horizontalPadding:
                                                          width * 0.004,
                                                      borderRadius:
                                                          width * 0.005,
                                                      border: null,
                                                      buttonColor: kDarkGray,
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        size: width * 0.015,
                                                        color: kWhite,
                                                      )),
                                                  SizedBox(
                                                      width: width * 0.005),
                                                  CustomContainer(
                                                      onTap: () {
                                                        setState(() {
                                                          questionIndex =
                                                              questionIndex == 1
                                                                  ? questions
                                                                      .length
                                                                  : questionIndex -
                                                                      1;
                                                        });
                                                      },
                                                      width: width * 0.022,
                                                      height: width * 0.022,
                                                      verticalPadding:
                                                          height * 0.008,
                                                      horizontalPadding:
                                                          width * 0.004,
                                                      borderRadius:
                                                          width * 0.005,
                                                      border: null,
                                                      buttonColor: kDarkGray,
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_up_rounded,
                                                        size: width * 0.015,
                                                        color: kWhite,
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: height * 0.01),
                                        SizedBox(
                                            height: height * 0.82,
                                            width: width * 0.14,
                                            child: ListView(
                                              children: [
                                                for (int i = 1;
                                                    i <= questions.length;
                                                    i++) ...[
                                                  CustomContainer(
                                                      onTap: () {
                                                        setState(() {
                                                          questionIndex = i;
                                                        });
                                                      },
                                                      height: height * 0.06,
                                                      verticalPadding:
                                                          height * 0.02,
                                                      horizontalPadding:
                                                          width * 0.02,
                                                      borderRadius:
                                                          width * 0.005,
                                                      border: null,
                                                      buttonColor:
                                                          questionIndex == i
                                                              ? kPurple
                                                              : kDarkGray,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('سؤال #$i',
                                                              style: textStyle(
                                                                  4,
                                                                  width,
                                                                  height,
                                                                  kWhite)),
                                                          questions[i-1]['choice']!=null &&questions[i-1]['question']['correct_answer']['id'] == questions[i-1]['choice']['id']
                                                              ? Icon(
                                                                  Icons
                                                                      .check_rounded,
                                                                  size: width *
                                                                      0.015,
                                                                  color: kGreen,
                                                                )
                                                              : Icon(
                                                                  Icons.close,
                                                                  size: width *
                                                                      0.015,
                                                                  color: kRed,
                                                                )
                                                        ],
                                                      )),
                                                  SizedBox(
                                                      height: height * 0.01),
                                                ]
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.9,
                                      child: CustomDivider(
                                        dashHeight: 2,
                                        dashWidth: width * 0.005,
                                        dashColor: kDarkGray.withOpacity(0.6),
                                        direction: Axis.vertical,
                                        fillRate: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.65,
                                      child: Column(
                                        children: [
                                          SizedBox(height: height * 0.08),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('سؤال #$questionIndex',
                                                  style: textStyle(3, width,
                                                      height, kWhite)),
                                              CustomContainer(
                                                onTap: () {},
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.02,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text(
                                                      'تمرن أكثر بحل أسئلة شبيهه لهذا السؤال',
                                                      style: textStyle(3, width,
                                                          height, kDarkBlack)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height * 0.01),
                                          CustomContainer(
                                            width: width * 0.65,
                                            buttonColor: kDarkGray,
                                            borderRadius: width * 0.005,
                                            verticalPadding: height * 0.03,
                                            horizontalPadding: width * 0.02,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: height * 0.03),
                                                  child: stringWithLatex(
                                                      questions[
                                                              questionIndex - 1]
                                                          ['question']['body'],
                                                      3,
                                                      width,
                                                      height,
                                                      kWhite),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        for (int i = 0;
                                                            i <
                                                                questions[questionIndex -
                                                                                1]
                                                                            [
                                                                            'question']
                                                                        [
                                                                        'choices']
                                                                    .length;
                                                            i++)
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        height *
                                                                            0.02),
                                                            child:
                                                                CustomContainer(
                                                                    onTap: null,
                                                                    verticalPadding:
                                                                        height *
                                                                            0.02,
                                                                    horizontalPadding:
                                                                        width *
                                                                            0.02,
                                                                    width: questions[questionIndex - 1]['question'][
                                                                                'image'] ==
                                                                            null
                                                                        ? width *
                                                                            0.61
                                                                        : width *
                                                                            0.3,
                                                                    borderRadius:
                                                                        width *
                                                                            0.005,
                                                                    border: fullBorder(questions[questionIndex - 1]['question']['choices'][i]['id'] ==
                                                                            questions[questionIndex - 1]['question']['correct_answer']['id']
                                                                        ? kGreen
                                                                        : questions[questionIndex - 1]['choice'] != null && questions[questionIndex - 1]['question']['choices'][i]['id'] == questions[questionIndex - 1]['choice']['id']
                                                                            ? kRed
                                                                            : kTransparent),
                                                                    buttonColor: questions[questionIndex - 1]['choice'] != null && questions[questionIndex - 1]['question']['choices'][i]['id'] == questions[questionIndex - 1]['choice']['id'] ? kLightPurple : kGray,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        stringWithLatex(
                                                                            questions[questionIndex -
                                                                                1]['question']['choices'][i]['body'],
                                                                            3,
                                                                            width,
                                                                            height,
                                                                            kWhite),
                                                                        questions[questionIndex - 1]['question']['choices'][i]['id'] ==
                                                                                questions[questionIndex - 1]['question']['correct_answer']['id']
                                                                            ? Icon(
                                                                                Icons.check_rounded,
                                                                                size: width * 0.015,
                                                                                color: kGreen,
                                                                              )
                                                                            : questions[questionIndex - 1]['choice']!=null &&questions[questionIndex - 1]['question']['choices'][i]['id'] == questions[questionIndex - 1]['choice']['id']
                                                                                ? Icon(
                                                                                    Icons.close,
                                                                                    size: width * 0.015,
                                                                                    color: kRed,
                                                                                  )
                                                                                : const SizedBox()
                                                                      ],
                                                                    )),
                                                          ),
                                                        if (questions[questionIndex -
                                                                        1]
                                                                    ['question']
                                                                ['choices']
                                                            .isEmpty)
                                                          CustomContainer(
                                                              onTap: null,
                                                              verticalPadding:
                                                                  height * 0.02,
                                                              horizontalPadding:
                                                                  width * 0.02,
                                                              width: questions[questionIndex -
                                                                              1]
                                                                          [
                                                                          'image'] ==
                                                                      null
                                                                  ? width * 0.61
                                                                  : width * 0.3,
                                                              borderRadius:
                                                                  width * 0.005,
                                                              border: null,
                                                              buttonColor:
                                                                  kGray,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  stringWithLatex(
                                                                      questions[questionIndex -
                                                                              1]
                                                                          [
                                                                          'answer'],
                                                                      3,
                                                                      width,
                                                                      height,
                                                                      kWhite),
                                                                  questions[questionIndex - 1]
                                                                              [
                                                                              'correct_answer'] ==
                                                                          questions[questionIndex - 1]
                                                                              [
                                                                              'answer']
                                                                      ? Icon(
                                                                          Icons
                                                                              .check_rounded,
                                                                          size: width *
                                                                              0.015,
                                                                          color:
                                                                              kGreen,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .close,
                                                                          size: width *
                                                                              0.015,
                                                                          color:
                                                                              kRed,
                                                                        )
                                                                ],
                                                              ))
                                                      ],
                                                    ),
                                                    if (questions[questionIndex -
                                                                1]['question']
                                                            ['image'] !=
                                                        null) ...[
                                                      SizedBox(
                                                        height: height * 0.25,
                                                        child: CustomDivider(
                                                          dashHeight: 2,
                                                          dashWidth:
                                                              width * 0.005,
                                                          dashColor: kGray
                                                              .withOpacity(0.9),
                                                          direction:
                                                              Axis.vertical,
                                                          fillRate: 0.7,
                                                        ),
                                                      ),
                                                      Image(
                                                        image: NetworkImage(
                                                            questions[questionIndex -
                                                                        1]
                                                                    ['question']
                                                                ['image']),
                                                        height: height * 0.25,
                                                        width: width * 0.25,
                                                        fit: BoxFit.contain,
                                                        alignment:
                                                            Alignment.center,
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.05),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              if (toDuration(questions[
                                                              questionIndex - 1]
                                                          ['duration'])
                                                      .inSeconds >
                                                  toDuration(questions[
                                                              questionIndex -
                                                                  1]['question']
                                                          ['idealDuration'])
                                                      .inSeconds) ...[
                                                Container(
                                                  width: width * 0.35,
                                                  height: height * 0.15,
                                                ),
                                                Positioned(
                                                  top: height * 0.075 +
                                                      height * 0.01,
                                                  child: CustomContainer(
                                                    width: width * 0.25,
                                                    height: height * 0.01,
                                                    buttonColor: kGreen,
                                                    borderRadius: width * 0.005,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: CustomContainer(
                                                        width: width *
                                                            0.25 *
                                                            max(
                                                                0.4,
                                                                (1 -
                                                                    (10 * toDuration(questions[questionIndex - 1]['question']['idealDuration']).inSeconds / toDuration(questions[questionIndex - 1]['duration']).inSeconds)
                                                                            .round() /
                                                                        10)),
                                                        height: height * 0.01,
                                                        buttonColor: kRed,
                                                        borderRadius:
                                                            width * 0.005,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Row(
                                                    children: [
                                                      CustomContainer(
                                                        width: width * 0.1,
                                                        height: height * 0.15,
                                                        borderRadius: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'الوقت المستهلك على\nالسؤال',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textStyle(
                                                                    5,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            Image(
                                                              image: const AssetImage(
                                                                  'images/clock_imoji.png'),
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  height * 0.03,
                                                              width:
                                                                  width * 0.03,
                                                            ),
                                                            CustomContainer(
                                                                width: width *
                                                                    0.05,
                                                                height: height *
                                                                    0.03,
                                                                buttonColor:
                                                                    kGray,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                child: Text(
                                                                    questions[questionIndex -
                                                                            1][
                                                                        'duration'],
                                                                    style: textStyle(
                                                                        4,
                                                                        width,
                                                                        height,
                                                                        kWhite)))
                                                          ],
                                                        ),
                                                      ),
                                                      CustomContainer(
                                                        width: width *
                                                                0.25 *
                                                                max(
                                                                    0.4,
                                                                    (1 -
                                                                        (10 * toDuration(questions[questionIndex - 1]['question']['idealDuration']).inSeconds / toDuration(questions[questionIndex - 1]['duration']).inSeconds).round() /
                                                                            10)) -
                                                            width * 0.1,
                                                        height: height * 0.01,
                                                      ),
                                                      CustomContainer(
                                                        width: width * 0.1,
                                                        height: height * 0.15,
                                                        borderRadius: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'الوقت المقترح للإنتهاء من\nالسؤال',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textStyle(
                                                                    5,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            Image(
                                                              image: const AssetImage(
                                                                  'images/clock_imoji.png'),
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  height * 0.03,
                                                              width:
                                                                  width * 0.03,
                                                            ),
                                                            CustomContainer(
                                                                width: width *
                                                                    0.05,
                                                                height: height *
                                                                    0.03,
                                                                buttonColor:
                                                                    kGray,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                child: Text(
                                                                    questions[questionIndex -
                                                                                1]
                                                                            [
                                                                            'question']
                                                                        [
                                                                        'idealDuration'],
                                                                    style: textStyle(
                                                                        4,
                                                                        width,
                                                                        height,
                                                                        kWhite)))
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ] else ...[
                                                Container(
                                                  width: width * 0.35,
                                                  height: height * 0.15,
                                                ),
                                                Positioned(
                                                  top: height * 0.075 +
                                                      height * 0.01,
                                                  child: CustomContainer(
                                                    width: width * 0.25,
                                                    height: height * 0.01,
                                                    buttonColor: kLightPurple,
                                                    borderRadius: width * 0.005,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: CustomContainer(
                                                        width: width *
                                                            0.25 *
                                                            max(
                                                                0.4,
                                                                (1 -
                                                                    (10 * toDuration(questions[questionIndex - 1]['duration']).inSeconds / toDuration(questions[questionIndex - 1]['question']['idealDuration']).inSeconds)
                                                                            .round() /
                                                                        10)),
                                                        height: height * 0.01,
                                                        buttonColor: kGreen,
                                                        borderRadius:
                                                            width * 0.005,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: Row(
                                                    children: [
                                                      CustomContainer(
                                                        width: width * 0.1,
                                                        height: height * 0.15,
                                                        borderRadius: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'الوقت المقترح للإنتهاء من\nالسؤال',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textStyle(
                                                                    5,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            Image(
                                                              image: const AssetImage(
                                                                  'images/clock_imoji.png'),
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  height * 0.03,
                                                              width:
                                                                  width * 0.03,
                                                            ),
                                                            CustomContainer(
                                                                width: width *
                                                                    0.05,
                                                                height: height *
                                                                    0.03,
                                                                buttonColor:
                                                                    kGray,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                child: Text(
                                                                    questions[questionIndex -
                                                                                1]
                                                                            [
                                                                            'question']
                                                                        [
                                                                        'idealDuration'],
                                                                    style: textStyle(
                                                                        4,
                                                                        width,
                                                                        height,
                                                                        kWhite)))
                                                          ],
                                                        ),
                                                      ),
                                                      CustomContainer(
                                                        width: width *
                                                                0.25 *
                                                                max(
                                                                    0.4,
                                                                    (1 -
                                                                        (10 * toDuration(questions[questionIndex - 1]['duration']).inSeconds / toDuration(questions[questionIndex - 1]['question']['idealDuration']).inSeconds).round() /
                                                                            10)) -
                                                            width * 0.1,
                                                        height: height * 0.01,
                                                      ),
                                                      CustomContainer(
                                                        width: width * 0.1,
                                                        height: height * 0.15,
                                                        borderRadius: 0,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'الوقت المستهلك على\nالسؤال',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: textStyle(
                                                                    5,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            Image(
                                                              image: const AssetImage(
                                                                  'images/clock_imoji.png'),
                                                              fit: BoxFit
                                                                  .contain,
                                                              height:
                                                                  height * 0.03,
                                                              width:
                                                                  width * 0.03,
                                                            ),
                                                            CustomContainer(
                                                                width: width *
                                                                    0.05,
                                                                height: height *
                                                                    0.03,
                                                                buttonColor:
                                                                    kGray,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                child: Text(
                                                                    questions[questionIndex -
                                                                            1][
                                                                        'duration'],
                                                                    style: textStyle(
                                                                        4,
                                                                        width,
                                                                        height,
                                                                        kWhite)))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                          SizedBox(height: height * 0.05),
                                          SizedBox(
                                            width: width * 0.65,
                                            child: CustomDivider(
                                              dashHeight: 2,
                                              dashWidth: width * 0.005,
                                              dashColor:
                                                  kDarkGray.withOpacity(0.6),
                                              direction: Axis.horizontal,
                                              fillRate: 1,
                                            ),
                                          ),
                                          SizedBox(height: height * 0.02),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('طريقة الحل',
                                                  style: textStyle(3, width,
                                                      height, kWhite)),
                                              SizedBox(width: width * 0.01),
                                              CustomContainer(
                                                onTap: () {
                                                  popUp(
                                                      context,
                                                      width * 0.65,
                                                      height * 0.38,
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'طريقة الحل #1',
                                                                  style: textStyle(
                                                                      2,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                              CustomContainer(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.close,
                                                                  size: width *
                                                                      0.02,
                                                                  color: kWhite,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height: height *
                                                                  0.02),
                                                          CustomContainer(
                                                            width: width * 0.65,
                                                            height:
                                                                height * 0.3,
                                                            verticalPadding:
                                                                height * 0.03,
                                                            horizontalPadding:
                                                                width * 0.02,
                                                            buttonColor:
                                                                kDarkGray,
                                                            borderRadius:
                                                                width * 0.005,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: stringWithLatex(
                                                                  'قريبا ستتوفر الحلول',
                                                                  3,
                                                                  width,
                                                                  height,
                                                                  kWhite),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      kTransparent,
                                                      kTransparent,
                                                      0);
                                                },
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.01,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text('طريقة #1',
                                                      style: textStyle(3, width,
                                                          height, kDarkBlack)),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.005),
                                              CustomContainer(
                                                onTap: () {},
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.01,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text('طريقة #2',
                                                      style: textStyle(3, width,
                                                          height, kDarkBlack)),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.005),
                                              CustomContainer(
                                                onTap: () {},
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.01,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text('طريقة #3',
                                                      style: textStyle(3, width,
                                                          height, kDarkBlack)),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.005),
                                              CustomContainer(
                                                onTap: () {},
                                                verticalPadding: height * 0.01,
                                                horizontalPadding: width * 0.01,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text('طريقة #4',
                                                      style: textStyle(3, width,
                                                          height, kDarkBlack)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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
                            height: height,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            buttonColor: kLightBlack.withOpacity(0.95),
                            border: singleLeftBorder(kDarkGray),
                            borderRadius: null,
                            child: ListView(
                              children: [
                                SizedBox(height: height * 0.08),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                              child: Text('يلا نساعدك بالدراسة',
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                                                style: textStyle(
                                                    3, width, height, kWhite)),
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
                )))
        : Scaffold(
            backgroundColor: kDarkGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}

// SizedBox(
// height: height * 0.94,
// width: width * 0.16,
// child: Theme(
// data: Theme.of(context).copyWith(
// scrollbarTheme: ScrollbarThemeData(
// minThumbLength: 1,
// mainAxisMargin: 55,
// crossAxisMargin: 2,
// thumbVisibility:
// MaterialStateProperty.all<
// bool>(true),
// trackVisibility:
// MaterialStateProperty.all<
// bool>(true),
// thumbColor: MaterialStateProperty
//     .all<Color>(Colors.green),
// trackColor: MaterialStateProperty
//     .all<Color>(Colors.yellow),
// trackBorderColor:
// MaterialStateProperty.all<
// Color>(Colors.red),
// ),
// ),
// child: Directionality(
// textDirection: TextDirection.ltr,
// child: ListView(
// children: [
// for (int j = 1; j <= 10; j++)
// for (int i = 1;
// i <= questions.length;
// i++) ...[
// CustomContainer(
// onTap: () {
// setState(() {
// questionIndex = i;
// });
// },
// width: 0.16,
// verticalPadding:
// height * 0.01,
// horizontalPadding:
// width * 0.01,
// borderRadius:
// width * 0.005,
// border: null,
// buttonColor:
// questionIndex == i
// ? kPurple
//     : kLightGray,
// child: Row(
// mainAxisAlignment:
// MainAxisAlignment
//     .spaceBetween,
// children: [
// Text('سؤال #$i',
// style: textStyle(
// 3,
// width,
// height,
// kWhite)),
// questions[i - 1][
// 'correct_answer'] ==
// questions[i -
// 1][
// 'answer']
// ? Icon(
// Icons
//     .check_rounded,
// size: width *
// 0.015,
// color:
// kGreen,
// )
//     : Icon(
// Icons.close,
// size: width *
// 0.015,
// color: kRed,
// )
// ],
// )),
// SizedBox(
// height: height * 0.01),
// ]
// ],
// ),
// ),
// )),
