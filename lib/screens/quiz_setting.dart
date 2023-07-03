import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import '../components/right_bar.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import '../providers/user_info_provider.dart';
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
  void checkSession(WebsiteProvider websiteProvider,
      UserInfoProvider userInfoProvider, QuizProvider quizProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    post('subject_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((result) {
      dynamic subjectSet = decode(result);
      subjectSet == 0
          ? context.pushReplacement('/Welcome')
          : {
              post('user_name/', {
                if (key0 != null) 'email': key0,
                if (key1 != null) 'phone': key1,
                'password': value,
              }).then((result) {
                dynamic userName = decode(result);
                userName == 0
                    ? context.pushReplacement('/Welcome')
                    : {
                        websiteProvider.setSubjects(subjectSet),
                        userInfoProvider.setUserFirstName(userName),
                        quizProvider.reset(),
                        websiteProvider.setLoaded(true)
                      };
              })
            };
    });
  }

  @override
  void initState() {
    super.initState();
    checkSession(
        Provider.of<WebsiteProvider>(context, listen: false),
        Provider.of<UserInfoProvider>(context, listen: false),
        Provider.of<QuizProvider>(context, listen: false));
  }

  bool barVisibility = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    return width < height
        ? const RotateYourPhone()
        : websiteProvider.loaded
            ? Scaffold(
                body: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("images/single_question_background.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const RightBar(),
                      SizedBox(
                        height: height,
                        width: width * 0.94,
                        child: ListView(
                          children: [
                            SizedBox(
                              width: width * 0.94,
                              height: height * 0.07,
                            ),
                            SizedBox(
                              width: width * 0.94,
                              child: Divider(
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                                color: kDarkGray,
                              ),
                            ),
                            SizedBox(
                              width: width * 0.94,
                              height: height * 0.85,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height / 128),
                                        child: Text(
                                          'أهلا ${userInfoProvider.firstName.text} !\nاختر من المواد التالية لتشكل امتحانك الخاص بك!',
                                          style: textStyle(
                                              2, width, height, kWhite),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.72,
                                        height: height * 0.65,
                                        child: ListView(
                                          children: [
                                            Wrap(
                                                spacing: width * 0.02,
                                                runSpacing: height * 0.03,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          websiteProvider
                                                              .subjects.length;
                                                      i++) ...[
                                                    if (websiteProvider
                                                                    .subjects[i]
                                                                ['id'] !=
                                                            '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab' &&
                                                        websiteProvider
                                                                    .subjects[i]
                                                                ['id'] !=
                                                            '7376be1e-e252-4d22-874b-9ec129326807')
                                                      CustomContainer(
                                                        onTap: () {
                                                          quizProvider.setSubject(
                                                              websiteProvider
                                                                      .subjects[
                                                                  i]['id'],
                                                              websiteProvider
                                                                      .subjects[
                                                                  i]['name']);

                                                          websiteProvider
                                                              .setLoaded(false);

                                                          context.pushReplacement(
                                                              '/AdvanceQuizSetting');
                                                        },
                                                        width: width * 0.21,
                                                        height: height * 0.16,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius:
                                                            width * 0.005,
                                                        border: null,
                                                        buttonColor: quizProvider
                                                                    .subjectID ==
                                                                websiteProvider
                                                                        .subjects[
                                                                    i]['id']
                                                            ? kPurple
                                                            : kDarkGray,
                                                        child: Stack(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          children: [
                                                            Image(
                                                              image: const AssetImage(
                                                                  'images/planet.png'),
                                                              width:
                                                                  width * 0.1,
                                                              fit: BoxFit
                                                                  .contain,
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: width *
                                                                          0.025),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child: Text(
                                                                  '${websiteProvider.subjects[i]['name']}',
                                                                  style: textStyle(
                                                                      2,
                                                                      width,
                                                                      height,
                                                                      quizProvider.subjectID ==
                                                                              websiteProvider.subjects[i]['id']
                                                                          ? kDarkBlack
                                                                          : kWhite),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  ],
                                                  CustomContainer(
                                                    onTap: () {
                                                      quizProvider.setSubject(
                                                          '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab',
                                                          'اللغة العربية');

                                                      websiteProvider
                                                          .setLoaded(false);

                                                      context.pushReplacement(
                                                          '/WritingQuiz');
                                                    },
                                                    width: width * 0.21,
                                                    height: height * 0.16,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: quizProvider
                                                                .subjectID ==
                                                            '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab'
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
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.025),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              'تعبير عربي',
                                                              style: textStyle(
                                                                  2,
                                                                  width,
                                                                  height,
                                                                  quizProvider.subjectID ==
                                                                          '2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab'
                                                                      ? kDarkBlack
                                                                      : kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      quizProvider.setSubject(
                                                          '7376be1e-e252-4d22-874b-9ec129326807',
                                                          'اللغة الإنجليزية');

                                                      websiteProvider
                                                          .setLoaded(false);

                                                      context.pushReplacement(
                                                          '/WritingQuiz');
                                                    },
                                                    width: width * 0.21,
                                                    height: height * 0.16,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: quizProvider
                                                                .subjectID ==
                                                            '7376be1e-e252-4d22-874b-9ec129326807'
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
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.025),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              'تعبير إنجليزي',
                                                              style: textStyle(
                                                                  2,
                                                                  width,
                                                                  height,
                                                                  quizProvider.subjectID ==
                                                                          '7376be1e-e252-4d22-874b-9ec129326807'
                                                                      ? kDarkBlack
                                                                      : kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      websiteProvider
                                                          .setLoaded(false);
                                                      context.pushReplacement(
                                                          '/SuggestedQuizzes');
                                                    },
                                                    width: width * 0.21,
                                                    height: height * 0.16,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kDarkGray,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      children: [
                                                        Image(
                                                          image: const AssetImage(
                                                              'images/planet.png'),
                                                          width: width * 0.1,
                                                          fit: BoxFit.contain,
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.025),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              'أسئلة وزارة سابقة\nوالامتحانات المقترحة',
                                                              style: textStyle(
                                                                  2,
                                                                  width,
                                                                  height,
                                                                  kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ])
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(width * 0.005),
                                      bottomRight:
                                          Radius.circular(width * 0.005),
                                    ),
                                    child: CustomContainer(
                                      width: width * 0.10,
                                      height: height * 0.6,
                                      border: bottomRightTopBorder(kWhite),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: height * 0.08),
                                          CustomContainer(
                                            onTap: () {
                                              websiteProvider.setLoaded(false);
                                              context.pushReplacement(
                                                  '/QuizHistory');
                                            },
                                            width: width * 0.08,
                                            height: height * 0.1,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kDarkGray,
                                            child: Text(
                                              'سجل\nالامتحانات',
                                              textAlign: TextAlign.center,
                                              style: textStyle(
                                                  3, width, height, kWhite, 4),
                                            ),
                                          ),
                                          SizedBox(height: height * 0.05),
                                          Text(
                                            'راجع\nامتحاناتك\nلتتمكن من\nتلافي\nأخطاءك',
                                            textAlign: TextAlign.center,
                                            style: textStyle(
                                                3, width, height, kWhite, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
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
