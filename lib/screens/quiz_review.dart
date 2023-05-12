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
      'quiz_id': Provider.of<ReviewProvider>(context, listen: false).quizID
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuizSubject(result['quiz_subject']),
              Provider.of<ReviewProvider>(context, listen: false)
                  .setQuizTime(result['quiz_duration']),

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

  double fontWidth(fontOption, width, height) {
    final textPainter = TextPainter(
      text: TextSpan(
          text: 'مهارة', style: textStyle(fontOption, width, height, kWhite)),
      textDirection: TextDirection.rtl,
    );
    textPainter.layout();
    return textPainter.computeLineMetrics()[0].width / 5;
  }

  bool checkAnswer(reviewProvider, questionIndex) {
    if (reviewProvider.questions[questionIndex - 1]['question']['type'] ==
        'multipleChoiceQuestion') {
      return reviewProvider.questions[questionIndex - 1]['choice'] != null &&
          reviewProvider.questions[questionIndex - 1]['question']
                  ['correct_answer']['id'] ==
              reviewProvider.questions[questionIndex - 1]['choice']['id'];
    } else if (reviewProvider.questions[questionIndex - 1]['question']
            ['type'] ==
        'finalAnswerQuestion') {
      return reviewProvider.questions[questionIndex - 1]['body'] != null &&
          reviewProvider.questions[questionIndex - 1]['question']
                  ['correct_answer']['body'] ==
              reviewProvider.questions[questionIndex - 1]['body'];
    }else if (reviewProvider.questions[questionIndex - 1]['question']
    ['type'] ==
        'multiSectionQuestion') {
      bool correctAnswer = true;
      for (Map question in reviewProvider.questions[questionIndex - 1]['question']['sub_questions']){
        if (question['type']=='finalAnswerQuestion') {
          correctAnswer = correctAnswer && question['correct_answer']['body']==reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][question['id']];
        }else if(question['type']=='multipleChoiceQuestion'){
          correctAnswer = correctAnswer && question['correct_answer']['id']==reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][question['id']];
        }
      }
      return correctAnswer;
    } else {
      return false;
    }
  }

  int choiceState(reviewProvider, questionIndex, choiceIndex) {
    /// 1 if its the correct answer
    /// 2 if its selected and its incorrect answer
    /// 3 if it is not selected
    return reviewProvider.questions[questionIndex - 1]['question']['choices']
                [choiceIndex]['id'] ==
            reviewProvider.questions[questionIndex - 1]['question']
                ['correct_answer']['id']
        ? 1
        : reviewProvider.questions[questionIndex - 1]['choice'] != null &&
                reviewProvider.questions[questionIndex - 1]['question']
                        ['choices'][choiceIndex]['id'] ==
                    reviewProvider.questions[questionIndex - 1]['choice']['id']
            ? 2
            : 3;
  }

  bool isSelected(reviewProvider, questionIndex, choiceIndex) {
    return reviewProvider.questions[questionIndex - 1]['choice'] != null &&
        reviewProvider.questions[questionIndex - 1]['question']['choices']
                [choiceIndex]['id'] ==
            reviewProvider.questions[questionIndex - 1]['choice']['id'];
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
                  // width * 0.61,
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
      verticalPadding: height * 0.03,
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
          checkAnswer(reviewProvider, questionIndex)
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
    if (!checkAnswer(reviewProvider, questionIndex))

      ...[SizedBox(height: height*0.01),CustomContainer(
          onTap: null,
          verticalPadding: height * 0.03,
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
                height: height * 0.35,
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
                height: height * 0.35,
                width: width * 0.3,
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
                  // width * 0.61,
                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          SizedBox(height: height*0.01),
          CustomContainer(
              onTap: null,
              verticalPadding: height * 0.03,
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
                        reviewProvider.questions[questionIndex - 1]['body'],
                        3,
                        width,
                        height,
                        kWhite),
                  ),
                  checkAnswer(reviewProvider, questionIndex)
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
          if (!checkAnswer(reviewProvider, questionIndex))

            ...[SizedBox(height: height*0.01),CustomContainer(
                onTap: null,
                verticalPadding: height * 0.03,
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
                  // width * 0.61,
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
                          verticalPadding: height * 0.02,
                          horizontalPadding: width * 0.02,
                          width: width * 0.3,
                          borderRadius: width * 0.005,
                          border: fullBorder(choiceState(reviewProvider,
                                      questionIndex, choiceIndex) ==
                                  1
                              ? kGreen
                              : choiceState(reviewProvider, questionIndex,
                                          choiceIndex) ==
                                      2
                                  ? kRed
                                  : kTransparent),
                          buttonColor: isSelected(
                                  reviewProvider, questionIndex, choiceIndex)
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
                              choiceState(reviewProvider, questionIndex,
                                          choiceIndex) ==
                                      1
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: width * 0.015,
                                      color: kGreen,
                                    )
                                  : choiceState(reviewProvider, questionIndex,
                                              choiceIndex) ==
                                          2
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
                  // width * 0.61,
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
                          verticalPadding: height * 0.02,
                          horizontalPadding: width * 0.02,
                          width: width * 0.61,
                          borderRadius: width * 0.005,
                          border: fullBorder(choiceState(reviewProvider,
                                      questionIndex, choiceIndex) ==
                                  1
                              ? kGreen
                              : choiceState(reviewProvider, questionIndex,
                                          choiceIndex) ==
                                      2
                                  ? kRed
                                  : kTransparent),
                          buttonColor: isSelected(
                                  reviewProvider, questionIndex, choiceIndex)
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
                              choiceState(reviewProvider, questionIndex,
                                          choiceIndex) ==
                                      1
                                  ? Icon(
                                      Icons.check_rounded,
                                      size: width * 0.015,
                                      color: kGreen,
                                    )
                                  : choiceState(reviewProvider, questionIndex,
                                              choiceIndex) ==
                                          2
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
        height: height*0.6,
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
                        // width * 0.61,
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
                          // width * 0.61,
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
                                verticalPadding: height * 0.02,
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
                                        reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
                                    ? kRed
                                    : kTransparent),
                                buttonColor:
                                    subQuestion['choices']
                                    [choiceIndex]['id'] ==
                                        reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
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
                                            reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
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
                            verticalPadding: height * 0.02,
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

                                      reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']], 3, width, height, kWhite),
                                ),
                                reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']] ==
                                    subQuestion['correct_answer']['body']
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
    if (!(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']] ==
        subQuestion['correct_answer']['body']))

    ...[SizedBox(height: height*0.01),CustomContainer(
    onTap: null,
    verticalPadding: height * 0.02,
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
        height: height*0.6,
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
                            // width * 0.61,
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
                                        // width * 0.61,
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
                                              verticalPadding: height * 0.02,
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
                                                              reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
                                                      ? kRed
                                                      : kTransparent),
                                              buttonColor:
                                                      subQuestion['choices']
                                                              [choiceIndex]['id'] ==
                                                          reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
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
                                                                  reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']]
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
                                          verticalPadding: height * 0.02,
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
                                                child: stringWithLatex(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']], 3,
                                                    width, height, kWhite),
                                              ),
                                              reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']] ==
                                                      subQuestion['correct_answer']
                                                          ['body']
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
                                      if (!(reviewProvider.questions[questionIndex - 1]['sub_questions_answers'][subQuestion['id']] ==
                                          subQuestion['correct_answer']['body']))
                                        ...[
                                          SizedBox(height: height*0.01),
                                          CustomContainer(
                                              onTap: null,
                                              verticalPadding: height * 0.02,
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
                            height: height * 0.3,
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
                            height: height * 0.3,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    QuestionProvider quizProvider = Provider.of<QuestionProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);

    return websiteProvider.loaded
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
                                            Text(reviewProvider.quizSubject,
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
                                                                'أنهيت الامتحان ب${Duration(seconds: reviewProvider.questions.fold(0, (prev, curr) => prev + toDuration(curr['duration']).inSeconds)).inMinutes} دقائق\nمن أصل ${toDuration(reviewProvider.quizTime == null ? '00:00:00' : reviewProvider.quizTime).inMinutes}',
                                                                style: textStyle(
                                                                    4,
                                                                    width,
                                                                    height,
                                                                    kWhite)),
                                                            CircularChart(
                                                              width:
                                                                  width * 0.035,
                                                              label: double.parse((100 *
                                                                      reviewProvider.questions.fold(
                                                                          0,
                                                                          (prev, curr) =>
                                                                              prev +
                                                                              toDuration(curr['duration'])
                                                                                  .inSeconds) /
                                                                      toDuration(reviewProvider.quizTime == null
                                                                              ? '00:00:00'
                                                                              : reviewProvider
                                                                                  .quizTime)
                                                                          .inSeconds)
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
                                                                    verticalPadding:
                                                                        height *
                                                                            0.02,
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
                                                                        checkAnswer(reviewProvider,
                                                                                i)
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
                                                    ? ScrollPhysics()
                                                    : NeverScrollableScrollPhysics(),
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
                                                                  CustomContainer(
                                                                    onTap: () {
                                                                      quizProvider.setQuestionId(reviewProvider
                                                                              .questions[
                                                                          questionIndex -
                                                                              1]['question']['id']);
                                                                      websiteProvider
                                                                          .setLoaded(
                                                                              false);

                                                                      Navigator.pushNamed(
                                                                          context,
                                                                          Question
                                                                              .route);
                                                                    },
                                                                    verticalPadding:
                                                                        height *
                                                                            0.01,
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
                                                                                                                                  width, height, reviewProvider, questionIndex),
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
                                                                    Container(
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
                                                                  ] else ...[
                                                                    Container(
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
                                                              SizedBox(
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
                                                                                      Navigator.pop(context);
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
                                                                    verticalPadding:
                                                                        height *
                                                                            0.01,
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
                                                                          0.03),
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
                                      websiteProvider.setLoaded(false);

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
