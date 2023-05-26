import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../components/custom_container.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/review_provider.dart';

import '../components/custom_circular_chart.dart';
import '../components/custom_divider.dart';
import '../components/custom_text_field.dart';
import '../providers/history_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class QuizHistory extends StatefulWidget {

  const QuizHistory({Key? key}) : super(key: key);

  @override
  State<QuizHistory> createState() => _QuizHistoryState();
}

class _QuizHistoryState extends State<QuizHistory>
    with TickerProviderStateMixin {
  Set hoveredButton = {};
  TextEditingController search = TextEditingController();
  ScrollController controller = ScrollController();

  void getQuizzes() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('quiz_history/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.go('/Welcome')
          : {
              Provider.of<HistoryProvider>(context, listen: false)
                  .setQuizzes(result),
              Provider.of<WebsiteProvider>(context, listen: false)
                  .setLoaded(true)
            };
    });
  }

  void addQuizzes() async {
    if (!(Provider.of<HistoryProvider>(context, listen: false).quizzes.length /
                    2 -
                3 >
            (controller.positions.last.pixels /
                    (MediaQuery.of(context).size.height * 0.62))
                .floor()) &&
        Provider.of<HistoryProvider>(context, listen: false).waitQuizzes == 0) {
      Provider.of<HistoryProvider>(context, listen: false).setWaitQuizzes(1);
      String? key0 = await getSession('sessionKey0');
      String? key1 = await getSession('sessionKey1');
      String? value = await getSession('sessionValue');
      post('quiz_history/', {
        if (key0 != null) 'email': key0,
        if (key1 != null) 'phone': key1,
        'password': value,
        'quiz_index':
            Provider.of<HistoryProvider>(context, listen: false).quizzes.length,
      }).then((value) {
        dynamic result = decode(value);
        result == 0
            ? context.go('/Welcome')
            : {
                if (result == [])
                  {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .setWaitQuizzes(2),
                  }
                else
                  {
                    Provider.of<HistoryProvider>(context, listen: false)
                        .addQuizzes(result),
                    Provider.of<HistoryProvider>(context, listen: false)
                        .setWaitQuizzes(0),
                  }
              };
      });
    }
  }

  @override
  void initState() {
    getQuizzes();
    super.initState();

    controller.addListener(() {
      addQuizzes();
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

    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);
    return websiteProvider.loaded
        ? Scaffold(
            backgroundColor: kLightBlack,
            body: Directionality(
              textDirection: TextDirection.rtl,
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
                        children: [
                          SizedBox(width: width * 0.09),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: height * 0.01),
                              SizedBox(
                                width: width * 0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'سجل الامتحانات',
                                      style:
                                          textStyle(1, width, height, kWhite),
                                    ),
                                    SizedBox(width: width * 0.02),
                                    CustomContainer(
                                      onTap: () {},
                                      height: height * 0.05,
                                      width: width * 0.03,
                                      buttonColor: kDarkGray,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: Icon(
                                        Icons.swap_vert_rounded,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.005),
                                    CustomContainer(
                                      onTap: () {},
                                      height: height * 0.05,
                                      width: width * 0.03,
                                      buttonColor: kDarkGray,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: Icon(
                                        Icons.filter_alt_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    SizedBox(width: width * 0.02),
                                    CustomTextField(
                                        controller: search,
                                        width: width * 0.4,
                                        fontOption: 3,
                                        fontColor: kWhite,
                                        textAlign: null,
                                        obscure: false,
                                        readOnly: false,
                                        focusNode: null,
                                        maxLines: null,
                                        maxLength: null,
                                        keyboardType: null,
                                        onChanged: (text) {},
                                        onSubmitted: null,
                                        backgroundColor: kDarkGray,
                                        horizontalPadding: width * 0.002,
                                        verticalPadding: width * 0.002,
                                        isDense: true,
                                        errorText: null,
                                        hintText: 'ابحث في السجل...',
                                        hintTextColor: kWhite.withOpacity(0.5),
                                        suffixIcon: null,
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: width * 0.02,
                                          color: kWhite.withOpacity(0.5),
                                        ),
                                        border: outlineInputBorder(
                                            width * 0.005, kTransparent),
                                        focusedBorder: outlineInputBorder(
                                            width * 0.005, kTransparent)),
                                  ],
                                ),
                              ),
                              if (historyProvider.quizzes.isEmpty)
                                SizedBox(
                                  height: height * 0.8,
                                  width: width * 0.9,
                                  child: Center(
                                    child: Text(
                                      'لا يوجد أي امتحان سابق',
                                      style:
                                          textStyle(2, width, height, kWhite),
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: height * 0.8,
                                  width: width * 0.9,
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      scrollbarTheme: ScrollbarThemeData(
                                        minThumbLength: 1,
                                        mainAxisMargin: height * 0.02,
                                        crossAxisMargin: 0,
                                        radius: Radius.circular(width * 0.005),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                        trackVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                        thumbColor:
                                            MaterialStateProperty.all<Color>(
                                                kLightPurple),
                                        trackColor:
                                            MaterialStateProperty.all<Color>(
                                                kDarkGray),
                                        trackBorderColor:
                                            MaterialStateProperty.all<Color>(
                                                kTransparent),
                                      ),
                                    ),
                                    child: Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: ListView(
                                        controller: controller,
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  historyProvider
                                                      .quizzes.length;
                                              i += 2) ...[
                                            Directionality(
                                                textDirection:
                                                    TextDirection.rtl,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.02,
                                                      vertical: height * 0.01),
                                                  child: Row(
                                                    children: [
                                                      for (int j = 0;
                                                          j < 2 &&
                                                              j + i <
                                                                  historyProvider
                                                                      .quizzes
                                                                      .length;
                                                          j++) ...[
                                                        MouseRegion(
                                                          onHover: (isHover) {
                                                            setState(() {
                                                              hoveredButton
                                                                  .add(i + j);
                                                            });
                                                          },
                                                          onExit: (e) {
                                                            setState(() {
                                                              hoveredButton
                                                                  .remove(
                                                                      i + j);
                                                            });
                                                          },
                                                          child: Stack(
                                                            children: [
                                                              CustomContainer(
                                                                onTap: null,
                                                                width: width *
                                                                    0.42,
                                                                height: height *
                                                                    0.6,
                                                                buttonColor:
                                                                    kDarkGray,
                                                                border: null,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                verticalPadding:
                                                                    height *
                                                                        0.04,
                                                                horizontalPadding:
                                                                    width *
                                                                        0.02,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              historyProvider.quizzes[i + j]["subject"],
                                                                              style: textStyle(2, width, height, kWhite),
                                                                            ),
                                                                            const SizedBox(),
                                                                            const SizedBox(),
                                                                            const SizedBox(),
                                                                            const SizedBox(),
                                                                            const SizedBox(),
                                                                            const SizedBox(),
                                                                            Text(
                                                                              historyProvider.quizzes[i + j]["date"],
                                                                              textDirection: TextDirection.ltr,
                                                                              style: textStyle(4, width, height, kWhite),
                                                                            ),
                                                                            Icon(
                                                                              Icons.bookmark_border_rounded,
                                                                              size: width * 0.02,
                                                                              color: kWhite,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.02,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              height * 0.28,
                                                                          child:
                                                                              ListView(
                                                                            children: [
                                                                              Wrap(
                                                                                spacing: width * 0.004,
                                                                                runSpacing: height * 0.008,
                                                                                children: [
                                                                                  for (String skill in historyProvider.quizzes[i + j]["skills"])
                                                                                    CustomContainer(
                                                                                      onTap: null,
                                                                                      width: null,
                                                                                      height: height * 0.045,
                                                                                      buttonColor: kYellow,
                                                                                      border: null,
                                                                                      borderRadius: width * 0.005,
                                                                                      verticalPadding: height * 0.01,
                                                                                      horizontalPadding: width * 0.015,
                                                                                      child: Text(skill, style: textStyle(4, width, height, kWhite)),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      children: [
                                                                        CustomDivider(
                                                                          dashHeight:
                                                                              1,
                                                                          dashWidth:
                                                                              width * 0.004,
                                                                          dashColor:
                                                                              kGray,
                                                                          direction:
                                                                              Axis.horizontal,
                                                                          fillRate:
                                                                              0.6,
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                height * 0.02),
                                                                        Row(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'علامة الامتحان',
                                                                                  style: textStyle(3, width, height, kWhite),
                                                                                ),
                                                                                SizedBox(height: height * 0.01),
                                                                                CustomContainer(
                                                                                  onTap: null,
                                                                                  width: width * 0.19,
                                                                                  height: height * 0.1,
                                                                                  buttonColor: kGray,
                                                                                  border: null,
                                                                                  borderRadius: width * 0.005,
                                                                                  verticalPadding: height * 0.02,
                                                                                  horizontalPadding: width * 0.015,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      Text(
                                                                                        'حصلت على ${historyProvider.quizzes[i + j]["correct_question_num"]} من أصل ${historyProvider.quizzes[i + j]["question_num"]} علامات',
                                                                                        style: textStyle(4, width, height, kWhite),
                                                                                      ),
                                                                                      CircularChart(
                                                                                        width: width * 0.035,
                                                                                        label: historyProvider.quizzes[i + j]["correct_question_num"] / historyProvider.quizzes[i + j]["question_num"] * 100,
                                                                                        inActiveColor: kWhite,
                                                                                        labelColor: kWhite,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              width: width * 0.01,
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  'الوقت المستهلك',
                                                                                  style: textStyle(3, width, height, kWhite),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: height * 0.01,
                                                                                ),
                                                                                CustomContainer(
                                                                                  onTap: null,
                                                                                  width: width * 0.19,
                                                                                  height: height * 0.1,
                                                                                  buttonColor: kGray,
                                                                                  border: null,
                                                                                  borderRadius: width * 0.005,
                                                                                  verticalPadding: height * 0.02,
                                                                                  horizontalPadding: width * 0.015,
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: historyProvider.quizzes[i + j]["quiz_duration"] == null
                                                                                        ? [
                                                                                            Text(
                                                                                              'أنهيت الامتحان ب${Duration(seconds: historyProvider.quizzes[i + j]["attempt_duration"]).inMinutes} دقائق\nمن أصل ${Duration(seconds: historyProvider.quizzes[i + j]["ideal_duration"].toInt()).inMinutes} دقائق كوقت مثالي',
                                                                                              style: textStyle(4, width, height, kWhite),
                                                                                            ),
                                                                                            CircularChart(
                                                                                              width: width * 0.035,
                                                                                              label: historyProvider.quizzes[i + j]["attempt_duration"] / historyProvider.quizzes[i + j]["ideal_duration"] * 100,
                                                                                              inActiveColor: kWhite,
                                                                                              labelColor: kWhite,
                                                                                            ),
                                                                                          ]
                                                                                        : [
                                                                                            Text(
                                                                                              'أنهيت الامتحان ب${Duration(seconds: historyProvider.quizzes[i + j]["attempt_duration"]).inMinutes} دقائق\nمن أصل ${Duration(seconds: historyProvider.quizzes[i + j]["quiz_duration"]).inMinutes} دقائق',
                                                                                              style: textStyle(4, width, height, kWhite),
                                                                                            ),
                                                                                            CircularChart(
                                                                                              width: width * 0.035,
                                                                                              label: historyProvider.quizzes[i + j]["attempt_duration"] / historyProvider.quizzes[i + j]["quiz_duration"] * 100,
                                                                                              inActiveColor: kWhite,
                                                                                              labelColor: kWhite,
                                                                                            ),
                                                                                          ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: hoveredButton
                                                                    .contains(
                                                                        i + j),
                                                                child: ClipRect(
                                                                  child:
                                                                      BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            5,
                                                                        sigmaY:
                                                                            5),
                                                                    child:
                                                                        CustomContainer(
                                                                      onTap:
                                                                          () {
                                                                        websiteProvider
                                                                            .setLoaded(false);
                                                                        reviewProvider.setQuizID(historyProvider.quizzes[i +
                                                                                j]
                                                                            [
                                                                            'id']);
                                                                        context.go(
                                                                            '/QuizReview');
                                                                      },
                                                                      buttonColor:
                                                                          kDarkPurple
                                                                              .withOpacity(0.3),
                                                                      width: width *
                                                                          0.42,
                                                                      height:
                                                                          height *
                                                                              0.6,
                                                                      border:
                                                                          null,
                                                                      borderRadius:
                                                                          width *
                                                                              0.005,
                                                                      child:
                                                                          Text(
                                                                        'المزيد من التفاصيل',
                                                                        style: textStyle(
                                                                            2,
                                                                            width,
                                                                            height,
                                                                            kWhite),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (j % 2 == 0)
                                                          SizedBox(
                                                            width: width * 0.01,
                                                          )
                                                      ]
                                                    ],
                                                  ),
                                                )),
                                          ],
                                          Visibility(
                                            visible:
                                                historyProvider.waitQuizzes ==
                                                    1,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: height * 0.02),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: kPurple,
                                                          strokeWidth:
                                                              width * 0.01)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
                                      websiteProvider.setLoaded(false);
                                      context.go('/Dashboard');
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
                                          const SizedBox(),
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
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.01,
                                        vertical: height * 0.01),
                                    child: CustomContainer(
                                      onTap: null,
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
                                            const SizedBox(),
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
                                            const SizedBox(),
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
                                      onTap: null,
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
                                            const SizedBox(),
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
                                            const SizedBox(),
                                        ],
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  child: CustomContainer(
                                    onTap: () {
                                      websiteProvider.setLoaded(false);
                                      context.go('/QuizSetting');
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
                                          const SizedBox(),
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
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  child: CustomContainer(
                                    onTap: null,
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
                                          const SizedBox(),
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
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  child: CustomContainer(
                                    onTap: null,
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
                                          const SizedBox(),
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
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  child: CustomContainer(
                                    onTap: null,
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
                                          const SizedBox(),
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
                                          const SizedBox(),
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
                                    onTap: null,
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
                                          const SizedBox(),
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
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.01,
                                      vertical: height * 0.01),
                                  child: CustomContainer(
                                    onTap: null,
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
                                          const SizedBox(),
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
                                          const SizedBox(),
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
              ),
            ),
          )
        : Scaffold(
            backgroundColor: kDarkGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
