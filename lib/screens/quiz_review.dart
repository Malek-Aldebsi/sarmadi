import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import '../components/right_bar.dart';
import '../const/borders.dart';
import '../providers/quiz_provider.dart';
import '../components/custom_divider.dart';
import '../components/string_with_latex.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/similar_questions_provider.dart';
import '../providers/review_provider.dart';
import '../providers/website_provider.dart';
import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class QuizReview extends StatefulWidget {
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
      'quiz_id': Provider.of<ReviewProvider>(context, listen: false).quizID
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuizSubjectName(result['quiz_subject']['name']),
        Provider.of<ReviewProvider>(context, listen: false)
            .setQuizSubjectID(result['quiz_subject']['id']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuizTime(result['quiz_duration'].toString()),
        Provider.of<ReviewProvider>(context, listen: false)
                  .setQuizIdealTime(result['ideal_duration'].toString()),
        Provider.of<ReviewProvider>(context, listen: false)
            .setQuizAttemptTime(result['attempt_duration'].toString()),

              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuestions(result['answers']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setCorrectQuestionsNum(result['correct_questions_num']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuestionsNum(result['question_num']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setSkills(result['best_worst_skills']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setStatements(result['statements']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuestionIndex(1),
              Provider.of<WebsiteProvider>(context, listen: false)
                  .setLoaded(true),
            };
    });
  }

  @override
  void initState() {
    getResult();
    mainScrollController.addListener(() {
      if (mainScrollController.positions.last.pixels + 2 >
              MediaQuery.of(context).size.height &&
          !Provider.of<ReviewProvider>(context, listen: false)
              .questionScrollState) {
        Provider.of<ReviewProvider>(context, listen: false)
            .setQuestionScrollState(true);
      } else if (mainScrollController.positions.last.pixels <
              MediaQuery.of(context).size.height &&
          Provider.of<ReviewProvider>(context, listen: false)
              .questionScrollState) {
        Provider.of<ReviewProvider>(context, listen: false)
            .setQuestionScrollState(false);
      }
    });

    questionsScrollController.addListener(() {
      if ((questionsScrollController.positions.last.pixels /
                      MediaQuery.of(context).size.height)
                  .round() +
              1 !=
          Provider.of<ReviewProvider>(context, listen: false).questionIndex) {
        Provider.of<ReviewProvider>(context, listen: false).setQuestionIndex(
            (questionsScrollController.positions.last.pixels /
                        MediaQuery.of(context).size.height)
                    .round() +
                1);
      }
    });
    super.initState();
  }

  void similarQuiz(QuizProvider quizProvider, ReviewProvider reviewProvider) async {
    Provider.of<WebsiteProvider>(context, listen: false)
        .setLoaded(false);

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('similar_questions/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'quiz_id': reviewProvider.quizID,
      'by_author': true,
      'by_headlines': true,
      'by_level': true,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
        quizProvider.setSubject(reviewProvider.quizSubjectID, reviewProvider.quizSubjectName),
        quizProvider.setQuestions(result),
        reviewProvider.quizTime == '' ? quizProvider.setWithTime(false) : {
          quizProvider.setDurationFromSecond(double.parse(reviewProvider.quizTime).toInt()),
          quizProvider.setWithTime(true)
        },
      context.pushReplacement('/Quiz')
      };
    });
  }

  void retakeQuiz(QuizProvider quizProvider, ReviewProvider reviewProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('retake_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'quiz_id': reviewProvider.quizID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
        quizProvider.setSubject(reviewProvider.quizSubjectID, reviewProvider.quizSubjectName),
        quizProvider.setQuestions(result),
        reviewProvider.quizTime == '' ? quizProvider.setWithTime(false) : {
          quizProvider.setDurationFromSecond(double.parse(reviewProvider.quizTime).toInt()),
          quizProvider.setWithTime(true)
        },
      context.pushReplacement('/Quiz')
      };
    });
  }

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

  double fontWidth(fontOption, width, height) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: 'مهارة', style: textStyle(fontOption, width, height, kWhite)),
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    return textPainter.computeLineMetrics()[0].width / 5;
  }

  Widget finalAnswerQuestionWithImage(
      width, height, reviewProvider, questionIndex) {
    return CustomContainer(
      width: width * 0.66,

      buttonColor: kDarkGray,
      borderRadius: width * 0.005,
      verticalPadding: height * 0.03,
      horizontalPadding: width * 0.02,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.02),
            child: SizedBox(
              width: width * 0.61,
              child: stringWithLatex(
                  reviewProvider.questions[questionIndex - 1]['question']
                      ['body'],
                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          SizedBox(height: height*0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
  Column(
    mainAxisAlignment:MainAxisAlignment.center,children: [CustomContainer(
      onTap: null,
      verticalPadding: 0,
      height: height*0.08,
      horizontalPadding: width * 0.02,
      width: width * 0.3,
      borderRadius: width * 0.005,
      border: null,
      buttonColor: kGray,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.22,
            child: stringWithLatex(
                reviewProvider.questions[questionIndex - 1]['body'],
                3,
                width,
                height,
                kWhite),
          ),
          reviewProvider.questions[questionIndex - 1]['is_correct']
              ? Icon(
            Icons.check_rounded,
            size: width * 0.015,
            color: kGreen,
          )
              : Icon(
            Icons.close,
            size: width * 0.015,
            color: kRed,
          )
        ],
      )),
    if (!reviewProvider.questions[questionIndex - 1]['is_correct'])

      ...[SizedBox(height: height*0.01),CustomContainer(
          onTap: null,
          height: height*0.08,
          verticalPadding: 0,
          horizontalPadding: width * 0.02,
          width: width * 0.3,
          borderRadius: width * 0.005,
          border: null,
          buttonColor: kGray,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.22,
                child: stringWithLatex(
                    reviewProvider.questions[questionIndex - 1]['question']['correct_answer']['body'],
                    3,
                    width,
                    height,
                    kWhite),
              ),
              Icon(
                Icons.check_rounded,
                size: width * 0.015,
                color: kGreen,
              )

            ],
          ))],],),
              SizedBox(
                height: height * 0.25,
                child: CustomDivider(
                  dashHeight: 2,
                  dashWidth: width * 0.005,
                  dashColor: kGray.withOpacity(0.9),
                  direction: Axis.vertical,
                  fillRate: 0.7,
                ),
              ),
              Image(
                image: NetworkImage(reviewProvider.questions[questionIndex - 1]
                    ['question']['image']),
                height: height * 0.25,
                width: width * 0.25,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget finalAnswerQuestionWithoutImage(
      width, height, reviewProvider, questionIndex) {
    return CustomContainer(
      width: width * 0.66,

      buttonColor: kDarkGray,
      borderRadius: width * 0.005,
      verticalPadding: height * 0.04,
      horizontalPadding: width * 0.02,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.02),
            child: SizedBox(
              width: width * 0.61,
              child: stringWithLatex(
                  reviewProvider.questions[questionIndex - 1]['question']
                      ['body'],

                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          SizedBox(height: height*0.01),
          CustomContainer(
              onTap: null,
              verticalPadding: 0,
              horizontalPadding: width * 0.02,
              width: width * 0.61,
              height: height*0.08,
              borderRadius: width * 0.005,
              border: null,
              buttonColor: kGray,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.53,
                    child: stringWithLatex(
                        reviewProvider.questions[questionIndex - 1]['body'],
                        3,
                        width,
                        height,
                        kWhite),
                  ),
                  reviewProvider.questions[questionIndex - 1]['is_correct']
                      ? Icon(
                          Icons.check_rounded,
                          size: width * 0.015,
                          color: kGreen,
                        )
                      : Icon(
                          Icons.close,
                          size: width * 0.015,
                          color: kRed,
                        )
                ],
              )),
          if (!reviewProvider.questions[questionIndex - 1]['is_correct'])

            ...[SizedBox(height: height*0.01),CustomContainer(
                onTap: null,
                verticalPadding: 0,
                horizontalPadding: width * 0.02,
                width: width * 0.61,
                height: height*0.08,
                borderRadius: width * 0.005,
                border: null,
                buttonColor: kGray,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.53,
                      child: stringWithLatex(
                          reviewProvider.questions[questionIndex - 1]['question']['correct_answer']['body'],
                          3,
                          width,
                          height,
                          kWhite),
                    ),
                     Icon(
                      Icons.check_rounded,
                      size: width * 0.015,
                      color: kGreen,
                    )

                  ],
                ))],
        ],
      ),
    );
  }

  Widget multipleChoiceQuestionWithImage(
      width, height, reviewProvider, questionIndex) {
    return CustomContainer(
      width: width * 0.66,

      buttonColor: kDarkGray,
      borderRadius: width * 0.005,
      verticalPadding: height * 0.03,
      horizontalPadding: width * 0.02,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.02),
            child: SizedBox(
              width: width * 0.61,
              child: stringWithLatex(
                  reviewProvider.questions[questionIndex - 1]['question']
                      ['body'],

                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  for (int choiceIndex = 0;
                      choiceIndex <
                          reviewProvider
                              .questions[questionIndex - 1]['question']
                                  ['choices']
                              .length;
                      choiceIndex++)
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: CustomContainer(
                          onTap: null,
                          verticalPadding: 0,
                          horizontalPadding: width * 0.02,
                          height: height*0.08,
                          width: width * 0.3,
                          borderRadius: width * 0.005,
                          border: fullBorder(reviewProvider.questions[questionIndex - 1]['question']['choices']
                          [choiceIndex]['id'] ==
                              reviewProvider.questions[questionIndex - 1]['question']
                              ['correct_answer']['id']
                              ? kGreen
                              : reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                              reviewProvider.questions[questionIndex - 1]['question']
                              ['choices'][choiceIndex]['id'] ==
                                  reviewProvider.questions[questionIndex - 1]['choice']['id']
                                  ? kRed
                                  : kTransparent),
                          buttonColor: reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                              reviewProvider.questions[questionIndex - 1]['question']['choices']
                              [choiceIndex]['id'] ==
                                  reviewProvider.questions[questionIndex - 1]['choice']['id']
                              ? kLightPurple
                              : kGray,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.22,
                                child: stringWithLatex(
                                    reviewProvider.questions[questionIndex - 1]
                                            ['question']['choices'][choiceIndex]
                                        ['body'],
                                    3,
                                    width,
                                    height,
                                    kWhite),
                              ),
                              reviewProvider.questions[questionIndex - 1]['question']['choices']
                              [choiceIndex]['id'] ==
                                  reviewProvider.questions[questionIndex - 1]['question']
                                  ['correct_answer']['id']
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: width * 0.015,
                                      color: kGreen,
                                    )
                                  : reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                                  reviewProvider.questions[questionIndex - 1]['question']
                                  ['choices'][choiceIndex]['id'] ==
                                      reviewProvider.questions[questionIndex - 1]['choice']['id']
                                      ? Icon(
                                          Icons.close,
                                          size: width * 0.015,
                                          color: kRed,
                                        )
                                      : const SizedBox()
                            ],
                          )),
                    ),
                ],
              ),
              SizedBox(
                height: height * 0.25,
                child: CustomDivider(
                  dashHeight: 2,
                  dashWidth: width * 0.005,
                  dashColor: kGray.withOpacity(0.9),
                  direction: Axis.vertical,
                  fillRate: 0.7,
                ),
              ),
              Image(
                image: NetworkImage(reviewProvider.questions[questionIndex - 1]
                    ['question']['image']),
                height: height * 0.25,
                width: width * 0.25,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget multipleChoiceQuestionWithoutImage(
      width, height, reviewProvider, questionIndex) {
    return CustomContainer(

      width: width * 0.66,
      buttonColor: kDarkGray,
      borderRadius: width * 0.005,
      verticalPadding: height * 0.03,
      horizontalPadding: width * 0.02,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.02),
            child: SizedBox(
              width: width * 0.61,
              child: stringWithLatex(
                  reviewProvider.questions[questionIndex - 1]['question']
                      ['body'],
                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          Column(
            children: [
              for (int choiceIndex = 0;
                  choiceIndex <
                      reviewProvider
                          .questions[questionIndex - 1]['question']
                              ['choices']
                          .length;
                  choiceIndex++)
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: CustomContainer(
                      onTap: null,
                      height: height*0.08,
                      verticalPadding: 0,
                      horizontalPadding: width * 0.02,
                      width: width * 0.61,
                      borderRadius: width * 0.005,
                      border: fullBorder(reviewProvider.questions[questionIndex - 1]['question']['choices']
                      [choiceIndex]['id'] ==
                          reviewProvider.questions[questionIndex - 1]['question']
                          ['correct_answer']['id']
                          ? kGreen
                          : reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                          reviewProvider.questions[questionIndex - 1]['question']
                          ['choices'][choiceIndex]['id'] ==
                              reviewProvider.questions[questionIndex - 1]['choice']['id']
                              ? kRed
                              : kTransparent),
                      buttonColor: reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                          reviewProvider.questions[questionIndex - 1]['question']['choices']
                          [choiceIndex]['id'] ==
                              reviewProvider.questions[questionIndex - 1]['choice']['id']
                          ? kLightPurple
                          : kGray,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.53,
                            child: stringWithLatex(
                                reviewProvider.questions[questionIndex - 1]
                                        ['question']['choices'][choiceIndex]
                                    ['body'],
                                3,
                                width,
                                height,
                                kWhite),
                          ),
                          reviewProvider.questions[questionIndex - 1]['question']['choices']
                          [choiceIndex]['id'] ==
                              reviewProvider.questions[questionIndex - 1]['question']
                              ['correct_answer']['id']
                              ? Icon(
                                  Icons.check_rounded,
                                  size: width * 0.015,
                                  color: kGreen,
                                )
                              : reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                              reviewProvider.questions[questionIndex - 1]['question']
                              ['choices'][choiceIndex]['id'] ==
                                  reviewProvider.questions[questionIndex - 1]['choice']['id']
                                  ? Icon(
                                      Icons.close,
                                      size: width * 0.015,
                                      color: kRed,
                                    )
                                  : const SizedBox()
                        ],
                      )),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget multiSectionQuestionWithoutImage(
      width, height, reviewProvider, questionIndex) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomContainer(
        width: width * 0.66,
        height: height*0.55,
        buttonColor: kDarkGray,
        borderRadius: width * 0.005,
        verticalPadding: height * 0.03,
        horizontalPadding: width * 0.01,
        child: ListView(children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*0.01),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height * 0.01),
                  child: SizedBox(
                    width: width * 0.61,
                    child: stringWithLatex(
                        reviewProvider.questions[questionIndex - 1]['question']
                        ['body'],
                        3,
                        width,
                        height,
                        kWhite),
                  ),
                ),
                for (Map subQuestion in reviewProvider.questions[questionIndex - 1]['question']['sub_questions']) ...[
                  SizedBox(height: height * 0.03),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: SizedBox(
                      width: width * 0.61,
                      child: stringWithLatex(
                          subQuestion['body'],
                          3,
                          width,
                          height,
                          kWhite),
                    ),
                  ),
                  if (subQuestion['type'] == 'multipleChoiceQuestion')
                    Column(
                      children: [
                        for (int choiceIndex = 0;
                        choiceIndex < subQuestion['choices'].length;
                        choiceIndex++)
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.02),
                            child: CustomContainer(
                                onTap: null,
                                verticalPadding: 0,
                                height: height*0.08,
                                horizontalPadding: width * 0.02,
                                width: width * 0.61,
                                borderRadius: width * 0.005,
                                border: fullBorder(subQuestion['choices']
                                [choiceIndex]['id'] ==
                                    subQuestion['correct_answer']
                                    ['id']
                                    ? kGreen
                                    :
                                    subQuestion['choices'][choiceIndex]['id'] ==
                                        reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                    ? kRed
                                    : kTransparent),
                                buttonColor:
                                    subQuestion['choices']
                                    [choiceIndex]['id'] ==
                                        reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                    ? kLightPurple
                                    : kGray,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.53,
                                      child: stringWithLatex(
                                          subQuestion['choices']
                                          [choiceIndex]['body'],
                                          3,
                                          width,
                                          height,
                                          kWhite),
                                    ),
                                    subQuestion['choices'][choiceIndex]
                                    ['id'] ==
                                        subQuestion['correct_answer']
                                        ['id']
                                        ? Icon(
                                      Icons.check_rounded,
                                      size: width * 0.015,
                                      color: kGreen,
                                    )
                                        :
                                        subQuestion['choices']
                                        [choiceIndex]['id'] ==
                                            reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                        ? Icon(
                                      Icons.close,
                                      size: width * 0.015,
                                      color: kRed,
                                    )
                                        : const SizedBox()
                                  ],
                                )),
                          ),
                      ],
                    )
                  else if (subQuestion['type'] == 'finalAnswerQuestion')
                    Column(
                      children: [
                        CustomContainer(
                            onTap: null,
                            verticalPadding: 0,
                            horizontalPadding: width * 0.02,
                            width: width * 0.61,
                            height: height*0.08,
                            borderRadius: width * 0.005,
                            border: null,
                            buttonColor: kGray,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * 0.53,
                                  child: stringWithLatex(
                                      reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer'], 3, width, height, kWhite),
                                ),
                                reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['is_correct']
                                    ? Icon(
                                  Icons.check_rounded,
                                  size: width * 0.015,
                                  color: kGreen,
                                )
                                    : Icon(
                                  Icons.close,
                                  size: width * 0.015,
                                  color: kRed,
                                )
                              ],
                            )),
    if (!(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['is_correct']))

    ...[SizedBox(height: height*0.01),CustomContainer(
    onTap: null,
        height: height*0.08,
        verticalPadding: 0,
    horizontalPadding: width * 0.02,
    width: width * 0.61,
    borderRadius: width * 0.005,
    border: null,
    buttonColor: kGray,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    SizedBox(
    width: width * 0.53,
    child: stringWithLatex(
        subQuestion['correct_answer']['body'],
    3,
    width,
    height,
    kWhite),
    ),
    Icon(
    Icons.check_rounded,
    size: width * 0.015,
    color: kGreen,
    )

    ],
    ))]
                      ],
                    ),
                ]
              ],),
            ),
          )
        ],),
      ),
    );
  }

  Widget multiSectionQuestionWithImage(
      width, height, reviewProvider, questionIndex) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CustomContainer(
        width: width * 0.66,
        height: height*0.55,
        buttonColor: kDarkGray,
        borderRadius: width * 0.005,
        verticalPadding: height * 0.03,
        horizontalPadding: width * 0.01,
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.01),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.01),
                      child: SizedBox(
                        width: width * 0.61,
                        child: stringWithLatex(
                            reviewProvider.questions[questionIndex - 1]['question']
                                ['body'],
                            3,
                            width,
                            height,
                            kWhite),
                      ),
                    ),
                    SizedBox(
                      width: width*0.61,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              for (Map subQuestion
                                  in reviewProvider.questions[questionIndex - 1]
                              ['question']['sub_questions']) ...[
                                SizedBox(height: height * 0.03),
                                Padding(
                                  padding: EdgeInsets.only(bottom: height * 0.02),
                                  child: SizedBox(
                                    width: width * 0.3,
                                    child: stringWithLatex(
                                        subQuestion['body'],
                                        3,
                                        width,
                                        height,
                                        kWhite),
                                  ),
                                ),
                                if (subQuestion['type'] ==
                                    'multipleChoiceQuestion')
                                  Column(
                                    children: [
                                      for (int choiceIndex = 0;
                                          choiceIndex <
                                              subQuestion['choices'].length;
                                          choiceIndex++)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: height * 0.02),
                                          child: CustomContainer(
                                              onTap: null,
                                              verticalPadding: 0,
                                              height: height*0.08,
                                              horizontalPadding: width * 0.02,
                                              width: width * 0.3,
                                              borderRadius: width * 0.005,
                                              border: fullBorder(subQuestion
                                                          ['choices'][choiceIndex]['id'] ==
                                                      subQuestion
                                                          ['correct_answer']['id']
                                                  ? kGreen
                                                  :
                                                          subQuestion['choices']
                                                                  [choiceIndex]['id'] ==
                                                              reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                                      ? kRed
                                                      : kTransparent),
                                              buttonColor:
                                                      subQuestion['choices']
                                                              [choiceIndex]['id'] ==
                                                          reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                                  ? kLightPurple
                                                  : kGray,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.22,
                                                    child: stringWithLatex(
                                                        subQuestion['choices']
                                                            [choiceIndex]['body'],
                                                        3,
                                                        width,
                                                        height,
                                                        kWhite),
                                                  ),
                                                  subQuestion['choices']
                                                              [choiceIndex]['id'] ==
                                                          subQuestion
                                                              ['correct_answer']['id']
                                                      ? Icon(
                                                          Icons.check_rounded,
                                                          size: width * 0.015,
                                                          color: kGreen,
                                                        )
                                                      :
                                                              subQuestion
                                                                          ['choices']
                                                                      [choiceIndex]['id'] ==
                                                                  reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer']
                                                          ? Icon(
                                                              Icons.close,
                                                              size: width * 0.015,
                                                              color: kRed,
                                                            )
                                                          : const SizedBox()
                                                ],
                                              )),
                                        ),
                                    ],
                                  )
                                else if (subQuestion['type'] ==
                                    'finalAnswerQuestion')
                                  Column(
                                    children: [
                                      CustomContainer(
                                          onTap: null,
                                          height: height*0.08,
                                          verticalPadding: 0,
                                          horizontalPadding: width * 0.02,
                                          width: width * 0.3,
                                          borderRadius: width * 0.005,
                                          border: null,
                                          buttonColor: kGray,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: width * 0.22,
                                                child: stringWithLatex(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['answer'], 3,
                                                    width, height, kWhite),
                                              ),
                                              reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['is_correct']
                                                  ? Icon(
                                                      Icons.check_rounded,
                                                      size: width * 0.015,
                                                      color: kGreen,
                                                    )
                                                  : Icon(
                                                      Icons.close,
                                                      size: width * 0.015,
                                                      color: kRed,
                                                    )
                                            ],
                                          )),
                                      if (!(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]['is_correct']))
                                        ...[
                                          SizedBox(height: height*0.01),
                                          CustomContainer(
                                              onTap: null,
                                              height: height*0.08,
                                              verticalPadding: 0,
                                              horizontalPadding: width * 0.02,
                                              width: width * 0.3,
                                              borderRadius: width * 0.005,
                                              border: null,
                                              buttonColor: kGray,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width: width * 0.22,
                                                    child: stringWithLatex(subQuestion['correct_answer']['body'], 3,
                                                        width, height, kWhite),
                                                  ),
                                                  Icon(
                                                    Icons.check_rounded,
                                                    size: width * 0.015,
                                                    color: kGreen,
                                                  )

                                                ],
                                              )),
                                        ]
                                    ],
                                  ),
                              ]
                            ],
                          ),
                          SizedBox(width: width * 0.02),
                          SizedBox(
                            height: height * 0.25,
                            child: CustomDivider(
                              dashHeight: 2,
                              dashWidth: width * 0.005,
                              dashColor: kGray.withOpacity(0.9),
                              direction: Axis.vertical,
                              fillRate: 0.7,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Image(
                            image: NetworkImage(reviewProvider.questions[questionIndex - 1]
                                ['question']['image']),
                            height: height * 0.25,
                            width: width * 0.25,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget writingQuestionWithImage(
      width, height, reviewProvider, questionIndex) {
    return CustomContainer(
      width: width * 0.66,

      buttonColor: kDarkGray,
      borderRadius: width * 0.005,
      verticalPadding: height * 0.03,
      horizontalPadding: width * 0.02,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: height * 0.02),
            child: SizedBox(
              width: width * 0.62,
              child: stringWithLatex(
                  reviewProvider.questions[questionIndex - 1]['question']
                  ['body'],
                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          SizedBox(height: height*0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){
                  popUp(
                      context,
                      width * 0.8,
                      height * 0.8,
                      Center(
                        child: Image(
                          image: NetworkImage(reviewProvider.questions[questionIndex - 1]
                          ['answer']),
                          height: height * 0.8,
                          width: width * 0.8,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                      kLightBlack,
                      kDarkBlack,
                      width * 0.01);
                },
                child: Image(
                  image: NetworkImage(reviewProvider.questions[questionIndex - 1]
                  ['answer']),
                  height: height * 0.4,
                  width: width * 0.62,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
    SimilarQuestionsProvider questionProvider = Provider.of<SimilarQuestionsProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);

    return width < height
        ? const RotateYourPhone()
        : websiteProvider.loaded
        ? Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/home_dashboard_background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      const RightBar(),
                      SizedBox(width:width*0.03),
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
                                        SizedBox(
                                            width: width * 0.42,

                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(reviewProvider.quizSubjectName,
                                                  style: textStyle(
                                                      1, width, height, kWhite)),
                                              if (reviewProvider.quizSubjectID!='7376be1e-e252-4d22-874b-9ec129326807' && reviewProvider.quizSubjectID!='2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab')CustomContainer(
                                                onTap: () async{
                                                  reviewProvider
                                                      .setCopied(true);
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: 'https://kawka-b.com/#/Quiz/${reviewProvider.quizID}'));
                                                  Timer(const Duration(seconds: 1),
                                                          () {
                                                            reviewProvider
                                                            .setCopied(false);
                                                      });
                                                },
                                                buttonColor: kTransparent,
                                                border: fullBorder(kLightPurple),
                                                borderRadius: width,
                                                    height: height*0.06,
                                                  width: width*0.12,
                                                  child:Text(reviewProvider.copied ?"تم النسخ":"شارك الامتحان",
                                                    style: textStyle(
                                                        3, width, height, kLightPurple))
                                                // Icon(
                                                //   reviewProvider.copied ?Icons.copy:Icons.share_rounded,
                                                //   size: width * 0.02,
                                                //   color: kLightPurple,
                                                // ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            CustomContainer(
                                                width: width * 0.2,
                                                height: height * 0.19,
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
                                                            'حصلت على ${reviewProvider.correctQuestionsNum} من أصل ${reviewProvider.questionsNum} علامات',
                                                            style: textStyle(
                                                                4,
                                                                width,
                                                                height,
                                                                kWhite)),
                                                        CircularChart(
                                                          width:
                                                              width * 0.035,
                                                          label: double.parse((100 *
                                                                  reviewProvider
                                                                      .correctQuestionsNum /
                                                              reviewProvider.questionsNum)
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
                                                height: height * 0.185,
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
                                                      children:reviewProvider.quizTime=='null'?[
                                                        Text(
                                                            'أنهيت الامتحان ب${toDuration(reviewProvider.quizAttemptTime).inMinutes} دقائق\nمن أصل ${toDuration(reviewProvider.quizIdealTime).inMinutes} دقائق كوقت مثالي',
                                                            style: textStyle(
                                                                4,
                                                                width,
                                                                height,
                                                                kWhite)),
                                                        CircularChart(
                                                          width:
                                                          width * 0.035,
                                                          label: double.parse((100 *
                                                              toDuration(reviewProvider.quizAttemptTime).inMinutes /
                                                              toDuration(reviewProvider
                                                                  .quizIdealTime)
                                                                  .inMinutes)
                                                              .toStringAsFixed(
                                                              1)),
                                                          inActiveColor:
                                                          kWhite,
                                                          labelColor:
                                                          kWhite,
                                                        )

                                                      ]: [
                                                        Text(
                                                            'أنهيت الامتحان ب${toDuration(reviewProvider.quizAttemptTime).inMinutes} دقائق\nمن أصل ${toDuration(reviewProvider.quizTime).inMinutes} دقائق',
                                                            style: textStyle(
                                                                4,
                                                                width,
                                                                height,
                                                                kWhite)),
                                                        CircularChart(
                                                          width:
                                                              width * 0.035,
                                                          label: double.parse((100 *
                                                              toDuration(reviewProvider.quizAttemptTime).inMinutes /
                                                                  toDuration(reviewProvider
                                                                              .quizTime)
                                                                      .inMinutes)
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
                                              mainScrollController
                                                  .animateTo(
                                                mainScrollController
                                                    .position
                                                    .maxScrollExtent,
                                                duration: const Duration(
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
                                        const SizedBox(),
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
                                                height: height * 0.3,
                                                child: ListView(
                                                  children: [
                                                    Wrap(
                                                      spacing:
                                                          width * 0.005,
                                                      runSpacing:
                                                          height * 0.01,
                                                      children: [
                                                        for (MapEntry skill
                                                            in reviewProvider
                                                                .skills
                                                                .entries)
                                                          Stack(
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                            children: [
                                                              CustomContainer(
                                                                onTap: null,
                                                                width: width *
                                                                        0.055 +
                                                                    (skill.key.length *
                                                                        fontWidth(
                                                                            5,
                                                                            width,
                                                                            height)),
                                                                height:
                                                                    height *
                                                                        0.05,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                border:
                                                                    null,
                                                                buttonColor:
                                                                    kDarkGray,
                                                                child: Row(
                                                                  children: [
                                                                    CustomContainer(
                                                                        onTap:
                                                                            null,
                                                                        width: (width * 0.055 + (skill.key.length * fontWidth(5, width, height))) *
                                                                            skill.value['correct'] /
                                                                            skill.value['all'],
                                                                        height: height * 0.05,
                                                                        borderRadius: width * 0.005,
                                                                        border: null,
                                                                        buttonColor: kOrange,
                                                                        child: null),
                                                                  ],
                                                                ),
                                                              ),
                                                              CustomContainer(
                                                                onTap: null,
                                                                width: width *
                                                                        0.055 +
                                                                    (skill.key.length *
                                                                        fontWidth(
                                                                            5,
                                                                            width,
                                                                            height)),
                                                                verticalPadding:
                                                                    height *
                                                                        0.02,
                                                                horizontalPadding:
                                                                    width *
                                                                        0.01,
                                                                borderRadius:
                                                                    0,
                                                                border:
                                                                    null,
                                                                buttonColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      skill
                                                                          .key,
                                                                      style: textStyle(
                                                                          5,
                                                                          width,
                                                                          height,
                                                                          kWhite),
                                                                    ),
                                                                    Text(
                                                                      "${(100 * skill.value['correct'] / skill.value['all']).round()}%",
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
                                        const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            Directionality(
                              textDirection: reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807'?TextDirection.ltr:TextDirection.rtl,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Stack(
                                    children: [
                                      CustomContainer(
                                          width: width * 0.9,
                                          height: height * 0.4),
                                      Row(
                                        children: [
                                          if (reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807')
                                            SizedBox(width:width*0.03),
                                          CustomContainer(
                                              width: width * 0.7,
                                              height: height * 0.42,
                                              onTap: null,
                                            verticalPadding:
                                            height *
                                                0.02,
                                            horizontalPadding:
                                            width *
                                                0.02,
                                              borderRadius: width * 0.005,
                                              border: null,
                                              buttonColor: kDarkGray,
                                              child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,crossAxisAlignment:CrossAxisAlignment.start,children:[
                                                if (reviewProvider.quizSubjectID!='7376be1e-e252-4d22-874b-9ec129326807' && reviewProvider.quizSubjectID!='2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab')
                                                const SizedBox(),
                                                      SizedBox(
                                                        width: width * 0.7,
                                                        child: Column(

                                                            crossAxisAlignment:CrossAxisAlignment.start,children:[
                                                          Text(reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807'?'Some Advices':'تحليل اداءك:',
                                                          style: textStyle(
                                                              2,
                                                              width,
                                                              height,
                                                              kWhite),),
                                                          SizedBox(height:height*0.01),
                                                          for (String statement in reviewProvider.statements) Padding(
                                                          padding: EdgeInsets.only(right:width *
                                                              0.01),
                                                          child: Text('• $statement',
                                                            style: textStyle(
                                                                reviewProvider.quizSubjectID!='7376be1e-e252-4d22-874b-9ec129326807' && reviewProvider.quizSubjectID!='2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab'?4:3,
                                                                width,
                                                                height,
                                                                kWhite),),
                                                        )]),
                                                      ),
                                                if (reviewProvider.quizSubjectID!='7376be1e-e252-4d22-874b-9ec129326807' && reviewProvider.quizSubjectID!='2d3ce0b6-c7b5-4b47-a344-ec1f36a077ab')
                                                  Row(children:[
                                                  Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                                                Text('لتزيد سرعتك في الحل مرن نفسك أكثر من خلال حل اسئلة أو امتحانات شبيهة',
                                                  style: textStyle(
                                                      3,
                                                      width,
                                                      height,
                                                      kWhite),),
                                                Text('يمكنك إعادة الإمتحان لتتأكد من اتقانك ما أخطأت به',
                                                  style: textStyle(
                                                      3,
                                                      width,
                                                      height,
                                                      kWhite),),
                                                Text('قريباً ستتمكن من الاطلاع على التحليلات المتعلقة بالمادة لترصد نتائج أداءك',
                                                  style: textStyle(
                                                      3,
                                                      width,
                                                      height,
                                                      kWhite),)
                                              ]),
                                                  SizedBox(width:width*0.05),
                                                    Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                                                    CustomContainer(
                                                      onTap: () {
                                                        retakeQuiz(quizProvider, reviewProvider);
                                                      },
                                                      width:width*0.085,
                                                      height:height*0.06,
                                                      verticalPadding:0,
                                                      horizontalPadding:
                                                      width *
                                                          0.01,
                                                      borderRadius:
                                                      width *
                                                          0.005,
                                                      border:
                                                      null,
                                                      buttonColor:
                                                      kLightPurple,
                                                      child:
                                                      Center(
                                                        child: Text(
                                                            'اعادة الامتحان',
                                                            style: textStyle(
                                                                3,
                                                                width,
                                                                height,
                                                                kDarkBlack)),
                                                      ),
                                                    ),
                                                SizedBox(height:height*0.02),
                                                    CustomContainer(
                                                      onTap: () {
                                                        similarQuiz(quizProvider, reviewProvider);
                                                      },
                                                      width:width*0.085,
                                                      height:height*0.06,
                                                      verticalPadding:0,
                                                      horizontalPadding:
                                                      width *
                                                          0.01,
                                                      borderRadius:
                                                      width *
                                                          0.005,
                                                      border:
                                                      null,
                                                      buttonColor:
                                                      kLightPurple,
                                                      child:
                                                      Center(
                                                        child: Text(
                                                            'امتحان شبيه',
                                                            style: textStyle(
                                                                3,
                                                                width,
                                                                height,
                                                                kDarkBlack)),
                                                      ),
                                                    ),]),]),
                                                const SizedBox(),]),),
                                        ],
                                      ),
                                      Positioned(
                                        left: reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807'?null:0,
                                        right: reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807'?0:null,
                                        bottom: 0,
                                        child: Image(
                                          image: const AssetImage(
                                              'images/advises.png'),
                                          width: width * 0.35,
                                          height: height * 0.38,
                                          fit: BoxFit.contain,
                                          alignment: reviewProvider.quizSubjectID=='7376be1e-e252-4d22-874b-9ec129326807'?Alignment.bottomRight:Alignment.bottomLeft,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            SizedBox(
                              height: height,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Text('الأسئلة',
                                                style: textStyle(3, width,
                                                    height, kWhite)),
                                            Row(
                                              children: [
                                                CustomContainer(
                                                    onTap: () {
                                                      reviewProvider
                                                                  .questionIndex ==
                                                              reviewProvider
                                                                  .questions
                                                                  .length
                                                          ? {
                                                              reviewProvider
                                                                  .setQuestionIndex(
                                                                      1),
                                                              questionsScrollController
                                                                  .jumpTo(
                                                                0,
                                                              )
                                                            }
                                                          : {
                                                              questionsScrollController
                                                                  .animateTo(
                                                                reviewProvider
                                                                        .questionIndex *
                                                                    height,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        500),
                                                                curve: Curves
                                                                    .easeOut,
                                                              ),
                                                              reviewProvider
                                                                  .setQuestionIndex(
                                                                      reviewProvider.questionIndex +
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
                                                      reviewProvider
                                                                  .questionIndex ==
                                                              1
                                                          ? {
                                                              reviewProvider.setQuestionIndex(
                                                                  reviewProvider
                                                                      .questions
                                                                      .length),
                                                              questionsScrollController
                                                                  .jumpTo(
                                                                (reviewProvider.questionIndex -
                                                                        1) *
                                                                    height,
                                                              ),
                                                            }
                                                          : {
                                                              reviewProvider
                                                                  .setQuestionIndex(
                                                                      reviewProvider.questionIndex -
                                                                          1),
                                                              questionsScrollController
                                                                  .animateTo(
                                                                (reviewProvider.questionIndex -
                                                                        1) *
                                                                    height,
                                                                duration: const Duration(
                                                                    milliseconds:
                                                                        500),
                                                                curve: Curves
                                                                    .easeOut,
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
                                        height: height * 0.82,
                                        width: width * 0.18,
                                        child: Theme(
                                            data:
                                                Theme.of(context).copyWith(
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                minThumbLength: 1,
                                                mainAxisMargin: 0,
                                                crossAxisMargin: 0,
                                                radius: Radius.circular(
                                                    width * 0.005),
                                                thumbVisibility:
                                                    MaterialStateProperty
                                                        .all<bool>(true),
                                                trackVisibility:
                                                    MaterialStateProperty
                                                        .all<bool>(true),
                                                thumbColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                            kLightPurple),
                                                trackColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                            kDarkGray),
                                                trackBorderColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                            kTransparent),
                                              ),
                                            ),
                                            child: Directionality(
                                              textDirection:
                                                  TextDirection.ltr,
                                              child: ListView(
                                                children: [
                                                  for (int i = 1;
                                                      i <=
                                                          reviewProvider
                                                              .questions
                                                              .length;
                                                      i++) ...[
                                                    Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.02),
                                                        child:
                                                            CustomContainer(
                                                                onTap: () {
                                                                  reviewProvider
                                                                      .setQuestionIndex(
                                                                          i);
                                                                  questionsScrollController
                                                                      .jumpTo(
                                                                    (reviewProvider.questionIndex -
                                                                            1) *
                                                                        height,
                                                                  );
                                                                },
                                                                height: height *
                                                                    0.06,
                                                                verticalPadding:0,
                                                                horizontalPadding:
                                                                    width *
                                                                        0.02,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                border:
                                                                    null,
                                                                buttonColor: reviewProvider.questionIndex ==
                                                                        i
                                                                    ? kPurple
                                                                    : kDarkGray,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        'سؤال #$i',
                                                                        style: textStyle(
                                                                            4,
                                                                            width,
                                                                            height,
                                                                            kWhite)),
                                                                    reviewProvider.questions[i - 1]['is_correct']
                                                                        ? Icon(
                                                                            Icons.check_rounded,
                                                                            size: width * 0.015,
                                                                            color: kGreen,
                                                                          )
                                                                        : Icon(
                                                                            Icons.close,
                                                                            size: width * 0.015,
                                                                            color: kRed,
                                                                          )
                                                                  ],
                                                                )),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            height * 0.01),
                                                  ]
                                                ],
                                              ),
                                            )),
                                      ),
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
                                    height: height,
                                    width: width * 0.7,
                                    child: Theme(
                                        data: Theme.of(context).copyWith(
                                          scrollbarTheme:
                                              ScrollbarThemeData(
                                            minThumbLength: 1,
                                            mainAxisMargin: height * 0.02,
                                            crossAxisMargin: 0,
                                            radius: Radius.circular(
                                                width * 0.005),
                                            thumbVisibility:
                                                MaterialStateProperty.all<
                                                    bool>(true),
                                            trackVisibility:
                                                MaterialStateProperty.all<
                                                    bool>(true),
                                            thumbColor:
                                                MaterialStateProperty.all<
                                                    Color>(kLightPurple),
                                            trackColor:
                                                MaterialStateProperty.all<
                                                    Color>(kDarkGray),
                                            trackBorderColor:
                                                MaterialStateProperty.all<
                                                    Color>(kTransparent),
                                          ),
                                        ),
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: ListView(
                                            physics: reviewProvider
                                                    .questionScrollState
                                                ? const ScrollPhysics()
                                                : const NeverScrollableScrollPhysics(),
                                            controller:
                                                questionsScrollController,
                                            children: [
                                              for (int questionIndex = 1;
                                                  questionIndex <=
                                                      reviewProvider
                                                          .questions.length;
                                                  questionIndex++) ...[
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                            horizontal:
                                                                width *
                                                                    0.02),
                                                    child: SizedBox(
                                                      width: width * 0.66,
                                                      height: height,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.02),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'سؤال #$questionIndex',
                                                                  style: textStyle(
                                                                      3,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                              if (reviewProvider.questions[questionIndex -1]['question']['type'] !='writingQuestion')
                                                                Row(
                                                                children: [
                                                                  CustomContainer(
                                                                    onTap: () {
                                                                      questionProvider.setQuestionId(reviewProvider
                                                                              .questions[
                                                                          questionIndex -
                                                                              1]['question']['id']);
                                                                      websiteProvider
                                                                          .setLoaded(
                                                                              false);
                                                                      context.pushReplacement('/Question');
                                                                    },
                                                                    verticalPadding:0,
                                                                    height:height*0.06,

                                                                    horizontalPadding:
                                                                        width *
                                                                            0.02,
                                                                    borderRadius:
                                                                        width *
                                                                            0.005,
                                                                    border:
                                                                        null,
                                                                    buttonColor:
                                                                        kLightPurple,
                                                                    child:
                                                                        Center(
                                                                      child: Text(
                                                                          'تمرن أكثر بحل أسئلة شبيهه لهذا السؤال',
                                                                          style: textStyle(
                                                                              3,
                                                                              width,
                                                                              height,
                                                                              kDarkBlack)),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width:width*0.01),
                                                                  CustomContainer(
                                                                    onTap: () async{
                                                                      reviewProvider
                                                                          .setCopied(true);
                                                                      await Clipboard.setData(
                                                                          ClipboardData(
                                                                              text: 'https://kawka-b.com/#/SharedQuestion/${reviewProvider.questions[questionIndex -1]['question']['id']}'));
                                                                      Timer(const Duration(seconds: 1),
                                                                              () {
                                                                            reviewProvider
                                                                                .setCopied(false);
                                                                          });
                                                                    },
                                                                    verticalPadding:0,
                                                                    height:height*0.06,

                                                                    horizontalPadding:
                                                                    width *
                                                                        0.001,
                                                                    borderRadius:
                                                                    width *
                                                                        0.005,
                                                                    border:
                                                                    null,
                                                                    buttonColor:
                                                                    kLightPurple,
                                                                    child:
                                                                    Icon(
                                                                      reviewProvider.copied ?Icons.copy:Icons.share_rounded,
                                                                      size: width * 0.02,
                                                                      color: kDarkBlack,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.01),
                                                                                                                  if (reviewProvider.questions[questionIndex - 1]
                                                                                                                                    [
                                                                                                                                    'question']
                                                                                                                                [
                                                                                                                                'image'] !=
                                                                                                                            null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                                    1]['question']
                                                                                                                                [
                                                                                                                                'type'] ==
                                                                                                                            'multipleChoiceQuestion')
                                                                                                                      multipleChoiceQuestionWithImage(
                                                                                                                          width,
                                                                                                                          height,
                                                                                                                          reviewProvider,
                                                                                                                          questionIndex)
                                                                                                                    else if (reviewProvider.questions[questionIndex - 1]
                                                                                                                                    [
                                                                                                                                    'question']
                                                                                                                                [
                                                                                                                                'image'] ==
                                                                                                                            null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                                    1]['question']
                                                                                                                                [
                                                                                                                                'type'] ==
                                                                                                                            'multipleChoiceQuestion')
                                                                                                                      multipleChoiceQuestionWithoutImage(
                                                                                                                          width,
                                                                                                                          height,
                                                                                                                          reviewProvider,
                                                                                                                          questionIndex)
                                                                                                                    else if (reviewProvider.questions[questionIndex - 1]
                                                                                                                                    [
                                                                                                                                    'question']
                                                                                                                                [
                                                                                                                                'image'] ==
                                                                                                                            null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                                    1]['question']
                                                                                                                                [
                                                                                                                                'type'] ==
                                                                                                                            'finalAnswerQuestion')
                                                                                                                      finalAnswerQuestionWithoutImage(
                                                                                                                          width,
                                                                                                                          height,
                                                                                                                          reviewProvider,
                                                                                                                          questionIndex)
                                                                                                                    else if (reviewProvider.questions[questionIndex - 1]
                                                                                                                                    [
                                                                                                                                    'question']
                                                                                                                                [
                                                                                                                                'image'] !=
                                                                                                                            null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                                    1]['question']
                                                                                                                                [
                                                                                                                                'type'] ==
                                                                                                                            'finalAnswerQuestion')
                                                                                                                      finalAnswerQuestionWithImage(
                                                                                                                          width,
                                                                                                                          height,
                                                                                                                          reviewProvider,
                                                                                                                          questionIndex)
                                                                                                                    else if (reviewProvider.questions[questionIndex - 1]
                                                                                                                    [
                                                                                                                    'question']
                                                                                                                    [
                                                                                                                    'image'] ==
                                                                                                                        null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                            1]['question']
                                                                                                                        [
                                                                                                                        'type'] ==
                                                                                                                            'multiSectionQuestion')
                                                                                                                          multiSectionQuestionWithoutImage(
                                                                                                                              width, height, reviewProvider, questionIndex)
                                                          else if (reviewProvider.questions[questionIndex - 1]
                                                                                                                    [
                                                                                                                    'question']
                                                                                                                    [
                                                                                                                    'image'] !=
                                                                                                                        null &&
                                                                                                                        reviewProvider.questions[questionIndex -
                                                                                                                            1]['question']
                                                                                                                        [
                                                                                                                        'type'] ==
                                                                                                                            'multiSectionQuestion')
                                                                                                                          multiSectionQuestionWithImage(
                                                                                                                              width, height, reviewProvider, questionIndex)
                                                                                                                        else if(reviewProvider.questions[questionIndex -1]['question']['type'] =='writingQuestion')
                                                                                                                          writingQuestionWithImage(width, height, reviewProvider, questionIndex),
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.04),
                                                          Stack(
                                                            alignment:
                                                                Alignment
                                                                    .center,
                                                            children: [
                                                              if (toDuration(reviewProvider.questions[questionIndex - 1]
                                                                          [
                                                                          'duration'])
                                                                      .inSeconds >
                                                                  toDuration(reviewProvider.questions[questionIndex - 1]['question']
                                                                          [
                                                                          'idealDuration'])
                                                                      .inSeconds) ...[
                                                                SizedBox(
                                                                  width: width *
                                                                      0.35,
                                                                  height:
                                                                      height *
                                                                          0.15,
                                                                ),
                                                                Positioned(
                                                                  top: height *
                                                                          0.075 +
                                                                      height *
                                                                          0.01,
                                                                  child:
                                                                      CustomContainer(
                                                                    width: width *
                                                                        0.25,
                                                                    height: height *
                                                                        0.01,
                                                                    buttonColor:
                                                                        kGreen,
                                                                    borderRadius:
                                                                        width *
                                                                            0.005,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment.centerRight,
                                                                      child:
                                                                          CustomContainer(
                                                                        width: width *
                                                                            0.25 *
                                                                            max(0.4, (1 - (10 * toDuration(reviewProvider.questions[questionIndex - 1]['question']['idealDuration']).inSeconds / toDuration(reviewProvider.questions[questionIndex - 1]['duration']).inSeconds).round() / 10)),
                                                                        height:
                                                                            height * 0.01,
                                                                        buttonColor:
                                                                            kRed,
                                                                        borderRadius:
                                                                            width * 0.005,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child:
                                                                      Row(
                                                                    children: [
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.1,
                                                                        height:
                                                                            height * 0.15,
                                                                        borderRadius:
                                                                            0,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('الوقت المستهلك على\nالسؤال', textAlign: TextAlign.center, style: textStyle(5, width, height, kWhite)),
                                                                            Image(
                                                                              image: const AssetImage('images/clock_imoji.png'),
                                                                              fit: BoxFit.contain,
                                                                              height: height * 0.03,
                                                                              width: width * 0.03,
                                                                            ),
                                                                            CustomContainer(width: width * 0.05, height: height * 0.03, buttonColor: kGray, borderRadius: width * 0.005, child: Text(reviewProvider.questions[questionIndex - 1]['duration'], style: textStyle(4, width, height, kWhite)))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.25 * max(0.4, (1 - (10 * toDuration(reviewProvider.questions[questionIndex - 1]['question']['idealDuration']).inSeconds / toDuration(reviewProvider.questions[questionIndex - 1]['duration']).inSeconds).round() / 10)) - width * 0.1,
                                                                        height:
                                                                            height * 0.01,
                                                                      ),
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.1,
                                                                        height:
                                                                            height * 0.15,
                                                                        borderRadius:
                                                                            0,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('الوقت المقترح للإنتهاء من\nالسؤال', textAlign: TextAlign.center, style: textStyle(5, width, height, kWhite)),
                                                                            Image(
                                                                              image: const AssetImage('images/clock_imoji.png'),
                                                                              fit: BoxFit.contain,
                                                                              height: height * 0.03,
                                                                              width: width * 0.03,
                                                                            ),
                                                                            CustomContainer(width: width * 0.05, height: height * 0.03, buttonColor: kGray, borderRadius: width * 0.005, child: Text(reviewProvider.questions[questionIndex - 1]['question']['idealDuration'], style: textStyle(4, width, height, kWhite)))
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]
                                                              else ...[
                                                                SizedBox(
                                                                  width: width *
                                                                      0.35,
                                                                  height:
                                                                      height *
                                                                          0.15,
                                                                ),
                                                                Positioned(
                                                                  top: height *
                                                                          0.075 +
                                                                      height *
                                                                          0.01,
                                                                  child:
                                                                      CustomContainer(
                                                                    width: width *
                                                                        0.25,
                                                                    height: height *
                                                                        0.01,
                                                                    buttonColor:
                                                                        kLightPurple,
                                                                    borderRadius:
                                                                        width *
                                                                            0.005,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment.centerRight,
                                                                      child:
                                                                          CustomContainer(
                                                                        width: width *
                                                                            0.25 *
                                                                            max(0.4, (1 - (10 * toDuration(reviewProvider.questions[questionIndex - 1]['duration']).inSeconds / toDuration(reviewProvider.questions[questionIndex - 1]['question']['idealDuration']).inSeconds).round() / 10)),
                                                                        height:
                                                                            height * 0.01,
                                                                        buttonColor:
                                                                            kGreen,
                                                                        borderRadius:
                                                                            width * 0.005,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child:
                                                                      Row(
                                                                    children: [
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.1,
                                                                        height:
                                                                            height * 0.15,
                                                                        borderRadius:
                                                                            0,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('الوقت المقترح للإنتهاء من\nالسؤال', textAlign: TextAlign.center, style: textStyle(5, width, height, kWhite)),
                                                                            Image(
                                                                              image: const AssetImage('images/clock_imoji.png'),
                                                                              fit: BoxFit.contain,
                                                                              height: height * 0.03,
                                                                              width: width * 0.03,
                                                                            ),
                                                                            CustomContainer(width: width * 0.05, height: height * 0.03, buttonColor: kGray, borderRadius: width * 0.005, child: Text(reviewProvider.questions[questionIndex - 1]['question']['idealDuration'], style: textStyle(4, width, height, kWhite)))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.25 * max(0.4, (1 - (10 * toDuration(reviewProvider.questions[questionIndex - 1]['duration']).inSeconds / toDuration(reviewProvider.questions[questionIndex - 1]['question']['idealDuration']).inSeconds).round() / 10)) - width * 0.1,
                                                                        height:
                                                                            height * 0.01,
                                                                      ),
                                                                      CustomContainer(
                                                                        width:
                                                                            width * 0.1,
                                                                        height:
                                                                            height * 0.15,
                                                                        borderRadius:
                                                                            0,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text('الوقت المستهلك على\nالسؤال', textAlign: TextAlign.center, style: textStyle(5, width, height, kWhite)),
                                                                            Image(
                                                                              image: const AssetImage('images/clock_imoji.png'),
                                                                              fit: BoxFit.contain,
                                                                              height: height * 0.03,
                                                                              width: width * 0.03,
                                                                            ),
                                                                            CustomContainer(width: width * 0.05, height: height * 0.03, buttonColor: kGray, borderRadius: width * 0.005, child: Text(reviewProvider.questions[questionIndex - 1]['duration'], style: textStyle(4, width, height, kWhite)))
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.03),
                                                          if(reviewProvider.questions[questionIndex -1]['question']['type'] !='writingQuestion')
                                                          ...[SizedBox(
                                                            width: width *
                                                                0.66,
                                                            child:
                                                                CustomDivider(
                                                              dashHeight: 2,
                                                              dashWidth:
                                                                  width *
                                                                      0.005,
                                                              dashColor: kDarkGray
                                                                  .withOpacity(
                                                                      0.6),
                                                              direction: Axis
                                                                  .horizontal,
                                                              fillRate: 1,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.02),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  'طريقة الحل',
                                                                  style: textStyle(
                                                                      3,
                                                                      width,
                                                                      height,
                                                                      kWhite)),
                                                              SizedBox(
                                                                  width: width *
                                                                      0.01),
                                                              CustomContainer(
                                                                onTap: () {
                                                                  popUp(
                                                                      context,
                                                                      width *
                                                                          0.65,
                                                                      height *
                                                                          0.38,
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text('طريقة الحل #1', style: textStyle(2, width, height, kWhite)),
                                                                              CustomContainer(
                                                                                onTap: () {
                                                                                  context.pop();
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.close,
                                                                                  size: width * 0.02,
                                                                                  color: kWhite,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(height: height * 0.02),
                                                                          CustomContainer(
                                                                            width: width * 0.65,
                                                                            height: height * 0.3,
                                                                            verticalPadding: height * 0.03,
                                                                            horizontalPadding: width * 0.02,
                                                                            buttonColor: kDarkGray,
                                                                            borderRadius: width * 0.005,
                                                                            child: Align(
                                                                              alignment: Alignment.topRight,
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
                                                                verticalPadding:0,
                                                                height:height*0.06,
                                                                horizontalPadding:
                                                                    width *
                                                                        0.03,
                                                                borderRadius:
                                                                    width *
                                                                        0.005,
                                                                border:
                                                                    null,
                                                                buttonColor:
                                                                    kLightPurple,
                                                                child:
                                                                    Center(
                                                                  child: Text(
                                                                      'طريقة #1',
                                                                      style: textStyle(
                                                                          3,
                                                                          width,
                                                                          height,
                                                                          kDarkBlack)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  height *
                                                                      0.03),]
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        )),
                                  ),
                                  const SizedBox()
                                ],
                              ),
                            )
                          ],
                        ),
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
