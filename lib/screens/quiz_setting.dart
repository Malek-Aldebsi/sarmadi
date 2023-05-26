import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../components/custom_container.dart';
import '../utils/session.dart';

class QuizSetting extends StatefulWidget {

  const QuizSetting({Key? key}) : super(key: key);

  @override
  State<QuizSetting> createState() => _QuizSettingState();
}

class _QuizSettingState extends State<QuizSetting>
    with TickerProviderStateMixin {
  void checkSession() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    if ((key0 != null || key1 != null) &&
        value != null &&
        Provider.of<WebsiteProvider>(context, listen: false)
            .subjects
            .isNotEmpty) {
      Provider.of<WebsiteProvider>(context, listen: false).setLoaded(true);
    } else {
      post('subject_set/', {
        if (key0 != null) 'email': key0,
        if (key1 != null) 'phone': key1,
        'password': value,
      }).then((value) {
        dynamic result = decode(value);
        result == 0
            ? context.go('/Welcome')
            : {
                Provider.of<WebsiteProvider>(context, listen: false)
                    .setSubjects(result),
                Provider.of<WebsiteProvider>(context, listen: false)
                    .setLoaded(true)
              };
      });
    }
  }

  @override
  void initState() {
    checkSession();
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: width * 0.1),
                      Padding(
                        padding: EdgeInsets.only(right: width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height / 128),
                              child: Text(
                                'كتيب المواد',
                                style: textStyle(1, width, height, kWhite),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.72,
                              height: height * 0.65,
                              child: ListView(
                                children: [
                                  for (int i = 0;
                                      i < websiteProvider.subjects.length;
                                      i += 3) ...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.02),
                                      child: Row(
                                        children: [
                                          for (int j = 0;
                                              j < 3 &&
                                                  j + i <
                                                      websiteProvider
                                                          .subjects.length;
                                              j++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.02),
                                              child: CustomContainer(
                                                onTap: () {
                                                  quizProvider.setSubject(
                                                      websiteProvider
                                                              .subjects[i + j]
                                                          ['id'],
                                                      websiteProvider
                                                              .subjects[i + j]
                                                          ['name']);

                                                  websiteProvider
                                                      .setLoaded(false);
                                                  context.go(
                                                      '/AdvanceQuizSetting');
                                                },
                                                width: width * 0.21,
                                                height: height * 0.16,
                                                verticalPadding: 0,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                border: null,
                                                buttonColor: quizProvider
                                                            .subjectID ==
                                                        websiteProvider
                                                                .subjects[i + j]
                                                            ['id']
                                                    ? kPurple
                                                    : kDarkGray,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  children: [
                                                    Image(
                                                      image: const AssetImage(
                                                          'images/planet.png'),
                                                      width: width * 0.1,
                                                      fit: BoxFit.contain,
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: width * 0.025),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          '${websiteProvider.subjects[i + j]['name']}',
                                                          style: textStyle(
                                                              2,
                                                              width,
                                                              height,
                                                              quizProvider.subjectID ==
                                                                      websiteProvider.subjects[i +
                                                                              j]
                                                                          ['id']
                                                                  ? kDarkBlack
                                                                  : kWhite),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
            ),
          ))
        : Scaffold(
            backgroundColor: kDarkGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
