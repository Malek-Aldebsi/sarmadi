import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/borders.dart';
import '../screens/question.dart';
import '../components/custom_divider.dart';
import '../components/string_with_latex.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/question_provider.dart';
// import '../providers/quiz_provider.dart';
import '../providers/review_provider.dart';
import '../providers/website_provider.dart';
import 'dashboard.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class QuizReview extends StatefulWidget {
  static const String route = '/QuizReview/';
  const QuizReview({Key? key}) : super(key: key);

  @override
  State<QuizReview> createState() => _QuizReviewState();
}

class _QuizReviewState extends State<QuizReview> with TickerProviderStateMixin {

  ScrollController mainScrollController = ScrollController();
  ScrollController questionsScrollController = ScrollController();

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
          :{
              Provider.of<ReviewProvider>(context, listen: false).setQuizSubject(result['quiz_subject']),
              Provider.of<ReviewProvider>(context, listen: false).setQuizTime(result['quiz_duration']),
              Provider.of<ReviewProvider>(context, listen: false).setQuestions(result['answers']),
              Provider.of<ReviewProvider>(context, listen: false).setCorrectQuestionsNum(result['correct_questions_num']),
              Provider.of<ReviewProvider>(context, listen: false).setSkills(result['best_worst_skills']),
              Provider.of<ReviewProvider>(context, listen: false).setQuestionIndex(1),
              Provider.of<WebsiteProvider>(context, listen: false).setLoaded(true),
            };
    });
  }

  @override
  void initState() {
    getResult();
    mainScrollController.addListener(() {

      if (mainScrollController.positions.last.pixels+2>MediaQuery.of(context).size.height&&!Provider.of<
          ReviewProvider>(
          context,
          listen: false)
          .questionScrollState){
        Provider.of<
            ReviewProvider>(
            context,
            listen: false)
      .setQuestionScrollState(true);
      }else if (mainScrollController.positions.last.pixels<MediaQuery.of(context).size.height&&Provider.of<
          ReviewProvider>(
          context,
          listen: false)
          .questionScrollState){
        Provider.of<
            ReviewProvider>(
            context,
            listen: false)
            .setQuestionScrollState(false);
      }
    });

    questionsScrollController.addListener(() {
      if ((questionsScrollController.positions.last.pixels/MediaQuery.of(context).size.height).round()+1!= Provider.of<
          ReviewProvider>(
          context,
          listen: false)
          .questionIndex) {
        Provider.of<
          ReviewProvider>(
          context,
          listen: false)
          .setQuestionIndex((questionsScrollController.positions.last.pixels/MediaQuery.of(context).size.height).round()+1);
      }
      });
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

  AnimationController? forwardAnimationController;
  CurvedAnimation? forwardAnimationCurve;
  dynamic forwardAnimationValue = 1;

  AnimationController? backwardAnimationController;
  CurvedAnimation? backwardAnimationCurve;
  dynamic backwardAnimationValue = 0;

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
  double fontWidth(fontOption, width, height){
    final textPainter = TextPainter(
      text: TextSpan(
          text: 'مهارة', style: textStyle(fontOption, width, height, kWhite)),
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    return textPainter.computeLineMetrics()[0].width/5;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Provider.of<WebsiteProvider>(context, listen: true).loaded
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
                              controller: mainScrollController,
                              children: [
                                SizedBox(height: height * 0.1),
                                SizedBox(
                                  width: width * 0.93,
                                  height: height * 0.4,
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
                                            Text(Provider.of<ReviewProvider>(context, listen: true).quizSubject
                                              ,style: textStyle(
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
                                                                'جاوبت على ${Provider.of<ReviewProvider>(context, listen: true).correctQuestionsNum} أسئلة من أصل ${Provider.of<ReviewProvider>(context, listen: true).questions.length}',
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            CircularChart(
                                                              width:
                                                                  width * 0.035,
                                                              label: double.parse((100 *
                                                                  Provider.of<ReviewProvider>(context, listen: true).correctQuestionsNum /
                                                                  Provider.of<ReviewProvider>(context, listen: true).questions.length)
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
                                                                'أنهيت الامتحان ب${Duration(seconds: Provider.of<ReviewProvider>(context, listen: true).questions.fold(0, (prev, curr) => prev + toDuration(curr['duration']).inSeconds)).inMinutes} دقائق\nمن أصل ${toDuration(Provider.of<ReviewProvider>(context, listen: true).quizTime==null?'00:00:00': Provider.of<ReviewProvider>(context, listen: true).quizTime).inMinutes}',
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            CircularChart(
                                                              width:
                                                                  width * 0.035,
                                                              label: double.parse((100 *
                                                                  Provider.of<ReviewProvider>(context, listen: true).questions.fold(0, (prev, curr) => prev + toDuration(curr['duration']).inSeconds) /
                                                                  toDuration(Provider.of<ReviewProvider>(context, listen: true).quizTime==null?'00:00:00': Provider.of<ReviewProvider>(context, listen: true).quizTime).inSeconds)
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
                                                  mainScrollController.animateTo(
                                                    mainScrollController.position
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
                                                  Text(
                                                      'معدل التحصيل لكل مهارات الامتحان',
                                                      style: textStyle(
                                                          3,
                                                          width,
                                                          height,
                                                          kLightPurple)),
                                                  SizedBox(
                                                      height: height * 0.02),
                                                  SizedBox(
                                                    height:height*0.3,
                                                    child: ListView(
                                                      children: [
                                                        Wrap(

                                                          spacing: width * 0.005,
                                                          runSpacing: height * 0.01,
                                                          children: [
                                                            for(MapEntry skill in Provider.of<ReviewProvider>(context, listen: true).skills.entries)
                                                                Stack(
                                                                  alignment: Alignment
                                                                      .center,
                                                                  children: [
                                                                    CustomContainer(
                                                                      onTap: null,
                                                                      width: width *
                                                                              0.055 +
                                                                          (skill.key.length *
                                                                              fontWidth(5, width, height)),
                                                                      height:height*0.05,
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
                                                                              width: (width *
                                                                                      0.055 + (skill.key.length *
                                                                                      fontWidth(5, width, height)))*skill.value['correct']/skill.value['all'],
                                                                              height:height*0.05,
                                                                              borderRadius:
                                                                                  width *
                                                                                      0.005,
                                                                              border:
                                                                                  null,
                                                                              buttonColor: kOrange
                                                                              ,
                                                                              child: null),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    CustomContainer(
                                                                      onTap: null,
                                                                      width: width *
                                                                              0.055 +
                                                                          (skill.key.length *
                                                                              fontWidth(5, width, height)),
                                                                      verticalPadding:
                                                                          height *
                                                                              0.02,
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
                                                                        skill.key,
                                                                            style: textStyle(
                                                                                5,
                                                                                width,
                                                                                height,
                                                                                kWhite),
                                                                          ),
                                                                          Text(
                                                                            "${(100*skill.value['correct']/skill.value['all']).round()}%",
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
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                            SizedBox(),
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
                                SizedBox(height: height * 0.05),
                                SizedBox(
                                  height:height,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: height * 0.03),

                                          Text('سجل الأسئلة',
                                              style: textStyle(
                                                  2, width, height, kWhite)),
                                          SizedBox(height: height * 0.01),

                                          SizedBox(
                                            width: width * 0.16,
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
                                                            Provider.of<ReviewProvider>(context, listen: false).questionIndex==
                                                                Provider.of<ReviewProvider>(context, listen: false).questions
                                                                    .length?
                                                            {
                                                              Provider.of<
                                                                  ReviewProvider>(
                                                                  context,
                                                                  listen: false)
                                                                  .setQuestionIndex(
                                                                  1),
                                                            questionsScrollController.jumpTo(
                                                              0,
                                                            )
                                                            }:
                                                            {
                                                              questionsScrollController.animateTo(
                                                                Provider.of<
                                                                    ReviewProvider>(
                                                                    context,
                                                                    listen: false)
                                                                    .questionIndex*height,
                                                                duration: const Duration(
                                                                    milliseconds: 500),
                                                                curve: Curves.easeOut,
                                                              ),
                                                              Provider.of<
                                                                  ReviewProvider>(
                                                                  context,
                                                                  listen: false)
                                                                  .setQuestionIndex(
                                                                  Provider
                                                                      .of<
                                                                      ReviewProvider>(
                                                                      context,
                                                                      listen: false)
                                                                      .questionIndex +
                                                                      1),
                                                            };
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
                                                          Provider.of<ReviewProvider>(context, listen: false).questionIndex==1?
                                                          {

                                                            Provider.of<
                                                                ReviewProvider>(
                                                                context,
                                                                listen: false)
                                                                .setQuestionIndex(
                                                                Provider
                                                                    .of<
                                                                    ReviewProvider>(
                                                                    context,
                                                                    listen: false)
                                                                    .questions
                                                                    .length),
                                                            questionsScrollController.jumpTo(
                                                              (Provider.of<
                                                                  ReviewProvider>(
                                                                  context,
                                                                  listen: false)
                                                                  .questionIndex-1)*height,
                                                            ),
                                                          }:
                                                          {
                                                            Provider.of<
                                                                ReviewProvider>(
                                                                context,
                                                                listen: false)
                                                                .setQuestionIndex(
                                                                Provider
                                                                    .of<
                                                                    ReviewProvider>(
                                                                    context,
                                                                    listen: false)
                                                                    .questionIndex -
                                                                    1),
                                                            questionsScrollController.animateTo(
                                                              (Provider.of<
                                                                  ReviewProvider>(
                                                                  context,
                                                                  listen: false)
                                                                  .questionIndex-1)*height,
                                                              duration: const Duration(
                                                                  milliseconds: 500),
                                                              curve: Curves.easeOut,
                                                            ),
                                                          };

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
                                              height:height*0.82,
                                              width: width * 0.18,
                                              child: Theme(
                                                  data: Theme.of(context).copyWith(
                                                    scrollbarTheme: ScrollbarThemeData(
                                                      minThumbLength: 1,
                                                      mainAxisMargin: 0,
                                                      crossAxisMargin: 0,
                                                      radius:
                                                      Radius.circular(width * 0.005),
                                                      thumbVisibility:
                                                      MaterialStateProperty.all<bool>(
                                                          true),
                                                      trackVisibility:
                                                      MaterialStateProperty.all<bool>(
                                                          true),
                                                      thumbColor: MaterialStateProperty
                                                          .all<Color>(kLightPurple),
                                                      trackColor: MaterialStateProperty
                                                          .all<Color>(kDarkGray),
                                                      trackBorderColor:
                                                      MaterialStateProperty.all<
                                                          Color>(kTransparent),
                                                    ),
                                                  ),
                                                  child: Directionality(
                                                    textDirection: TextDirection.ltr,
                                                child: ListView(
                                                  children: [
                                                    for (int i = 1;
                                                        i <= Provider.of<ReviewProvider>(context, listen: true).questions.length;
                                                        i++) ...[
                                                      Directionality(
                                                        textDirection:
                                                        TextDirection.rtl,
                                                        child: Padding(
                                                          padding:  EdgeInsets.symmetric(horizontal:width*0.02),
                                                          child: CustomContainer(
                                                              onTap: () {
                                                                Provider.of<ReviewProvider>(context, listen: false).setQuestionIndex(i);
                                                                questionsScrollController.jumpTo(
                                                                  (Provider.of<
                                                                      ReviewProvider>(
                                                                      context,
                                                                      listen: false)
                                                                      .questionIndex-1)*height,

                                                                );
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
                                                              Provider.of<ReviewProvider>(context, listen: true).questionIndex == i
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
                                                                  Provider.of<ReviewProvider>(context, listen: true).questions[i-1]['choice']!=null &&Provider.of<ReviewProvider>(context, listen: true).questions[i-1]['question']['correct_answer']['id'] == Provider.of<ReviewProvider>(context, listen: true).questions[i-1]['choice']['id']
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
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: height * 0.01),
                                                    ]
                                                  ],
                                                ),
                                              )),),
                                          SizedBox(height: height * 0.02),

                                        ],
                                      ),
                                      SizedBox(
                                        height: height,
                                        child: CustomDivider(
                                          dashHeight: 2,
                                          dashWidth: width * 0.005,
                                          dashColor: kDarkGray.withOpacity(0.6),
                                          direction: Axis.vertical,
                                          fillRate: 1,
                                        ),
                                      ),
                                      SizedBox(
                                        height:height,
                                        width: width * 0.7,
                                        child: Theme(
                                            data: Theme.of(context).copyWith(
                                              scrollbarTheme: ScrollbarThemeData(
                                                minThumbLength: 1,
                                                mainAxisMargin: height*0.02,
                                                crossAxisMargin: 0,
                                                radius:
                                                Radius.circular(width * 0.005),
                                                thumbVisibility:
                                                MaterialStateProperty.all<bool>(
                                                    true),
                                                trackVisibility:
                                                MaterialStateProperty.all<bool>(
                                                    true),
                                                thumbColor: MaterialStateProperty
                                                    .all<Color>(kLightPurple),
                                                trackColor: MaterialStateProperty
                                                    .all<Color>(kDarkGray),
                                                trackBorderColor:
                                                MaterialStateProperty.all<
                                                    Color>(kTransparent),
                                              ),
                                            ),
                                            child: Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: ListView(
                                                physics:Provider.of<
                                                    ReviewProvider>(
                                                    context,
                                                    listen: true)
                                                    .questionScrollState?ScrollPhysics():NeverScrollableScrollPhysics(),
                                                  controller:questionsScrollController,
                                                children: [
                                                  for (int questionIndex = 1;
                                                  questionIndex <= Provider.of<ReviewProvider>(context, listen: true).questions.length;
                                                  questionIndex++) ...[
                                                    Directionality(
                                                      textDirection:
                                                      TextDirection.rtl,
                                                      child: Padding(
                                                        padding:  EdgeInsets.symmetric(horizontal:width*0.02),
                                                        child: SizedBox(
                                                          width: width * 0.66,
                                                          height:height,
                                                          child: Column(
                                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              SizedBox(),SizedBox(),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text('سؤال #$questionIndex',
                                                                      style: textStyle(3, width,
                                                                          height, kWhite)),
                                                                  CustomContainer(
                                                                    onTap: () {
                                                                      Provider.of<QuestionProvider>(context, listen: false).setQuestionId(Provider.of<ReviewProvider>(context, listen: false).questions[
                                                                      questionIndex-1]
                                                                      ['question']['id']);
                                                                      Provider.of<WebsiteProvider>(context, listen: false).setLoaded(false);

                                                                      Navigator.pushNamed(
                                                                          context, Question.route);
                                                                    },
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
                                                              SizedBox(),
                                                              CustomContainer(
                                                                width: width * 0.66,
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
                                                                      child: SizedBox(
                                                                        width: width * 0.61,
                                                                        child: stringWithLatex(
                                                                            Provider.of<ReviewProvider>(context, listen: true).questions[
                                                                            questionIndex-1]
                                                                            ['question']['body'],
                                                                            // width * 0.61,
                                                                            3,
                                                                            width,
                                                                            height,
                                                                            kWhite),
                                                                      ),
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
                                                                                Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                                                    width: Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question'][
                                                                                    'image'] ==
                                                                                        null
                                                                                        ? width *
                                                                                        0.61
                                                                                        : width *
                                                                                        0.3,
                                                                                    borderRadius:
                                                                                    width *
                                                                                        0.005,
                                                                                    border: fullBorder(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['id'] ==
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['correct_answer']['id']
                                                                                        ? kGreen
                                                                                        : Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice'] != null && Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['id'] == Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice']['id']
                                                                                        ? kRed
                                                                                        : kTransparent),
                                                                                    buttonColor: Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice'] != null && Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['id'] == Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice']['id'] ? kLightPurple : kGray,
                                                                                    child: Row(
                                                                                      mainAxisAlignment:
                                                                                      MainAxisAlignment
                                                                                          .spaceBetween,
                                                                                      children: [
                                                                                        SizedBox(width:
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question'][
                                                                                        'image'] ==
                                                                                            null
                                                                                            ? width *
                                                                                            0.53
                                                                                            : width *
                                                                                            0.22,
                                                                                          child: stringWithLatex(
                                                                                              Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['body'],

                                                                                              3,
                                                                                              width,
                                                                                              height,
                                                                                              kWhite),
                                                                                        ),
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['id'] ==
                                                                                            Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['correct_answer']['id']
                                                                                            ? Icon(
                                                                                          Icons.check_rounded,
                                                                                          size: width * 0.015,
                                                                                          color: kGreen,
                                                                                        )
                                                                                            : Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice']!=null &&Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['choices'][i]['id'] == Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['choice']['id']
                                                                                            ? Icon(
                                                                                          Icons.close,
                                                                                          size: width * 0.015,
                                                                                          color: kRed,
                                                                                        )
                                                                                            : const SizedBox()
                                                                                      ],
                                                                                    )),
                                                                              ),
                                                                            if (Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
                                                                            ['question']
                                                                            ['choices']
                                                                                .isEmpty)
                                                                              CustomContainer(
                                                                                  onTap: null,
                                                                                  verticalPadding:
                                                                                  height * 0.02,
                                                                                  horizontalPadding:
                                                                                  width * 0.02,
                                                                                  width: Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                                                      SizedBox(
                                                                                        width: Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
                                                                                        [
                                                                                        'image'] ==
                                                                                            null
                                                                                            ? width * 0.53
                                                                                            : width * 0.22,
                                                                                        child: stringWithLatex(
                                                                                            Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
                                                                                            [
                                                                                            'answer'],
                                                                                            3,
                                                                                            width,
                                                                                            height,
                                                                                            kWhite),
                                                                                      ),
                                                                                      Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
                                                                                      [
                                                                                      'correct_answer'] ==
                                                                                          Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                                        if (Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']
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
                                                                                Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                              SizedBox(),
                                                              Stack(
                                                                alignment: Alignment.center,
                                                                children: [
                                                                  if (toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[
                                                                  questionIndex-1]
                                                                  ['duration'])
                                                                      .inSeconds >
                                                                      toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[
                                                                      questionIndex-1]['question']
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
                                                                                        (10 * toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['idealDuration']).inSeconds / toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['duration']).inSeconds)
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
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1][
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
                                                                                        (10 * toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['idealDuration']).inSeconds / toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['duration']).inSeconds).round() /
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
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                                  ]
                                                                  else ...[
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
                                                                                        (10 * toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['duration']).inSeconds / toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['idealDuration']).inSeconds)
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
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]
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
                                                                                        (10 * toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['duration']).inSeconds / toDuration(Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1]['question']['idealDuration']).inSeconds).round() /
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
                                                                                        Provider.of<ReviewProvider>(context, listen: true).questions[questionIndex-1][
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
                                                              SizedBox(),
                                                              SizedBox(
                                                                width: width * 0.66,
                                                                child: CustomDivider(
                                                                  dashHeight: 2,
                                                                  dashWidth: width * 0.005,
                                                                  dashColor:
                                                                  kDarkGray.withOpacity(0.6),
                                                                  direction: Axis.horizontal,
                                                                  fillRate: 1,
                                                                ),
                                                              ),
                                                              SizedBox(),
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
                                                                                      // width * 0.65,
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
                                                                ],
                                                              ),
                                                              SizedBox(),SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                  ]
                                                ],
                                              ),
                                            )),),
                                      
                                      const SizedBox()
                                    ],
                                  ),
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
                                      Provider.of<WebsiteProvider>(context, listen: false).setLoaded(false);

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
                                      Provider.of<WebsiteProvider>(context,
                                          listen: false)
                                          .setLoaded(false);
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
