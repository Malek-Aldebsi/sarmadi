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
import '../providers/shared_question_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import 'dart:core';
import 'package:flutter/services.dart';

class SharedQuestion extends StatefulWidget {
  const SharedQuestion({super.key});

  @override
  State<SharedQuestion> createState() => _SharedQuestionState();
}

class _SharedQuestionState extends State<SharedQuestion> {

  StopWatchTimer? quizTimer;
  TextEditingController reportController= TextEditingController();

  void getQuestions(SharedQuestionProvider sharedQuestionProvider, WebsiteProvider websiteProvider) async {
    post('get_shared_question/', {
      'ID': sharedQuestionProvider.questionId,
    }).then((value) {
      dynamic result = decode(value);
      result == 0 || result == 404
          ? context.pushReplacement('/LogIn')
          : {
        quizTimer = StopWatchTimer(
          mode: StopWatchMode.countUp,
          onEnded: () {},
        ),
        quizTimer!.setPresetTime(mSec: 0),
        sharedQuestionProvider.setSubjectId(result['subject']),
        sharedQuestionProvider.setQuestions(result['question']),
        quizTimer!.onStartTimer(),
        websiteProvider.setLoaded(true)
      };
    });
  }

  void endQuestion(SharedQuestionProvider questionProvider) async {
    Map<dynamic, dynamic> answer = {questionProvider.question['id']: questionProvider.answers[questionProvider.question['id']]};
    post(
        'mark_shared_question/',
        {
          'answers': answer,
        }).then((value) {
      dynamic result = decode(value);
      result == 404
          ? context.pushReplacement('/LogIn')
          :
      {
        questionProvider.setQuestionResult(result),
        questionProvider.setShowResult(true)
      };
    });

  }

  void logIn(SharedQuestionProvider questionProvider, WebsiteProvider websiteProvider) async {
    quizTimer!.onStopTimer();
    websiteProvider.setLoaded(false);
    context.pushReplacement('/LogIn');
  }

  @override
  void initState() {
    getQuestions(Provider.of<SharedQuestionProvider>(context, listen: false), Provider.of<WebsiteProvider>(context, listen: false));
    super.initState();
  }

  Widget multipleChoiceQuestionWithoutImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
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

  Widget multipleChoiceQuestionWithImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
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
                      height: height*0.08,
                      horizontalPadding: width * 0.02,
                      width: width * 0.4,
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

  Widget finalAnswerQuestionWithoutImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
    Map answer = questionProvider.answers[question['id']];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(bottom: height / 32),
        child: SizedBox(
          width: width * 0.84,
          child: stringWithLatex(question['body'], 3, width, height, kWhite),
        ),
      ),
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
    ]);
  }

  Widget finalAnswerQuestionWithImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
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

  Widget multiSectionQuestionWithoutImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
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
                                      onSubmitted: (String text) {},
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
                                  height: height*0.08,
                                  horizontalPadding: width * 0.02,
                                  width: width * 0.79,
                                  borderRadius: width * 0.005,
                                  border:

                                  fullBorder(questionProvider.showResult? subQuestion.value['choices'][i]['id']==subQuestion.value['correct_answer']['id']? kGreen:
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

  Widget multiSectionQuestionWithImage(SharedQuestionProvider questionProvider, width, height) {
    Map question = questionProvider.question;
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
                                            onSubmitted: (String text) {

                                            },
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
                                        height: height*0.08,
                                        horizontalPadding: width * 0.02,
                                        width: width * 0.42,
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

    SharedQuestionProvider questionProvider = Provider.of<SharedQuestionProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);

    return width < height
        ? const RotateYourPhone()
        :
      Provider.of<WebsiteProvider>(context, listen: true).loaded
          ? Scaffold(
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
                            InkWell(
                              onTap: () {
                                popUp(
                                    context,
                                    width * 0.2,
                                    height * 0.25,
                                    Center(
                                      child: Text(
                                        'هذا السؤال من اسئلة ${questionProvider.question['writer']}',
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
                            InkWell(
                              onTap: null,
                              child: Column(
                                children: [
                                  Icon(
                                    questionProvider.answers['saved']
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
                                Text('1/1',
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
                            Column(
                              children: [
                                Text('شارك السؤال',
                                    textAlign: TextAlign.center,
                                    style: textStyle(
                                        3, width, height, kDarkBlack)),
                                InkWell(
                                  onTap: () async {
                                    questionProvider.setCopied(true);
                                    await Clipboard.setData(
                                        ClipboardData(
                                            text: 'https://kawka-b.com/#/SharedQuestion/${questionProvider.question['id']}'));
                                    Timer(const Duration(seconds: 2), () {
                                      questionProvider.setCopied(false);
                                    });
                                  },
                                  child: Text(
                                      Provider.of<SharedQuestionProvider>(context, listen: true).copied?'تم النسخ':
                                      questionProvider.question['id']
                                          .substring(0, 8),
                                      style: textStyle(3, width, height,
                                          kDarkBlack)),
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
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
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
                                              onSubmitted: null,
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
                                              onTap: null,
                                              width: width * 0.38,
                                              verticalPadding:0,
                                              height: height*0.06,
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
                                InkWell(
                                  onTap: () {
                                    popUp(
                                        context,
                                        width * 0.2,
                                        height * 0.25,
                                        Center(
                                          child: Text(
                                            questionProvider.question['hint'] ==
                                                '' ||
                                                questionProvider.question['hint'] ==
                                                    null
                                                ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                : questionProvider.question['hint'],
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
                            InkWell(
                            onTap: () {
                              logIn(questionProvider, websiteProvider);
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.exit_to_app_outlined,
                                  size: width * 0.014,
                                  color: kDarkBlack,
                                ),
                                Text('تسجيل الدخول',
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
                      if (questionProvider.question['type'] ==
                          'multipleChoiceQuestion' &&
                          questionProvider.question['image'] ==
                              null)
                        multipleChoiceQuestionWithoutImage(
                            questionProvider, width, height)
                      else if (questionProvider.question['type'] ==
                          'multipleChoiceQuestion' &&
                          questionProvider.question['image'] !=
                              null)
                        multipleChoiceQuestionWithImage(
                            questionProvider, width, height)
                      else if (questionProvider.question['type'] ==
                            'finalAnswerQuestion' &&
                            questionProvider.question['image'] ==
                                null)
                          finalAnswerQuestionWithoutImage(
                              questionProvider, width, height)
                        else if (questionProvider.question['type'] ==
                              'finalAnswerQuestion' &&
                              questionProvider.question['image'] !=
                                  null)
                            finalAnswerQuestionWithImage(
                                questionProvider, width, height)
                          else if (questionProvider.question['type'] ==
                                'multiSectionQuestion' &&
                                questionProvider.question['image'] ==
                                    null)
                              multiSectionQuestionWithoutImage(
                                  questionProvider, width, height)
                            else if (questionProvider.question['type'] ==
                                  'multiSectionQuestion' &&
                                  questionProvider.question['image'] !=
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
                              height: height * 0.08,
                              verticalPadding: 0,
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
                                  logIn(questionProvider, websiteProvider):endQuestion(questionProvider);
                              },
                              width: width * 0.19,
                              height: height * 0.08,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              borderRadius: width * 0.005,
                              border: null,
                              buttonColor: kLightPurple,
                              child: Center(
                                child: Text(questionProvider.showResult? 'حل المزيد':'تأكيد الجواب',
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
