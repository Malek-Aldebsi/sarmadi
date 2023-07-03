import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import '../components/custom_container.dart';
import '../components/right_bar.dart';
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

  void getQuizzes(
      HistoryProvider historyProvider, WebsiteProvider websiteProvider) async {
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
          ? context.pushReplacement('/Welcome')
          : {
              historyProvider.setQuizzes(result),
              websiteProvider.setLoaded(true)
            };
    });
  }

  void addQuizzes(
      HistoryProvider historyProvider, WebsiteProvider websiteProvider) async {
    if (!(historyProvider.quizzes.length / 2 - 3 >
            (controller.positions.last.pixels /
                    (MediaQuery.of(context).size.height * 0.62))
                .floor()) &&
        historyProvider.waitQuizzes == 0) {
      historyProvider.setWaitQuizzes(1);
      String? key0 = await getSession('sessionKey0');
      String? key1 = await getSession('sessionKey1');
      String? value = await getSession('sessionValue');
      post('quiz_history/', {
        if (key0 != null) 'email': key0,
        if (key1 != null) 'phone': key1,
        'password': value,
        'quiz_index': historyProvider.quizzes.length,
      }).then((value) {
        dynamic result = decode(value);
        result == 0
            ? context.pushReplacement('/Welcome')
            : {
                if (result == [])
                  {
                    historyProvider.setWaitQuizzes(2),
                  }
                else
                  {
                    historyProvider.addQuizzes(result),
                    if (result.length < 10)
                      historyProvider.setWaitQuizzes(2)
                    else
                      historyProvider.setWaitQuizzes(0),
                  }
              };
      });
    }
  }

  @override
  void initState() {
    getQuizzes(Provider.of<HistoryProvider>(context, listen: false),
        Provider.of<WebsiteProvider>(context, listen: false));
    super.initState();

    controller.addListener(() {
      addQuizzes(Provider.of<HistoryProvider>(context, listen: false),
          Provider.of<WebsiteProvider>(context, listen: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);
    return width < height
        ? const RotateYourPhone()
        : websiteProvider.loaded
            ? Scaffold(
                backgroundColor: kLightBlack,
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      const RightBar(),
                      SizedBox(width: width * 0.04),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          const SizedBox(),
                          SizedBox(
                            width: width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'سجل الامتحانات',
                                  style: textStyle(1, width, height, kWhite),
                                ),
                                SizedBox(width: width * 0.02),
                                CustomContainer(
                                  onTap: () {},
                                  height: width * 0.03,
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
                                  height: width * 0.03,
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
                                SizedBox(
                                  height: width * 0.03,
                                  child: CustomTextField(
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
                                      horizontalPadding: 0,
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(),
                          if (historyProvider.quizzes.isEmpty)
                            SizedBox(
                              height: height * 0.8,
                              width: width * 0.9,
                              child: Center(
                                child: Text(
                                  'لا يوجد أي امتحان سابق',
                                  style: textStyle(2, width, height, kWhite),
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: height * 0.85,
                              width: width * 0.9,
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    minThumbLength: 1,
                                    mainAxisMargin: height * 0.02,
                                    crossAxisMargin: 0,
                                    radius: Radius.circular(width * 0.005),
                                    thumbVisibility:
                                        MaterialStateProperty.all<bool>(true),
                                    trackVisibility:
                                        MaterialStateProperty.all<bool>(true),
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
                                          i < historyProvider.quizzes.length;
                                          i += 2) ...[
                                        Directionality(
                                            textDirection: TextDirection.rtl,
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
                                                              .remove(i + j);
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          CustomContainer(
                                                            onTap: null,
                                                            width: width * 0.42,
                                                            height: height *
                                                                0.64, // TODO:
                                                            buttonColor:
                                                                kDarkGray,
                                                            border: null,
                                                            borderRadius:
                                                                width * 0.005,
                                                            verticalPadding:
                                                                height * 0.04,
                                                            horizontalPadding:
                                                                width * 0.02,
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
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          historyProvider.quizzes[i + j]
                                                                              [
                                                                              "subject"],
                                                                          style: textStyle(
                                                                              2,
                                                                              width,
                                                                              height,
                                                                              kWhite),
                                                                        ),
                                                                        const SizedBox(),
                                                                        const SizedBox(),
                                                                        const SizedBox(),
                                                                        const SizedBox(),
                                                                        const SizedBox(),
                                                                        const SizedBox(),
                                                                        Text(
                                                                          historyProvider.quizzes[i + j]
                                                                              [
                                                                              "date"],
                                                                          textDirection:
                                                                              TextDirection.ltr,
                                                                          style: textStyle(
                                                                              4,
                                                                              width,
                                                                              height,
                                                                              kWhite),
                                                                        ),
                                                                        Icon(
                                                                          Icons
                                                                              .bookmark_border_rounded,
                                                                          size: width *
                                                                              0.02,
                                                                          color:
                                                                              kWhite,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          height *
                                                                              0.02,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          height *
                                                                              0.28,
                                                                      child:
                                                                          Wrap(
                                                                        clipBehavior:
                                                                            Clip.hardEdge,
                                                                        spacing:
                                                                            width *
                                                                                0.004,
                                                                        runSpacing:
                                                                            height *
                                                                                0.008,
                                                                        children: [
                                                                          for (String skill
                                                                              in historyProvider.quizzes[i + j]["skills"])
                                                                            CustomContainer(
                                                                              onTap: null,
                                                                              width: null,
                                                                              height: height * 0.05,
                                                                              buttonColor: kYellow,
                                                                              border: null,
                                                                              borderRadius: width * 0.005,
                                                                              verticalPadding: 0,
                                                                              horizontalPadding: width * 0.01,
                                                                              child: Text(skill, style: textStyle(4, width, height, kWhite)),
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
                                                                          width *
                                                                              0.004,
                                                                      dashColor:
                                                                          kGray,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      fillRate:
                                                                          0.6,
                                                                    ),
                                                                    SizedBox(
                                                                        height: height *
                                                                            0.02),
                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'علامة الامتحان',
                                                                              style: textStyle(3, width, height, kWhite),
                                                                            ),
                                                                            SizedBox(height: height * 0.01),
                                                                            CustomContainer(
                                                                              onTap: null,
                                                                              width: width * 0.19,
                                                                              height: height * 0.12,
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
                                                                          width:
                                                                              width * 0.01,
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
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
                                                                              height: height * 0.12,
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
                                                                                          label: double.parse((100 * Duration(seconds: historyProvider.quizzes[i + j]["attempt_duration"]).inMinutes / Duration(seconds: historyProvider.quizzes[i + j]["ideal_duration"].toInt()).inMinutes).toStringAsFixed(1)),
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
                                                                                          label: double.parse((100 * Duration(seconds: historyProvider.quizzes[i + j]["attempt_duration"]).inMinutes / Duration(seconds: historyProvider.quizzes[i + j]["quiz_duration"].toInt()).inMinutes).toStringAsFixed(1)),
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
                                                            visible:
                                                                hoveredButton
                                                                    .contains(
                                                                        i + j),
                                                            child: ClipRect(
                                                              child:
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            5,
                                                                        sigmaY:
                                                                            5),
                                                                child:
                                                                    CustomContainer(
                                                                  onTap: () {
                                                                    websiteProvider
                                                                        .setLoaded(
                                                                            false);
                                                                    reviewProvider.setQuizID(
                                                                        historyProvider.quizzes[i +
                                                                                j]
                                                                            [
                                                                            'id']);
                                                                    context.pushReplacement(
                                                                        '/QuizReview');
                                                                  },
                                                                  buttonColor:
                                                                      kDarkPurple
                                                                          .withOpacity(
                                                                              0.3),
                                                                  width: width *
                                                                      0.42,
                                                                  height:
                                                                      height *
                                                                          0.64,
                                                                  border: null,
                                                                  borderRadius:
                                                                      width *
                                                                          0.005,
                                                                  child: Text(
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
                                        visible: historyProvider.waitQuizzes ==
                                                1 &&
                                            historyProvider.waitQuizzes != 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.02),
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  color: kPurple,
                                                  strokeWidth: width * 0.01)),
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
                ),
              )
            : Scaffold(
                backgroundColor: kDarkGray,
                body: Center(
                    child: CircularProgressIndicator(
                        color: kPurple, strokeWidth: width * 0.05)));
  }
}
