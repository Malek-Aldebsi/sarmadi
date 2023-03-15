import 'package:flutter/material.dart';
import 'welcome.dart';
import '../components/custom_container.dart';
import '../const.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'advance_quiz_setting.dart';
import 'dashboard.dart';

class QuizSetting extends StatefulWidget {
  static const String route = '/QuizSetting/';

  const QuizSetting({Key? key}) : super(key: key);

  @override
  State<QuizSetting> createState() => _QuizSettingState();
}

class _QuizSettingState extends State<QuizSetting>
    with TickerProviderStateMixin {
  bool loaded = false;

  String? selectedSubjectID;
  String? selectedSubjectName;
  List subjects = [];

  void getSubjects() async {
    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('subject_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              subjects = result;
              loaded = true;
            });
    });
  }

  @override
  void initState() {
    getSubjects();
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

    return loaded
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
                      SizedBox(width: width * 0.05),
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
                                style: textStyle.copyWith(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width / 45,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.7,
                              height: height * 0.65,
                              child: ListView(
                                children: [
                                  for (int i = 0;
                                      i < subjects.length;
                                      i += 3) ...[
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height * 0.02),
                                      child: Row(
                                        children: [
                                          for (int j = 0;
                                              j < 3 && j + i < subjects.length;
                                              j++)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.02),
                                              child: Button(
                                                onTap: () {
                                                  setState(() {
                                                    selectedSubjectID ==
                                                            subjects[i + j]
                                                                ['id']
                                                        ? {
                                                            selectedSubjectID =
                                                                null,
                                                            selectedSubjectName =
                                                                null
                                                          }
                                                        : {
                                                            selectedSubjectID =
                                                                subjects[i + j]
                                                                    ['id'],
                                                            selectedSubjectName =
                                                                subjects[i + j]
                                                                    ['name']
                                                          };
                                                  });
                                                },
                                                width: width * 0.21,
                                                height: height * 0.16,
                                                verticalPadding: 0,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                border: 0,
                                                buttonColor:
                                                    selectedSubjectID ==
                                                            subjects[i + j]
                                                                ['id']
                                                        ? kPurple
                                                        : kLightGray,
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
                                                          '${subjects[i + j]['name']}',
                                                          style: textStyle.copyWith(
                                                              fontSize:
                                                                  width / 80,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: selectedSubjectID ==
                                                                      subjects[i +
                                                                              j]
                                                                          ['id']
                                                                  ? kBlack
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
                            SizedBox(height: height / 32),
                            Button(
                              onTap: () {
                                if (selectedSubjectName != null) {
                                  Navigator.pushNamed(
                                      context, AdvanceQuizSetting.route,
                                      arguments: {
                                        'subjectName': selectedSubjectName,
                                        'subjectID': selectedSubjectID
                                      });
                                }
                              },
                              width: width * 0.15,
                              verticalPadding: height * 0.01,
                              horizontalPadding: width / 70,
                              borderRadius: 8,
                              border: 0,
                              buttonColor: kPurple,
                              child: Center(
                                child: Text(
                                  'المتابعة',
                                  style: textStyle.copyWith(
                                      fontSize: width / 60,
                                      fontWeight: FontWeight.w900,
                                      color: kBlack),
                                ),
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
                    child: Container(
                        height: height,
                        width: width *
                            (0.06 * forwardAnimationValue +
                                0.2 * backwardAnimationValue),
                        decoration: BoxDecoration(
                            color: kLightBlack.withOpacity(0.95),
                            border: Border(
                                left: BorderSide(color: kLightGray, width: 2))),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: height * 0.06,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'الصفحة الرئيسية',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'معلوماتي',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.account_circle_outlined,
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
                                vertical: height * 0.02,
                              ),
                              child: Divider(
                                thickness: 1,
                                indent: width * 0.005,
                                endIndent: width * 0.005,
                                color: kLightGray,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'يلا نساعدك بالدراسة',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.school_outlined,
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'امتحانات وأسئلة',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'نتائج وتحليلات',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'مجتمع مدارس',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'قائمة المتصدرين',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                              child: Divider(
                                thickness: 1,
                                indent: width * 0.005,
                                endIndent: width * 0.005,
                                color: kLightGray,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'الإعدادات',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'تواصل معنا',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
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
            backgroundColor: kLightGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
