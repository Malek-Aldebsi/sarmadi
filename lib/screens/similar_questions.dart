import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/similar_questions_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'dart:core';
import 'package:flutter/services.dart';

class SimilarQuestions extends StatefulWidget {
  const SimilarQuestions({super.key});

  @override
  State<SimilarQuestions> createState() => _SimilarQuestionsState();
}

class _SimilarQuestionsState extends State<SimilarQuestions> {

  StopWatchTimer? quizTimer;
  Stopwatch stopwatch = Stopwatch();
  TextEditingController reportController= TextEditingController();

  void getQuestions() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('similar_questions/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'question_id': Provider.of<SimilarQuestionsProvider>(context, listen: false).questionId,
      'is_single_question':true,
      'by_headlines':true,
      'by_author':true,
      'by_level':true,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
        quizTimer = StopWatchTimer(
          mode: StopWatchMode.countUp,
          onEnded: () {},
        ),
        quizTimer!.setPresetTime(mSec: 0),
        Provider.of<SimilarQuestionsProvider>(context, listen: false).setSubjectId(result['subject']),
        Provider.of<SimilarQuestionsProvider>(context, listen: false).setQuestions(result['questions']),
        quizTimer!.onStartTimer(),
        stopwatch.start(),
        Provider.of<WebsiteProvider>(context, listen: false).setLoaded(true)
      };
    });
  }

  void endTraining(SimilarQuestionsProvider questionProvider, WebsiteProvider websiteProvider) async {
    stopwatch.stop();
    quizTimer!.onStopTimer();

    questionProvider.editAnswerDuration(questionProvider.questions[questionProvider.questionIndex - 1]
    ['id'], stopwatch.elapsed.inSeconds);

    websiteProvider.setLoaded(false);

    context.pushReplacement('/QuizSetting');
  }

  void endQuestion(SimilarQuestionsProvider questionProvider) async {
    stopwatch.stop();
    quizTimer!.onStopTimer();

    questionProvider.editAnswerDuration(questionProvider.questions[questionProvider.questionIndex - 1]
    ['id'], stopwatch.elapsed.inSeconds);

    stopwatch.reset();
    quizTimer!.onResetTimer();

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    Map<dynamic, dynamic> answer = {questionProvider.questions[questionProvider.questionIndex-1]['id']: questionProvider.answers[questionProvider.questions[questionProvider.questionIndex-1]['id']]};
    post(
        'mark_question/',
        {
          if (key0 != null) 'email': key0,
          if (key1 != null) 'phone': key1,
          'password': value,
          'answers': answer,
        }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          :
      {
        questionProvider.setQuestionResult(result),
        questionProvider.setShowResult(true)
      };
    });

  }

  void saveQuestion(SimilarQuestionsProvider questionProvider, questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        questionProvider.answers[questionProvider.questions[questionProvider.questionIndex - 1]['id']]!['saved']
            ? 'unsave_question/'
            : 'save_question/',
        {
          if (key0 != null) 'email': key0,
          if (key1 != null) 'phone': key1,
          'password': value,
          'question_id': questionID,
        }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
        questionProvider.setSaveQuestion(questionProvider
            .questions[questionProvider.questionIndex - 1]['id'])
      };
    });
  }

  void report(questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        'report/',
        {
          if (key0 != null) 'email': key0,
          if (key1 != null) 'phone': key1,
          'password': value,
          'body': reportController.text,
          'question_id': questionID,
        }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
        context.pop()
      };
    });
  }

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  Widget multipleChoiceQuestionWithoutImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height / 32),
          child: SizedBox(
            width: width * 0.84,
            child: stringWithLatex(
                question['body'],
                3,
                width,
                height,
                kWhite),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < question['choices'].length; i++)
              Padding(
                padding: EdgeInsets.only(bottom: height / 64),
                child: CustomContainer(
                    onTap: questionProvider.showResult?null:() {

                      answer['answer'] == question['choices'][i]['id']
                          ? questionProvider.removeQuestionAnswer(question['id'])
                          : questionProvider.editQuestionAnswer(
                          question['id'], question['choices'][i]['id']);
                    },
                    verticalPadding: 0,
                    horizontalPadding: width * 0.02,
                    height: height*0.08,
                    width: width * 0.84,
                    borderRadius: width * 0.005,
                    border:
                    fullBorder(questionProvider.showResult?question['choices'][i]['id']==question['correct_answer']['id']?
                    kGreen:
                    question['choices'][i]['id'] ==answer['answer']?kRed:kTransparent:kTransparent),
                    buttonColor:
                    answer['answer'] == question['choices'][i]['id']
                        ? kLightPurple
                        : kDarkGray,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: stringWithLatex(question['choices'][i]['body'], 3,
                          width, height, kWhite),
                    )),
              ),
          ],
        )
      ],
    );
  }

  Widget multipleChoiceQuestionWithImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(bottom: height / 32),
        child: SizedBox(
          width: width * 0.84,
          child: stringWithLatex(question['body'], 3, width, height, kWhite),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < question['choices'].length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: height / 64),
                  child: CustomContainer(
                      onTap:questionProvider.showResult?null: () {

                        answer['answer'] == question['choices'][i]['id']
                            ? questionProvider.removeQuestionAnswer(question['id'])
                            : questionProvider.editQuestionAnswer(
                            question['id'], question['choices'][i]['id']);
                      },
                      verticalPadding: 0,
                      horizontalPadding: width * 0.02,
                      width: width * 0.4,
                      height: height*0.08,
                      borderRadius: width * 0.005,
                      border:
                      fullBorder(questionProvider.showResult?question['choices'][i]['id']==question['correct_answer']['id']?
                      kGreen:
                      question['choices'][i]['id'] ==answer['answer']?kRed:kTransparent:kTransparent),
                      buttonColor:
                      answer['answer'] == question['choices'][i]['id']
                          ? kLightPurple
                          : kDarkGray,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: stringWithLatex(question['choices'][i]['body'],
                            3, width, height, kWhite),
                      )),
                ),
            ],
          ),
          SizedBox(width: width * 0.02),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.35,
                child: CustomDivider(
                  dashHeight: 2,
                  dashWidth: width * 0.005,
                  dashColor: kDarkGray,
                  direction: Axis.vertical,
                  fillRate: 0.6,
                ),
              ),
            ],
          ),
          SizedBox(width: width * 0.02),
          Image(
            image: NetworkImage(question['image']),
            height: height * 0.35,
            width: width * 0.35,
            fit: BoxFit.contain,
          ),
        ],
      ),
    ]);
  }

  Widget finalAnswerQuestionWithoutImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(bottom: height / 32),
        child: SizedBox(
          width: width * 0.84,
          child: stringWithLatex(question['body'], 3, width, height, kWhite),
        ),
      ),
      SizedBox(height: height*0.3,
        child: Column(mainAxisAlignment:MainAxisAlignment.start,
            children: [
          if (questionProvider.showResult)
            ...[CustomContainer(
                onTap: null,
                verticalPadding: height * 0.02,
                horizontalPadding: width * 0.02,
                width: width * 0.84,
                borderRadius: width * 0.005,
                border: fullBorder(questionProvider.questionResult ? kGreen : kRed),
                buttonColor: kDarkGray,
                child: Align(
                    alignment:
                    Alignment.centerRight,
                    child: stringWithLatex(
                        answer['answer'],
                        3,
                        width,
                        height,
                        kWhite)

                )),
              if(!questionProvider.questionResult)
                ...[SizedBox(height: height*0.01),CustomContainer(
                    onTap: null,
                    verticalPadding: height * 0.02,
                    horizontalPadding: width * 0.02,
                    width: width * 0.84,
                    borderRadius: width * 0.005,
                    border: fullBorder(kGreen),
                    buttonColor: kDarkGray,
                    child: Align(
                        alignment:
                        Alignment.centerRight,
                        child: stringWithLatex(
                            question['correct_answer']['body'],
                            3,
                            width,
                            height,
                            kWhite)

                    ))]
            ]
          else if(questionProvider.subjectId== 'ee25ba19-a309-4010-a8ca-e6ea242faa96')
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: width * 0.84,
                child: MathField(
                  controller: question['controller'],
                  keyboardType: MathKeyboardType.expression,
                  variables: const [
                    'x',
                    'y',
                    'z',
                    'C',
                    't'
                  ],
                  decoration: InputDecoration(
                    isDense: true,

                    counterStyle: textStyle(3, width, height, kWhite),
                    filled: true,
                    fillColor: kDarkGray,
                    border: outlineInputBorder(width * 0.005, kTransparent),
                    focusedBorder:
                    outlineInputBorder(width * 0.005, kLightPurple),
                  ),
                  onChanged: (String
                  text) {
                    if (text == '') {
                      questionProvider.removeQuestionAnswer(question['id']);
                    } else {
                      questionProvider.editQuestionAnswer(question['id'], r'$'+text+r'$');
                    }
                  },
                  onSubmitted: (String text) {

                  },
                ),
              ),
            )
          else
            CustomTextField(
              controller: question['controller'],
              width: width * 0.84,
              fontOption: 3,
              fontColor: kWhite,
              textAlign: null,
              obscure: false,
              readOnly: false,
              focusNode: null,
              maxLines: null,
              maxLength: null,
              keyboardType: null,
              onChanged: (String text) {
                if (text == '') {
                  questionProvider.removeQuestionAnswer(question['id']);
                } else {
                  questionProvider.editQuestionAnswer(question['id'], text);
                }
              },
              onSubmitted: null,
              backgroundColor: kDarkGray,
              verticalPadding: height * 0.02,
              horizontalPadding: width * 0.02,
              isDense: true,
              errorText: null,
              hintText: 'اكتب الجواب النهائي',
              hintTextColor: kWhite.withOpacity(0.5),
              suffixIcon: null,
              prefixIcon: null,
              border: outlineInputBorder(width * 0.005, kTransparent),
              focusedBorder: outlineInputBorder(width * 0.005, kLightPurple),
            )
        ]),
      )

    ]);
  }

  Widget finalAnswerQuestionWithImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height / 32),
          child: SizedBox(
            width: width * 0.84,
            child: stringWithLatex(question['body'], 3, width, height, kWhite),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: height*0.3,
              child: Column(mainAxisAlignment:MainAxisAlignment.start,
                  children: [
            if (questionProvider.showResult)
              ...[CustomContainer(
                  onTap: null,
                  verticalPadding: height * 0.02,
                  horizontalPadding: width * 0.02,
                  width: width * 0.42,
                  borderRadius: width * 0.005,
                  border: fullBorder(questionProvider.questionResult ? kGreen : kRed),
                  buttonColor: kDarkGray,
                  child: Align(
                    alignment:
                    Alignment.centerRight,
                    child: stringWithLatex(
                        answer['answer'],
                        3,
                        width,
                        height,
                        kWhite),
                  )),
                if(!questionProvider.questionResult)
                  ...[SizedBox(height: height*0.01),CustomContainer(
                      onTap: null,
                      verticalPadding: height * 0.02,
                      horizontalPadding: width * 0.02,
                      width: width * 0.84,
                      borderRadius: width * 0.005,
                      border: fullBorder(kGreen),
                      buttonColor: kDarkGray,
                      child: Align(
                          alignment:
                          Alignment.centerRight,
                          child: stringWithLatex(
                              question['correct_answer']['body'],
                              3,
                              width,
                              height,
                              kWhite)

                      ))]
              ]
            else if(questionProvider.subjectId== 'ee25ba19-a309-4010-a8ca-e6ea242faa96')
              Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  width: width * 0.42,
                  child: MathField(
                    controller: question['controller'],
                    keyboardType: MathKeyboardType.expression,
                    variables: const [
                      'x',
                      'y',
                      'z',
                      'C',
                      't'
                    ],
                    decoration: InputDecoration(
                      isDense: true,

                      counterStyle: textStyle(3, width, height, kWhite),
                      filled: true,
                      fillColor: kDarkGray,
                      border: outlineInputBorder(width * 0.005, kTransparent),
                      focusedBorder:
                      outlineInputBorder(width * 0.005, kLightPurple),
                    ),

                    onChanged: (String
                    text) {
                      if (text == '') {
                        questionProvider.removeQuestionAnswer(question['id']);
                      } else {
                        questionProvider.editQuestionAnswer(question['id'], r'$'+text+r'$');
                      }
                    },
                    onSubmitted: (String text) {

                    },
                  ),
                ),
              )
            else
              CustomTextField(
                controller: question['controller'],
                width: width * 0.42,
                fontOption: 3,
                fontColor: kWhite,
                textAlign: null,
                obscure: false,
                readOnly: false,
                focusNode: null,
                maxLines: null,
                maxLength: null,
                keyboardType: null,
                onChanged: (String text) {
                  if (text == '') {
                    questionProvider.removeQuestionAnswer(question['id']);
                  } else {
                    questionProvider.editQuestionAnswer(question['id'], text);
                  }
                },
                onSubmitted: null,
                backgroundColor: kDarkGray,
                verticalPadding: height * 0.02,
                horizontalPadding: width * 0.02,
                isDense: true,
                errorText: null,
                hintText: 'اكتب الجواب النهائي',
                hintTextColor: kWhite.withOpacity(0.5),
                suffixIcon: null,
                prefixIcon: null,
                border: outlineInputBorder(width * 0.005, kTransparent),
                focusedBorder: outlineInputBorder(width * 0.005, kLightPurple),
              ),
    ]),
    ),
            SizedBox(width: width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.35,
                  child: CustomDivider(
                    dashHeight: 2,
                    dashWidth: width * 0.005,
                    dashColor: kDarkGray,
                    direction: Axis.vertical,
                    fillRate: 0.6,
                  ),
                ),
              ],
            ),
            SizedBox(width: width * 0.02),
            Image(
              image: NetworkImage(question['image']),
              height: height * 0.35,
              width: width * 0.35,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  Widget multiSectionQuestionWithoutImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height / 32),
          child: SizedBox(
            width: width * 0.84,
            child: stringWithLatex(question['body'], 3, width, height, kWhite),
          ),
        ),
        SizedBox(
            height: height * 0.4,
            width: width * 0.84,
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  minThumbLength: 1,
                  mainAxisMargin: 0,
                  crossAxisMargin: 0,
                  radius: Radius.circular(width * 0.005),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                  trackVisibility: MaterialStateProperty.all<bool>(true),
                  thumbColor: MaterialStateProperty.all<Color>(kLightPurple),
                  trackColor: MaterialStateProperty.all<Color>(kDarkGray),
                  trackBorderColor:
                  MaterialStateProperty.all<Color>(kTransparent),
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ListView(
                  children: [
                    Directionality(textDirection: TextDirection.rtl,child: Padding(
                      padding: EdgeInsets.only(left: width * 0.02, right: width * 0.035),
                      child: Column(children: [
                        SizedBox(height: height * 0.01),
                        for (final subQuestion in question['sub_questions'].asMap().entries) ...[
                          SizedBox(
                            width: width * 0.84,
                            child: stringWithLatex(subQuestion.value['body'], 3,
                                width, height, kWhite),
                          ),
                          SizedBox(height: height * 0.02),
                          if (subQuestion.value['type'] == 'finalAnswerQuestion')
                            ...[
                              if (questionProvider.showResult)
                                ...[
                                  CustomContainer(
                                    onTap: null,
                                    verticalPadding: height * 0.02,
                                    horizontalPadding: width * 0.02,
                                    width: width * 0.79,
                                    borderRadius: width * 0.005,
                                    border: fullBorder(questionProvider.questionResult[subQuestion.key] ? kGreen : kRed),
                                    buttonColor: kDarkGray,
                                    child: Align(
                                        alignment:
                                        Alignment.centerRight,
                                        child: stringWithLatex(
                                            answer.containsKey(
                                                'answer') &&
                                                answer['answer']
                                                    .containsKey(
                                                    subQuestion.value[
                                                    'id'])?
                                                answer['answer'][
                                                subQuestion.value[
                                                'id']] :'',
                                            3,
                                            width,
                                            height,
                                            kWhite)
                                    )),
                                  if(!questionProvider.questionResult[subQuestion.key])
                                    ...[SizedBox(height: height*0.01),CustomContainer(
                                        onTap: null,
                                        verticalPadding: height * 0.02,
                                        horizontalPadding: width * 0.02,
                                        width: width * 0.79,
                                        borderRadius: width * 0.005,
                                        border: fullBorder(kGreen),
                                        buttonColor: kDarkGray,
                                        child: Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: stringWithLatex(
                                                subQuestion.value['correct_answer']['body'],
                                                3,
                                                width,
                                                height,
                                                kWhite)
                                        ))]
                                ]
                              else if(questionProvider.subjectId== 'ee25ba19-a309-4010-a8ca-e6ea242faa96')
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: SizedBox(
                                  width: width * 0.79,
                                  child: MathField(
                                    controller: subQuestion.value['controller'],
                                    keyboardType: MathKeyboardType.expression,
                                    variables: const [
                                      'x',
                                      'y',
                                      'z',
                                      'C',
                                      't'
                                    ],
                                    decoration: InputDecoration(
                                      isDense: true,

                                      counterStyle: textStyle(3, width, height, kWhite),
                                      filled: true,
                                      fillColor: kDarkGray,
                                      border: outlineInputBorder(width * 0.005, kTransparent),
                                      focusedBorder:
                                      outlineInputBorder(width * 0.005, kLightPurple),
                                    ),
                                    onChanged: (String
                                    text) {
                                      if (text == '') {
                                        questionProvider.removeSubQuestionAnswer(
                                            question['id'],
                                            subQuestion.value['id']);
                                      } else {
                                        questionProvider.editSubQuestionAnswer(question['id'],
                                            subQuestion.value['id'], r'$'+text+r'$');
                                      }
                                    },
                                    onSubmitted: (String text) {
                                    },
                                  ),
                                ),
                              )
                            else CustomTextField(
                                controller: subQuestion.value['controller'],
                                width: width * 0.79,
                                fontOption: 3,
                                fontColor: kWhite,
                                textAlign: null,
                                obscure: false,
                                readOnly: false,
                                focusNode: null,
                                maxLines: null,
                                maxLength: null,
                                keyboardType: null,
                                onChanged: (String text) {
                                  if (text == '') {
                                    questionProvider.removeSubQuestionAnswer(
                                        question['id'],
                                        subQuestion.value['id']);
                                  } else {
                                    questionProvider.editSubQuestionAnswer(question['id'],
                                        subQuestion.value['id'], text);
                                  }
                                },
                                onSubmitted: null,
                                backgroundColor: kDarkGray,
                                verticalPadding: width * 0.01,
                                horizontalPadding: width * 0.02,
                                isDense: true,
                                errorText: null,
                                hintText: 'اكتب الجواب النهائي',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: null,
                                prefixIcon: null,
                                border: outlineInputBorder(
                                    width * 0.005, kTransparent),
                                focusedBorder: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                              ),SizedBox(height: height * 0.02),]
                          else if (subQuestion.value['type'] == 'multipleChoiceQuestion')
                            for (int i = 0;
                            i < subQuestion.value['choices'].length;
                            i++)
                              ...[CustomContainer(
                                  onTap: questionProvider.showResult ? null:() {
                                    if (answer
                                        .containsKey('answer') &&
                                        answer['answer'].containsKey(
                                            subQuestion.value['id']) &&
                                        answer['answer']
                                        [subQuestion.value['id']] ==
                                            subQuestion.value['choices'][i]
                                            ['id']) {
                                      questionProvider.removeSubQuestionAnswer(
                                          question['id'],
                                          subQuestion.value['id']);
                                    } else {
                                      questionProvider.editSubQuestionAnswer(
                                          question['id'],
                                          subQuestion.value['id'],
                                          subQuestion.value['choices']
                                          [i]['id']);
                                    }
                                  },
                                  verticalPadding: 0,
                                  horizontalPadding: width * 0.02,
                                  width: width * 0.79,
                                  height: height*0.08,
                                  borderRadius: width * 0.005,

                                  border:
                                          fullBorder(questionProvider.showResult?subQuestion.value['choices'][i]['id']==subQuestion.value['correct_answer']['id']? kGreen:
                                          answer.containsKey('answer') && answer['answer'].containsKey(subQuestion.value['id']) &&
                                              answer['answer'][subQuestion.value['id']] == subQuestion.value['choices'][i]['id']?kRed:kTransparent:kTransparent),
                                  buttonColor: answer.containsKey(
                                      'answer') &&
                                      answer['answer']
                                          .containsKey(
                                          subQuestion.value[
                                          'id']) &&
                                      answer['answer'][
                                      subQuestion.value[
                                      'id']] ==
                                          subQuestion.value['choices']
                                          [i]['id']
                                      ? kLightPurple
                                      : kDarkGray,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: stringWithLatex(
                                        subQuestion.value['choices'][i]
                                        ['body'],
                                        3,
                                        width,
                                        height,
                                        kWhite),
                                  )),SizedBox(height: height * 0.02)],
                          SizedBox(height: height * 0.03),

                        ],
                      ]),
                    )),

                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget multiSectionQuestionWithImage(SimilarQuestionsProvider questionProvider, width, height) {
    int questionIndex = questionProvider.questionIndex - 1;
    Map question = questionProvider.questions[questionIndex];
    Map answer = questionProvider.answers[question['id']];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: height / 32),
          child: SizedBox(
            width: width * 0.84,
            child: stringWithLatex(
                question['body'], 3, width, height, kWhite),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: height * 0.4,
                width: width * 0.44,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    scrollbarTheme: ScrollbarThemeData(
                      minThumbLength: 1,
                      mainAxisMargin: 0,
                      crossAxisMargin: 0,
                      radius: Radius.circular(width * 0.005),
                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                      trackVisibility: MaterialStateProperty.all<bool>(true),
                      thumbColor:
                      MaterialStateProperty.all<Color>(kLightPurple),
                      trackColor: MaterialStateProperty.all<Color>(kDarkGray),
                      trackBorderColor:
                      MaterialStateProperty.all<Color>(kTransparent),
                    ),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: ListView(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02),
                            child: Column(children: [
                              SizedBox(height: height * 0.01),
                              for (final subQuestion in question['sub_questions'].asMap().entries) ...[
                                SizedBox(
                                  width: width * 0.44,
                                  child: stringWithLatex(subQuestion.value['body'],
                                      3, width, height, kWhite),
                                ),
                                SizedBox(height: height * 0.02),
                                if (subQuestion.value['type'] == 'finalAnswerQuestion')
                                  ...[     if (questionProvider.showResult)
                                    ...[
                                      CustomContainer(
                                          onTap: null,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          width: width * 0.42,
                                          borderRadius: width * 0.005,
                                          border: fullBorder(questionProvider.questionResult[subQuestion.key] ? kGreen : kRed),
                                          buttonColor: kDarkGray,
                                          child: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: stringWithLatex(
                                                  answer.containsKey(
                                                      'answer') &&
                                                      answer['answer']
                                                          .containsKey(
                                                          subQuestion.value[
                                                          'id'])?
                                                  answer['answer'][
                                                  subQuestion.value[
                                                  'id']] :'',
                                                  3,
                                                  width,
                                                  height,
                                                  kWhite)
                                          )),
                                      if(!questionProvider.questionResult[subQuestion.key])
                                        ...[SizedBox(height: height*0.01),CustomContainer(
                                            onTap: null,
                                            verticalPadding: height * 0.02,
                                            horizontalPadding: width * 0.02,
                                            width: width * 0.42,
                                            borderRadius: width * 0.005,
                                            border: fullBorder(kGreen),
                                            buttonColor: kDarkGray,
                                            child: Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: stringWithLatex(
                                                    subQuestion.value['correct_answer']['body'],
                                                    3,
                                                    width,
                                                    height,
                                                    kWhite)
                                            ))]
                                    ]
                                  else if(questionProvider.subjectId== 'ee25ba19-a309-4010-a8ca-e6ea242faa96')
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: SizedBox(
                                        width: width * 0.42,
                                        child: MathField(
                                          controller: subQuestion.value['controller'],
                                          keyboardType: MathKeyboardType.expression,
                                          variables: const [
                                            'x',
                                            'y',
                                            'z',
                                            'C',
                                            't'
                                          ],
                                          // Specify the variables the user can use (only in expression mode).
                                          decoration: InputDecoration(
                                            isDense: true,

                                            counterStyle: textStyle(3, width, height, kWhite),
                                            filled: true,
                                            fillColor: kDarkGray,
                                            border: outlineInputBorder(width * 0.005, kTransparent),
                                            focusedBorder:
                                            outlineInputBorder(width * 0.005, kLightPurple),
                                          ),

                                          onChanged: (String
                                          text) {
                                            if (text == '') {
                                              questionProvider.removeSubQuestionAnswer(
                                                  question['id'],
                                                  subQuestion.value['id']);
                                            } else {
                                              questionProvider.editSubQuestionAnswer(question['id'],
                                                  subQuestion.value['id'], r'$'+text+r'$');
                                            }
                                          },
                                          onSubmitted: (String text) {},
                                        ),
                                      ),
                                    )else
                                    CustomTextField(
                                      controller: subQuestion.value['controller'],
                                      width: width * 0.42,
                                      fontOption: 3,
                                      fontColor: kWhite,
                                      textAlign: null,
                                      obscure: false,
                                      readOnly: false,
                                      focusNode: null,
                                      maxLines: null,
                                      maxLength: null,
                                      keyboardType: null,
                                      onChanged: (String text) {
                                        if (text == '') {
                                          questionProvider.removeSubQuestionAnswer(
                                              question['id'],
                                              subQuestion.value['id']);
                                        } else {
                                          questionProvider.editSubQuestionAnswer(
                                              question['id'],
                                              subQuestion.value['id'],
                                              text);
                                        }
                                      },
                                      onSubmitted: null,
                                      backgroundColor: kDarkGray,
                                      verticalPadding: width * 0.01,
                                      horizontalPadding: width * 0.02,
                                      isDense: true,
                                      errorText: null,
                                      hintText: 'اكتب الجواب النهائي',
                                      hintTextColor: kWhite.withOpacity(0.5),
                                      suffixIcon: null,
                                      prefixIcon: null,
                                      border: outlineInputBorder(
                                          width * 0.005, kTransparent),
                                      focusedBorder: outlineInputBorder(
                                          width * 0.005, kLightPurple),
                                    ),SizedBox(height: height * 0.02),]
                                else if (subQuestion.value['type'] ==
                                    'multipleChoiceQuestion')
                                  for (int i = 0;
                                  i < subQuestion.value['choices'].length;
                                  i++)
                                    ...[CustomContainer(
                                        onTap: questionProvider.showResult ? null:() {
                                          if (answer.containsKey(
                                              'answer') &&
                                              answer['answer']
                                                  .containsKey(
                                                  subQuestion.value[
                                                  'id']) &&
                                              answer['answer'][
                                              subQuestion.value[
                                              'id']] ==
                                                  subQuestion.value['choices']
                                                  [i]['id']) {
                                            questionProvider.removeSubQuestionAnswer(
                                                question[
                                                'id'],
                                                subQuestion.value['id']);
                                          } else {
                                            questionProvider.editSubQuestionAnswer(
                                                question[
                                                'id'],
                                                subQuestion.value['id'],
                                                subQuestion.value[
                                                'choices']
                                                [i]['id']);
                                          }
                                        },
                                        verticalPadding: 0,
                                        horizontalPadding: width * 0.02,
                                        width: width * 0.42,
                                        height: height*0.08,
                                        borderRadius: width * 0.005,
                                        border:
                                        fullBorder(questionProvider.showResult?subQuestion.value['choices'][i]['id']==subQuestion.value['correct_answer']['id']? kGreen:
                                        answer.containsKey('answer') && answer['answer'].containsKey(subQuestion.value['id']) &&
                                            answer['answer'][subQuestion.value['id']] == subQuestion.value['choices'][i]['id']?kRed:kTransparent:kTransparent),
                                        buttonColor: answer
                                            .containsKey(
                                            'answer') &&
                                            answer['answer']
                                                .containsKey(
                                                subQuestion.value[
                                                'id']) &&
                                            answer['answer'][
                                            subQuestion.value[
                                            'id']] ==
                                                subQuestion.value[
                                                'choices']
                                                [i]['id']
                                            ? kLightPurple
                                            : kDarkGray,
                                        child: Align(
                                          alignment:
                                          Alignment.centerRight,
                                          child: stringWithLatex(
                                              subQuestion.value['choices'][i]
                                              ['body'],
                                              3,
                                              width,
                                              height,
                                              kWhite),
                                        )),SizedBox(height: height * 0.02)],
                                SizedBox(height: height * 0.03),
                              ],
                            ],),
                          ),
                        )

                      ],
                    ),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.35,
                  child: CustomDivider(
                    dashHeight: 2,
                    dashWidth: width * 0.005,
                    dashColor: kDarkGray,
                    direction: Axis.vertical,
                    fillRate: 0.6,
                  ),
                ),
              ],
            ),
            SizedBox(width: width * 0.02),
            Image(
              image: NetworkImage(question['image']),
              height: height * 0.35,
              width: width * 0.35,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SimilarQuestionsProvider questionProvider = Provider.of<SimilarQuestionsProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    return width < height
        ? const RotateYourPhone()
        :
        Provider.of<WebsiteProvider>(context, listen: true).loaded
        ? Provider.of<SimilarQuestionsProvider>(context, listen: true).questions.isEmpty?Scaffold(
          backgroundColor: kDarkGray,
          body: Center(
              child: CustomContainer(
                onTap: null,
                width: width * 0.3,
                height: height * 0.3,
                verticalPadding: 0,
                horizontalPadding: 0,
                buttonColor: kLightBlack,
                border: fullBorder(kDarkBlack),
                borderRadius: width * 0.005,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لا يوجد اسئلة شبيهه لهذه المواضيع حاليا\nستتوفر قريبا',
                      textAlign: TextAlign.center,
                      style: textStyle(3, width, height, kLightPurple),
                    ),
                    SizedBox(height: height * 0.06),
                    CustomContainer(
                      onTap: () {
                        Provider.of<WebsiteProvider>(context, listen: false)
                            .setLoaded(false);
                        context.pushReplacement('/QuizSetting');
                      },
                      width: width * 0.18,
                      verticalPadding: height * 0.005,
                      horizontalPadding: 0,
                      borderRadius: width * 0.005,
                      buttonColor: kLightPurple,
                      border: null,
                      child: Center(
                        child: Text(
                          'العودة للصفحة الرئيسية',
                          style: textStyle(3, width, height, kDarkBlack),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ):Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/single_question_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                        height: height,
                        width: width * 0.08,
                        buttonColor: kLightPurple,
                        child: Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: width * 0.005),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              CustomContainer(
                                onTap: () {
                                  popUp(
                                      context,
                                      width * 0.2,
                                      height * 0.25,
                                      Center(
                                        child: Text(
                                          'هذا السؤال من اسئلة ${Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]['writer']}',
                                          style: textStyle(
                                              3, width, height, kLightPurple),
                                        ),
                                      ),
                                      kLightBlack,
                                      kDarkBlack,
                                      width * 0.01);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: width * 0.014,
                                      color: kDarkBlack,
                                    ),
                                    Text('معلومات السؤال',
                                        textAlign: TextAlign.center,
                                        style: textStyle(
                                            4, width, height, kDarkBlack)),
                                  ],
                                ),
                              ),
                              CustomContainer(
                                onTap: () {
                                  saveQuestion(questionProvider,
                                      questionProvider.questions[questionProvider.questionIndex - 1]['id']);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      questionProvider.answers[questionProvider.questions[questionProvider.questionIndex - 1]
                                      ['id']]!['saved']
                                          ? Icons.bookmark_add_rounded
                                          : Icons.bookmark_add_outlined,
                                      size: width * 0.014,
                                      color: kDarkBlack,
                                    ),
                                    Text('حفظ السؤال',
                                        textAlign: TextAlign.center,
                                        style: textStyle(
                                            4, width, height, kDarkBlack)),
                                  ],
                                ),
                              ),
                              CustomDivider(
                                dashHeight: 0.5,
                                dashWidth: width * 0.001,
                                dashColor: kDarkBlack,
                                direction: Axis.horizontal,
                                fillRate: 1,
                              ),
                              Column(
                                children: [
                                  Text('السؤال',
                                      style: textStyle(
                                          3, width, height, kDarkBlack)),
                                  Text('${Provider
                                      .of<SimilarQuestionsProvider>(
                                      context, listen: true)
                                      .questionIndex}/${Provider.of<SimilarQuestionsProvider>(context, listen: true).questions.length}',
                                      style: textStyle(
                                          3, width, height, kDarkBlack)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('الوقت',
                                      style: textStyle(
                                          3, width, height, kDarkBlack)),
                                  StreamBuilder<int>(
                                    stream: quizTimer!.rawTime,
                                    initialData: quizTimer!.rawTime.value,
                                    builder: (context, snap) {
                                      final displayTime =
                                      StopWatchTimer.getDisplayTime(
                                          snap.data!,
                                          milliSecond: false);
                                      return Text(displayTime,
                                          style: textStyle(
                                              3, width, height, kDarkBlack));
                                    },
                                  ),
                                ],
                              ),
                              Stack(
                                children: [
                                  Column(
                                    children: [
                                      Text('شارك السؤال',
                                          textAlign: TextAlign.center,
                                          style: textStyle(
                                              3, width, height, kDarkBlack)),
                                      CustomContainer(
                                        onTap: () async {
                                          Provider.of<SimilarQuestionsProvider>(context, listen: false).setCopied(true);
                                          await Clipboard.setData(
                                              ClipboardData(
                                                  text: 'https://kawka-b.com/#/SharedQuestion/${Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[
                                                  Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]
                                                  ['id']}'));
                                          Timer(const Duration(seconds: 2), () {
                                            Provider.of<SimilarQuestionsProvider>(context, listen: false).setCopied(false);
                                          });
                                        },
                                        child: Text(
                                            Provider.of<SimilarQuestionsProvider>(context, listen: true).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]['id']
                                                .substring(0, 8),
                                            style: textStyle(3, width, height,
                                                kDarkBlack)),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: Provider.of<SimilarQuestionsProvider>(context, listen: true).copied,
                                    child: CustomContainer(
                                      borderRadius: width * 0.05,
                                      buttonColor: kDarkBlack,
                                      border: fullBorder(kLightPurple),
                                      horizontalPadding: width * 0.005,
                                      verticalPadding: height * 0.005,
                                      child: Text('تم النسخ',
                                          textAlign: TextAlign.center,
                                          style: textStyle(5, width, height,
                                              kLightPurple)),
                                    ),
                                  ),
                                ],
                              ),
                              CustomDivider(
                                dashHeight: 0.5,
                                dashWidth: width * 0.001,
                                dashColor: kDarkBlack,
                                direction: Axis.horizontal,
                                fillRate: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomContainer(
                                    width: width * 0.03,
                                    onTap: () {
                                      popUp(
                                          context,
                                          width * 0.4,
                                          height * 0.35,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ملاحظاتك',
                                                style: textStyle(2, width,
                                                    height, kLightPurple),
                                              ),
                                              CustomTextField(
                                                controller: reportController,
                                                width: width *0.38,
                                                fontOption: 4,
                                                fontColor: kLightPurple,
                                                textAlign: null,
                                                obscure: false,
                                                readOnly: false,
                                                focusNode: null,
                                                maxLines: null,
                                                maxLength: null,
                                                keyboardType: null,
                                                onChanged: (String text) {},
                                                onSubmitted: (value) {
                                                  report(
                                                      Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]['id']);
                                                },
                                                backgroundColor: kDarkBlack,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: width * 0.02,
                                                isDense: true,
                                                errorText: null,
                                                hintText: 'ادخل ملاحظاتك',
                                                hintTextColor: kLightPurple.withOpacity(0.5),
                                                suffixIcon: null,
                                                prefixIcon: null,
                                                border: outlineInputBorder(width * 0.005, kLightPurple),
                                                focusedBorder:
                                                outlineInputBorder(width * 0.005, kLightPurple),
                                              ),

                                              CustomContainer(
                                                onTap: () {
                                                  report(
                                                      Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]['id']);
                                                },
                                                width: width * 0.38,
                                                height: height*0.06,
                                                verticalPadding:0,
                                                horizontalPadding: width*0.02,
                                                borderRadius: width * 0.005,
                                                buttonColor: kLightPurple,
                                                child: Center(
                                                  child: Text(
                                                    'تأكيد',
                                                    style: textStyle(3, width,
                                                        height, kDarkBlack),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'تنويه: يرجى كتابة كافة ملاحظاتك عن السؤال وسيقوم الفريق المختص بالتحقق من الأمر بأقرب وقت',
                                                style: textStyle(4, width,
                                                    height, kLightPurple),
                                              ),

                                            ],
                                          ),
                                          kLightBlack,
                                          kDarkBlack,
                                          width * 0.01);


                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          size: width * 0.014,
                                          color: kDarkBlack,
                                        ),
                                        Text(
                                          'بلاغ',
                                          style: textStyle(
                                              4, width, height, kDarkBlack),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CustomContainer(
                                    width: width * 0.03,
                                    onTap: () {
                                      popUp(
                                          context,
                                          width * 0.2,
                                          height * 0.25,
                                          Center(
                                            child: Text(
                                              Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex - 1]
                                              ['hint'] ==
                                                  '' ||
                                                  Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex -
                                                      1]['hint'] ==
                                                      null
                                                  ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                  : Provider.of<SimilarQuestionsProvider>(context, listen: false).questions[Provider.of<SimilarQuestionsProvider>(context, listen: false).questionIndex -
                                                  1]['hint'],
                                              style: textStyle(3, width,
                                                  height, kLightPurple),
                                            ),
                                          ),
                                          kLightBlack,
                                          kDarkBlack,
                                          width * 0.01);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.help_outline_rounded,
                                          size: width * 0.014,
                                          color: kDarkBlack,
                                        ),
                                        Text('مساعدة',
                                            style: textStyle(4, width, height,
                                                kDarkBlack)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              CustomContainer(
                                onTap: () {
                                  popUp(
                                      context,
                                      width * 0.2,
                                      height * 0.25,
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'هل تريد انهاء التدريب',
                                            style: textStyle(3, width, height,
                                                kLightPurple),
                                          ),
                                          SizedBox(height: height * 0.04),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              CustomContainer(
                                                onTap: () {
                                                  context.pop();
                                                },
                                                width: width * 0.08,
                                                height: height*0.06,
                                                verticalPadding:0,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                buttonColor: kDarkBlack,
                                                border:
                                                fullBorder(kLightPurple),
                                                child: Center(
                                                  child: Text(
                                                    'لا',
                                                    style: textStyle(3, width,
                                                        height, kLightPurple),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                              CustomContainer(
                                                onTap: () {
                                                  context.pop();
                                                  endTraining(questionProvider, websiteProvider);
                                                },
                                                width: width * 0.08,
                                                verticalPadding:0,
                                                height: height*0.06,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                buttonColor: kLightPurple,
                                                border: null,
                                                child: Center(
                                                  child: Text(
                                                    'نعم',
                                                    style: textStyle(3, width,
                                                        height, kDarkBlack),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      kLightBlack,
                                      kDarkBlack,
                                      width * 0.01);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.exit_to_app_outlined,
                                      size: width * 0.014,
                                      color: kDarkBlack,
                                    ),
                                    Text('إنهاء التدريب',
                                        textAlign: TextAlign.center,
                                        style: textStyle(
                                            4, width, height, kDarkBlack)),
                                  ],
                                ),
                              ),
                              const SizedBox(),
                            ],
                          ),
                        )),
                    SizedBox(width: width * 0.03),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        if (questionProvider.questions[
                        questionProvider.questionIndex -
                            1]['type'] ==
                            'multipleChoiceQuestion' &&
                            questionProvider.questions[
                            questionProvider.questionIndex -
                                1]['image'] ==
                                null)
                          multipleChoiceQuestionWithoutImage(
                              questionProvider, width, height)
                        else if (questionProvider.questions[
                        questionProvider.questionIndex -
                            1]['type'] ==
                            'multipleChoiceQuestion' &&
                            questionProvider.questions[
                            questionProvider.questionIndex -
                                1]['image'] !=
                                null)
                          multipleChoiceQuestionWithImage(
                              questionProvider, width, height)
                        else if (questionProvider.questions[
                          questionProvider.questionIndex -
                              1]['type'] ==
                              'finalAnswerQuestion' &&
                              questionProvider.questions[
                              questionProvider.questionIndex -
                                  1]['image'] ==
                                  null)
                            finalAnswerQuestionWithoutImage(
                                questionProvider, width, height)
                          else if (questionProvider.questions[
                            questionProvider.questionIndex -
                                1]['type'] ==
                                'finalAnswerQuestion' &&
                                questionProvider.questions[
                                questionProvider.questionIndex -
                                    1]['image'] !=
                                    null)
                              finalAnswerQuestionWithImage(
                                  questionProvider, width, height)
                            else if (questionProvider.questions[
                              questionProvider.questionIndex -
                                  1]['type'] ==
                                  'multiSectionQuestion' &&
                                  questionProvider.questions[
                                  questionProvider.questionIndex -
                                      1]['image'] ==
                                      null)
                                multiSectionQuestionWithoutImage(
                                    questionProvider, width, height)
                              else if (questionProvider.questions[
                                questionProvider.questionIndex -
                                    1]['type'] ==
                                    'multiSectionQuestion' &&
                                    questionProvider.questions[
                                    questionProvider.questionIndex -
                                        1]['image'] !=
                                        null)
                                  multiSectionQuestionWithImage(
                                      questionProvider, width, height)

                        ,Padding(
                          padding: EdgeInsets.only(bottom: height * 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomContainer(
                                  onTap: null,
                                  width: width * 0.19,
                                  verticalPadding: 0,
                                height: height * 0.08,
                                horizontalPadding: 0,
                                  borderRadius: width * 0.005,
                                  border: null,
                                  buttonColor: kTransparent,
                                  child: null,
                                ),
                              SizedBox(width: width * 0.02),
                              CustomContainer(
                                onTap: () {
                                  questionProvider.showResult?
                                  questionProvider.questionIndex == questionProvider.questions.length?endTraining(questionProvider, websiteProvider):{
                                    questionProvider.setQuestionIndex(questionProvider.questionIndex+1),
                                    questionProvider.setShowResult(false),
                                    quizTimer!.onStartTimer(),
                                    stopwatch.start(),
                                  }:endQuestion(questionProvider);
                                },
                                width: width * 0.19,
                                height: height * 0.08,
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                borderRadius: width * 0.005,
                                border: null,
                                buttonColor: kLightPurple,
                                child: Center(
                                  child: Text(questionProvider.showResult?
                                  questionProvider.questionIndex == questionProvider.questions.length?'انهاء التدريب':'السؤال التالي': 'تأكيد الجواب',
                                      style: textStyle(
                                          2, width, height, kDarkBlack)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),

          ),
        ))
        : Scaffold(
        backgroundColor: kDarkGray,
        body: Center(
            child: CircularProgressIndicator(
                color: kPurple, strokeWidth: width * 0.05),),);
  }
}
