import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/quiz_provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';

import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_text_field.dart';
import '../components/right_bar.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/suggested_quizzes_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class SuggestedQuizzes extends StatefulWidget {
  const SuggestedQuizzes({Key? key}) : super(key: key);

  @override
  State<SuggestedQuizzes> createState() => _SuggestedQuizzesState();
}

class _SuggestedQuizzesState extends State<SuggestedQuizzes>
    with TickerProviderStateMixin {
  Set hoveredButton = {};
  TextEditingController search = TextEditingController();
  ScrollController controller = ScrollController();

  void getQuizzes(SuggestedQuizzesProvider suggestedQuizzesProvider,
      WebsiteProvider websiteProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('suggested_quizzes/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
              suggestedQuizzesProvider.setQuizzes(result),
              websiteProvider.setLoaded(true)
            };
    });
  }

  void getQuiz(WebsiteProvider websiteProvider, QuizProvider quizProvider,
      SuggestedQuizzesProvider suggestedQuizzesProvider, int quizIndex) async {
    websiteProvider.setLoaded(false);

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('take_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'quiz_id': suggestedQuizzesProvider.quizzes[quizIndex]['id'],
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
              quizProvider.setSubject(
                  suggestedQuizzesProvider.quizzes[quizIndex]['subject']['id'],
                  suggestedQuizzesProvider.quizzes[quizIndex]['subject']
                      ['name']),
              quizProvider.setQuestions(result),
              quizProvider.setWithTime(true),
              quizProvider.setDurationFromSecond(
                  suggestedQuizzesProvider.quizzes[quizIndex]['duration'] * 60),
              context.pushReplacement('/Quiz'),
            };
    });
  }

  @override
  void initState() {
    getQuizzes(Provider.of<SuggestedQuizzesProvider>(context, listen: false),
        Provider.of<WebsiteProvider>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SuggestedQuizzesProvider suggestedQuizzesProvider =
        Provider.of<SuggestedQuizzesProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
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
                                  'الامتحانات',
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
                          if (suggestedQuizzesProvider.quizzes.isEmpty)
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
                                      Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.02,
                                                vertical: height * 0.01),
                                            child: Wrap(
                                                spacing: width * 0.02,
                                                runSpacing: height * 0.03,
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          suggestedQuizzesProvider
                                                              .quizzes.length;
                                                      i++) ...[
                                                    CustomContainer(
                                                      onTap: () {
                                                        getQuiz(
                                                            websiteProvider,
                                                            quizProvider,
                                                            suggestedQuizzesProvider,
                                                            i);
                                                      },
                                                      width: width * 0.25,
                                                      height: height * 0.28,
                                                      verticalPadding: 0,
                                                      horizontalPadding: 0,
                                                      borderRadius:
                                                          width * 0.005,
                                                      border: null,
                                                      buttonColor: kDarkGray,
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        children: [
                                                          Image(
                                                            image: const AssetImage(
                                                                'images/planet.png'),
                                                            width: width * 0.18,
                                                            fit: BoxFit.contain,
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.25,
                                                            height:
                                                                height * 0.3,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  '${suggestedQuizzesProvider.quizzes[i]['name']}',
                                                                  style: textStyle(
                                                                      2,
                                                                      width,
                                                                      height,
                                                                      kWhite),
                                                                ),
                                                                Text(
                                                                  '${suggestedQuizzesProvider.quizzes[i]['subject']['name']}',
                                                                  style: textStyle(
                                                                      2,
                                                                      width,
                                                                      height,
                                                                      kWhite),
                                                                ),
                                                                Text(
                                                                  '${suggestedQuizzesProvider.quizzes[i]['questions_num']} سؤال | ${suggestedQuizzesProvider.quizzes[i]['duration']} دقيقة ',
                                                                  style: textStyle(
                                                                      2,
                                                                      width,
                                                                      height,
                                                                      kWhite),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ]),
                                          )),
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
