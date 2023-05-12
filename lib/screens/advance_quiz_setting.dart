import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import '../providers/quiz_setting_provider.dart';
import '../providers/website_provider.dart';
import 'quiz.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_slider.dart';
import '../components/custom_text_field.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'dashboard.dart';

class AdvanceQuizSetting extends StatefulWidget {
  static const String route = '/AdvanceQuizSetting/';

  const AdvanceQuizSetting({super.key});

  @override
  State<AdvanceQuizSetting> createState() => _AdvanceQuizSettingState();
}

class _AdvanceQuizSettingState extends State<AdvanceQuizSetting>
    with TickerProviderStateMixin {
  TextEditingController hours = TextEditingController(text: '00');
  TextEditingController minutes = TextEditingController(text: '05');

  void getHeadlines() async {
    if (Provider.of<QuizProvider>(context, listen: false).subjectID != '') {
      String? key0 = await getSession('sessionKey0');
      String? key1 = await getSession('sessionKey1');
      String? value = await getSession('sessionValue');
      post('headline_set/', {
        if (key0 != null) 'email': key0,
        if (key1 != null) 'phone': key1,
        'password': value,
        'subject_id':
            Provider.of<QuizProvider>(context, listen: false).subjectID,
      }).then((value) {
        dynamic result = decode(value);
        result == 0
            ? Navigator.pushNamed(context, Welcome.route)
            : {
                Provider.of<QuizSettingProvider>(context, listen: false)
                    .setModuleSet(result['modules']),
                Provider.of<QuizSettingProvider>(context, listen: false)
                    .setHeadlineSet(result['headlines']),
                Provider.of<WebsiteProvider>(context, listen: false)
                    .setLoaded(true)
              };
      });
    } else {
      Navigator.pushNamed(context, QuizSetting.route);
    }
  }

  @override
  void initState() {
    getHeadlines();
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

  bool moduleStatus(Map module) {
    bool status = true;
    for (Map lesson in module['lessons']) {
      status = status &&
          Provider.of<QuizProvider>(context, listen: false)
              .selectedHeadlines
              .containsAll(lesson['h1s']);
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    QuizSettingProvider quizSettingProvider =
        Provider.of<QuizSettingProvider>(context);
    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    return websiteProvider.loaded
        ? Scaffold(
            body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/single_question_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: width * 0.05),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height / 25),
                              child: Text(quizProvider.subjectName,
                                  style: textStyle(1, width, height, kWhite)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الفصل الأول',
                                      style:
                                          textStyle(2, width, height, kWhite),
                                    ),
                                    SizedBox(
                                      height: height * 0.35,
                                      width: width * 0.24,
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
                                              for (Map module
                                                  in quizSettingProvider
                                                      .moduleSet)
                                                if (module['semester'] == 1)
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  height / 128,
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: CustomContainer(
                                                        onTap: () {
                                                          bool status =
                                                              moduleStatus(
                                                                  module);
                                                          for (Map lesson
                                                              in module[
                                                                  'lessons']) {
                                                            status
                                                                ? {
                                                                    quizProvider.removeHeadlines(
                                                                        lesson[
                                                                            'h1s'],
                                                                        context),
                                                                  }
                                                                : {
                                                                    quizProvider.addHeadlines(
                                                                        lesson[
                                                                            'h1s'],
                                                                        context),
                                                                  };
                                                          }
                                                        },
                                                        width: width * 0.2,
                                                        verticalPadding:
                                                            height * 0.02,
                                                        horizontalPadding:
                                                            width * 0.02,
                                                        borderRadius:
                                                            width * 0.005,
                                                        border: null,
                                                        buttonColor:
                                                            moduleStatus(module)
                                                                ? kDarkPurple
                                                                : kDarkGray,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: width *
                                                                    0.19),
                                                            Text(
                                                              module['name'],
                                                              style: textStyle(
                                                                  3,
                                                                  width,
                                                                  height,
                                                                  kWhite),
                                                            ),
                                                            Wrap(
                                                              children: [
                                                                for (Map lesson
                                                                    in module[
                                                                        'lessons'])
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(width /
                                                                            350),
                                                                    child: CustomContainer(
                                                                        onTap: () {
                                                                          if (moduleStatus(
                                                                              module)) {
                                                                            quizProvider.removeHeadlines(lesson['h1s'],
                                                                                context);
                                                                          } else {
                                                                            quizProvider.selectedHeadlines.containsAll(lesson['h1s'])
                                                                                ? {
                                                                                    quizProvider.removeHeadlines(lesson['h1s'], context),
                                                                                  }
                                                                                : {
                                                                                    quizProvider.addHeadlines(lesson['h1s'], context),
                                                                                  };
                                                                          }
                                                                        },
                                                                        verticalPadding: height * 0.002,
                                                                        horizontalPadding: width * 0.01,
                                                                        borderRadius: width * 0.005,
                                                                        border: null,
                                                                        buttonColor: quizProvider.selectedHeadlines.containsAll(lesson['h1s']) ? kPurple : kGray,
                                                                        child: Text(lesson['name'], style: textStyle(4, width, height, kWhite))),
                                                                  )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text('الفصل الثاني',
                                        style: textStyle(
                                            2, width, height, kWhite)),
                                    SizedBox(
                                      height: height * 0.35,
                                      width: width * 0.24,
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
                                              for (Map module
                                                  in quizSettingProvider
                                                      .moduleSet)
                                                if (module['semester'] == 2)
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  height / 128,
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: CustomContainer(
                                                        onTap: () {
                                                          bool status =
                                                              moduleStatus(
                                                                  module);
                                                          for (Map lesson
                                                              in module[
                                                                  'lessons']) {
                                                            status
                                                                ? {
                                                                    quizProvider.removeHeadlines(
                                                                        lesson[
                                                                            'h1s'],
                                                                        context),
                                                                  }
                                                                : {
                                                                    quizProvider.addHeadlines(
                                                                        lesson[
                                                                            'h1s'],
                                                                        context),
                                                                  };
                                                          }
                                                        },
                                                        width: width * 0.2,
                                                        verticalPadding:
                                                            height * 0.02,
                                                        horizontalPadding:
                                                            width * 0.02,
                                                        borderRadius:
                                                            width * 0.005,
                                                        border: null,
                                                        buttonColor:
                                                            moduleStatus(module)
                                                                ? kDarkPurple
                                                                : kDarkGray,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: width *
                                                                    0.19),
                                                            Text(
                                                              module['name'],
                                                              style: textStyle(
                                                                  3,
                                                                  width,
                                                                  height,
                                                                  kWhite),
                                                            ),
                                                            Wrap(
                                                              children: [
                                                                for (Map lesson
                                                                    in module[
                                                                        'lessons'])
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .all(width /
                                                                            350),
                                                                    child: CustomContainer(
                                                                        onTap: () {
                                                                          if (moduleStatus(
                                                                              module)) {
                                                                            quizProvider.removeHeadlines(lesson['h1s'],
                                                                                context);
                                                                          } else {
                                                                            quizProvider.selectedHeadlines.containsAll(lesson['h1s'])
                                                                                ? {
                                                                                    quizProvider.removeHeadlines(lesson['h1s'], context),
                                                                                  }
                                                                                : {
                                                                                    quizProvider.addHeadlines(lesson['h1s'], context),
                                                                                  };
                                                                          }
                                                                        },
                                                                        verticalPadding: height * 0.002,
                                                                        horizontalPadding: width * 0.01,
                                                                        borderRadius: width * 0.005,
                                                                        border: null,
                                                                        buttonColor: quizProvider.selectedHeadlines.containsAll(lesson['h1s']) ? kPurple : kGray,
                                                                        child: Text(lesson['name'], style: textStyle(4, width, height, kWhite))),
                                                                  )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('المهارات',
                                            style: textStyle(
                                                2, width, height, kWhite)),
                                        SizedBox(width: width * 0.05),
                                        Icon(
                                          Icons.search_rounded,
                                          size: width * 0.016,
                                          color: kWhite,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.5,
                                      width: width * 0.26,
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
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.02),
                                                child: CustomContainer(
                                                  onTap: null,
                                                  verticalPadding:
                                                      height * 0.02,
                                                  horizontalPadding:
                                                      width * 0.02,
                                                  borderRadius: width * 0.005,
                                                  border: null,
                                                  buttonColor: kDarkGray,
                                                  child: Wrap(
                                                    runSpacing: width * 0.004,
                                                    spacing: width * 0.004,
                                                    children: [
                                                      for (Map headline
                                                          in quizSettingProvider
                                                              .headlineSet)
                                                        CustomContainer(
                                                            onTap: () {
                                                              quizProvider
                                                                      .selectedHeadlines
                                                                      .contains(
                                                                          headline[
                                                                              'id'])
                                                                  ? quizProvider
                                                                      .removeHeadlines([
                                                                      headline[
                                                                          'id']
                                                                    ], context)
                                                                  : quizProvider
                                                                      .addHeadlines([
                                                                      headline[
                                                                          'id']
                                                                    ], context);
                                                            },
                                                            verticalPadding:
                                                                height * 0.02,
                                                            horizontalPadding:
                                                                width * 0.03,
                                                            borderRadius:
                                                                width * 0.005,
                                                            border: null,
                                                            buttonColor: quizProvider
                                                                    .selectedHeadlines
                                                                    .contains(
                                                                        headline[
                                                                            'id'])
                                                                ? kPurple
                                                                : kGray,
                                                            child: Text(
                                                                headline[
                                                                    'name'],
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width * 0.03),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('عدد الأسئلة',
                                        style: textStyle(
                                            2, width, height, kWhite)),
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Center(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: kLightPurple,
                                            inactiveTrackColor: kDarkGray,
                                            thumbColor: kPurple,
                                            trackHeight: height * 0.022,
                                            trackShape:
                                                const RoundedTrackShape(),
                                            thumbShape: CustomSliderThumbRect(
                                                max: 40,
                                                min: 0,
                                                thumbRadius: 1,
                                                thumbHeight: height * 0.04),
                                            overlayColor:
                                                kPurple.withOpacity(0.3),
                                            activeTickMarkColor: kTransparent,
                                            inactiveTickMarkColor: kTransparent,
                                          ),
                                          child: Slider(
                                              min: 0,
                                              max: 40,
                                              value: quizProvider.questionNum
                                                  .toDouble(),
                                              onChanged: (value) {
                                                quizProvider.setQuestionNum(
                                                    value.floor());
                                              }),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.04),
                                    Text(
                                      'وقت الإمتحان',
                                      style:
                                          textStyle(2, width, height, kWhite),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.3,
                                      height: height * 0.09,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      border: null,
                                      buttonColor: kDarkGray,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: kGray,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.005),
                                                    bottomRight:
                                                        Radius.circular(
                                                            width * 0.005))),
                                            height: height * 0.09,
                                            child: MaterialButton(
                                              color: quizProvider.withTime
                                                  ? kPurple
                                                  : kGray,
                                              onPressed: () {
                                                quizProvider.setWithTime();
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.005),
                                                    bottomRight:
                                                        Radius.circular(
                                                            width * 0.005)),
                                              ),
                                              padding:
                                                  EdgeInsets.all(height * 0.01),
                                              minWidth: width * 0.075,
                                              child: Text(
                                                'تفعيل\nالمؤقت',
                                                style: textStyle(
                                                    4, width, height, kWhite),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(),
                                          CustomTextField(
                                              controller: minutes,
                                              width: width * 0.05,
                                              fontOption: 3,
                                              fontColor: kWhite,
                                              textAlign: TextAlign.center,
                                              obscure: false,
                                              readOnly: false,
                                              focusNode: null,
                                              maxLines: null,
                                              maxLength: null,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (text) {
                                                if (!RegExp(r'^[0-9:]+$')
                                                    .hasMatch(text)) {
                                                  minutes.text = '';
                                                }
                                                if (int.parse(text) > 60) {
                                                  minutes.text = '60';
                                                } else if (text.length > 2) {
                                                  minutes.text = '00';
                                                }
                                                quizProvider.setDuration(
                                                    minutes.text, hours.text);
                                              },
                                              onSubmitted: null,
                                              backgroundColor: kGray,
                                              horizontalPadding: width * 0.008,
                                              verticalPadding: width * 0.004,
                                              isDense: null,
                                              errorText: null,
                                              hintText: '05',
                                              hintTextColor:
                                                  kWhite.withOpacity(0.5),
                                              suffixIcon: null,
                                              prefixIcon: null,
                                              border: outlineInputBorder(
                                                  width * 0.005, kTransparent),
                                              focusedBorder: outlineInputBorder(
                                                  width * 0.005, kTransparent)),
                                          Text(
                                            ':',
                                            style: textStyle(
                                                2, width, height, kWhite),
                                          ),
                                          CustomTextField(
                                              controller: hours,
                                              width: width * 0.05,
                                              fontOption: 3,
                                              fontColor: kWhite,
                                              textAlign: TextAlign.center,
                                              obscure: false,
                                              readOnly: false,
                                              focusNode: null,
                                              maxLines: null,
                                              maxLength: null,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (text) {
                                                if (!RegExp(r'^[0-9:]+$')
                                                    .hasMatch(text)) {
                                                  hours.text = '';
                                                }
                                                if (int.parse(text) > 5) {
                                                  hours.text = '05';
                                                } else if (text.length > 2) {
                                                  hours.text = '00';
                                                }
                                                quizProvider.setDuration(
                                                    minutes.text, hours.text);
                                              },
                                              onSubmitted: null,
                                              backgroundColor: kGray,
                                              horizontalPadding: width * 0.008,
                                              verticalPadding: width * 0.004,
                                              isDense: null,
                                              errorText: null,
                                              hintText: '00',
                                              hintTextColor:
                                                  kWhite.withOpacity(0.5),
                                              suffixIcon: null,
                                              prefixIcon: null,
                                              border: outlineInputBorder(
                                                  width * 0.005, kTransparent),
                                              focusedBorder: outlineInputBorder(
                                                  width * 0.005, kTransparent)),
                                          const SizedBox(),
                                          const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height * 0.04),
                                    Text('صعوبة الإمتحان',
                                        style: textStyle(
                                            2, width, height, kWhite)),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    CustomContainer(
                                      buttonColor: kDarkGray,
                                      borderRadius: width * 0.005,
                                      child: Row(
                                        children: [
                                          CustomContainer(
                                            onTap: () {
                                              quizProvider.setQuizLevel(0);
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.02,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            buttonColor:
                                                quizProvider.quizLevel == 0
                                                    ? kPurple
                                                    : kDarkGray,
                                            border: null,
                                            child: Center(
                                              child: Text(
                                                'سهل',
                                                style: textStyle(
                                                    4, width, height, kWhite),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: () {
                                              quizProvider.setQuizLevel(1);
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.02,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            buttonColor:
                                                quizProvider.quizLevel == 1
                                                    ? kPurple
                                                    : kDarkGray,
                                            border: null,
                                            child: Center(
                                              child: Text(
                                                'صعب',
                                                style: textStyle(
                                                    4, width, height, kWhite),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: () {
                                              quizProvider.setQuizLevel(2);
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.02,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            buttonColor:
                                                quizProvider.quizLevel == 2
                                                    ? kPurple
                                                    : kDarkGray,
                                            border: null,
                                            child: Center(
                                              child: Text(
                                                'تلقائي',
                                                style: textStyle(
                                                    4, width, height, kWhite),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height * 0.08),
                                    CustomContainer(
                                      onTap: () {
                                        if (quizProvider
                                            .selectedHeadlines.isNotEmpty) {
                                          websiteProvider.setLoaded(false);

                                          Navigator.pushNamed(
                                              context, Quiz.route);
                                        }
                                      },
                                      width: width * 0.3,
                                      verticalPadding: height * 0.02,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      buttonColor: kPurple,
                                      border: null,
                                      child: Center(
                                        child: Text(
                                          'امتحن',
                                          style: textStyle(
                                              3, width, height, kWhite),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]),
                      const SizedBox(),
                    ],
                  ),
                  MouseRegion(
                    onHover: (isHover) {
                      setState(() {
                        forwardAnimationController!.reverse();
                        forwardAnimationCurve!.addListener(() => setState(() {
                              forwardAnimationValue =
                                  forwardAnimationCurve!.value;
                            }));

                        backwardAnimationController!.forward();
                        backwardAnimationCurve!.addListener(() => setState(() {
                              backwardAnimationValue =
                                  backwardAnimationCurve!.value;
                            }));
                      });
                    },
                    onExit: (e) {
                      setState(() {
                        forwardAnimationController!.forward();
                        forwardAnimationCurve!.addListener(() => setState(() {
                              forwardAnimationValue =
                                  forwardAnimationCurve!.value;
                            }));

                        backwardAnimationController!.reverse();
                        backwardAnimationCurve!.addListener(() => setState(() {
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
                                  websiteProvider.setLoaded(false);
                                  Navigator.pushNamed(context, Dashboard.route);
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01,
                                    vertical: height * 0.01),
                                child: CustomContainer(
                                  onTap: () {},
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
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.02),
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
                                  onTap: () {},
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
                                  websiteProvider.setLoaded(false);
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: height * 0.01),
                              child: CustomContainer(
                                onTap: () {},
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: height * 0.01),
                              child: CustomContainer(
                                onTap: () {},
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: height * 0.01),
                              child: CustomContainer(
                                onTap: () {},
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height * 0.02),
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
                                onTap: () {},
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: height * 0.01),
                              child: CustomContainer(
                                onTap: () {},
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
                                    if (backwardAnimationValue != 1) SizedBox(),
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
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ))
        : Scaffold(
            backgroundColor: kDarkGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
