import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/dashboard.dart';
import '../screens/quiz_review.dart';
import '../screens/welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_question_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/tasks_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'dart:core';
import 'package:flutter/services.dart';

class Quiz extends StatefulWidget {
  static const String route = '/Quiz/';

  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  StopWatchTimer? quizTimer;
  Stopwatch stopwatch = Stopwatch();
  TextEditingController reportController = TextEditingController();

  void getQuiz() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('build_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'headlines': Provider.of<QuizProvider>(context, listen: false)
          .selectedHeadlines
          .toList(),
      'question_num':
          Provider.of<QuizProvider>(context, listen: false).questionNum,
      'quiz_level': Provider.of<QuizProvider>(context, listen: false).quizLevel,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : result.isEmpty
              ? Provider.of<QuizProvider>(context, listen: false)
                  .setNoQuestion(true)
              : {
                  if (Provider.of<QuizProvider>(context, listen: false)
                      .withTime)
                    {
                      quizTimer = StopWatchTimer(
                        mode: StopWatchMode.countDown,
                        onEnded: endQuiz,
                      ),
                      quizTimer!.setPresetTime(
                          mSec:
                              Provider.of<QuizProvider>(context, listen: false)
                                      .duration *
                                  1000),
                    }
                  else
                    {
                      quizTimer = StopWatchTimer(
                        mode: StopWatchMode.countUp,
                        onEnded: () {},
                      ),
                      quizTimer!.setPresetTime(mSec: 0),
                    },
                  print(result),
                  Provider.of<QuizProvider>(context, listen: false)
                      .setQuestions(result),
                  quizTimer!.onStartTimer(),
                  stopwatch.start(),
                  Provider.of<WebsiteProvider>(context, listen: false)
                      .setLoaded(true)
                };
    });
  }

  void saveQuestion(quizQuestionProvider, quizProvider, questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        quizProvider.answers[
                quizProvider.questions[quizQuestionProvider.questionIndex - 1]
                    ['id']]!['saved']
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
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              quizProvider.setSaveQuestion(quizProvider
                  .questions[quizQuestionProvider.questionIndex - 1]['id'])
            };
    });
  }

  void report(questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('report/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'body': reportController.text,
      'question_id': questionID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {Navigator.pop(context)};
    });
  }

  void endQuiz() async {
    stopwatch.stop();
    quizTimer?.onStopTimer();

    Provider.of<QuizQuestionProvider>(context, listen: false).setWait(true);

    Provider.of<QuizProvider>(context, listen: false).editAnswerDuration(
        Provider.of<QuizProvider>(context, listen: false).questions[
            Provider.of<QuizQuestionProvider>(context, listen: false)
                    .questionIndex -
                1]['id'],
        stopwatch.elapsed.inSeconds);

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('marking/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject': Provider.of<QuizProvider>(context, listen: false).subjectID,
      'answers': Provider.of<QuizProvider>(context, listen: false).answers,
      'quiz_duration':
          Provider.of<QuizProvider>(context, listen: false).duration,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              Provider.of<QuizProvider>(context, listen: false).setQuizResult(
                  '${result['correct_questions']}/${result['total_question_num']}'),
              Provider.of<QuizProvider>(context, listen: false)
                  .setQuizDuration(result['attempt_duration']),
              Provider.of<QuizProvider>(context, listen: false)
                  .setQuizIdealDuration(result['ideal_duration']),
              Provider.of<QuizProvider>(context, listen: false)
                  .setQuizID(result['quiz_id']),
              Provider.of<QuizProvider>(context, listen: false)
                  .setSkills(result['best_worst_skills']),
              Provider.of<TasksProvider>(context, listen: false).editDoneTask(
                  Provider.of<QuizProvider>(context, listen: false).subjectName,
                  Provider.of<QuizProvider>(context, listen: false)
                      .questionNum),
              Provider.of<QuizQuestionProvider>(context, listen: false)
                  .setWait(false),
              Provider.of<QuizQuestionProvider>(context, listen: false)
                  .setShowResult(true),
            };
    });
  }

  void retakeQuiz(quizQuestionProvider, quizProvider) async {
    quizQuestionProvider.setShowResult(false);
    quizQuestionProvider.setWait(true);

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('retake_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'quiz_id': quizProvider.quizID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              if (quizProvider.withTime)
                {
                  quizTimer = StopWatchTimer(
                    mode: StopWatchMode.countDown,
                    onEnded: endQuiz,
                  ),
                  quizTimer!.setPresetTime(mSec: quizProvider.duration * 1000),
                }
              else
                {
                  quizTimer = StopWatchTimer(
                    mode: StopWatchMode.countUp,
                    onEnded: () {},
                  ),
                  quizTimer!.setPresetTime(mSec: 0),
                },
              quizProvider.setQuestions(result),
              quizQuestionProvider.setQuestionIndex(1),
              quizQuestionProvider.setWait(false),
              quizTimer!.onStartTimer(),
              stopwatch.start(),
            };
    });
  }

  void similarQuiz(quizQuestionProvider, quizProvider) async {
    quizQuestionProvider.setShowResult(false);
    quizQuestionProvider.setWait(true);

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('similar_questions/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'questions_id': [
        for (Map question in quizProvider.questions) question['id']
      ],
      'by_author': true,
      'by_headlines': true,
      'by_level': true,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : result.isEmpty
              ? quizProvider.setNoQuestion(true)
              : {
                  if (quizProvider.withTime)
                    {
                      quizTimer = StopWatchTimer(
                        mode: StopWatchMode.countDown,
                        onEnded: endQuiz,
                      ),
                      quizTimer!
                          .setPresetTime(mSec: quizProvider.duration * 1000),
                    }
                  else
                    {
                      quizTimer = StopWatchTimer(
                        mode: StopWatchMode.countUp,
                        onEnded: () {},
                      ),
                      quizTimer!.setPresetTime(mSec: 0),
                    },
                  print(result),
                  print(result == []),
                  quizProvider.setQuestions(result),
                  quizQuestionProvider.setQuestionIndex(1),
                  quizQuestionProvider.setWait(false),
                  quizTimer!.onStartTimer(),
                  stopwatch.start(),
                };
    });
  }

  @override
  void initState() {
    getQuiz();
    super.initState();
  }

  Widget multipleChoiceQuestionWithoutImage(
      quizQuestionProvider, quizProvider, width, height) {
    int questionIndex = quizQuestionProvider.questionIndex - 1;
    Map question = quizProvider.questions[questionIndex];
    Map answer = quizProvider.answers[question['id']];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: height / 32),
              child: SizedBox(
                width: width * 0.84,
                child: stringWithLatex(
                    question['body'],
                    // width * 0.84,
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
                        onTap: () {
                          answer['answer'] == question['choices'][i]['id']
                              ? quizProvider
                                  .removeQuestionAnswer(question['id'])
                              : quizProvider.editQuestionAnswer(
                                  question['id'], question['choices'][i]['id']);
                        },
                        verticalPadding: width * 0.01,
                        horizontalPadding: width * 0.02,
                        width: width * 0.84,
                        borderRadius: width * 0.005,
                        border: null,
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
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (quizQuestionProvider.questionIndex != 1) ...[
                CustomContainer(
                  onTap: () {
                    stopwatch.stop();
                    quizProvider.editAnswerDuration(
                        quizProvider.questions[
                            quizQuestionProvider.questionIndex - 1]['id'],
                        stopwatch.elapsed.inSeconds);
                    stopwatch.reset();
                    quizQuestionProvider.setQuestionIndex(
                        quizQuestionProvider.questionIndex - 1);
                    stopwatch.start();
                  },
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: fullBorder(kLightPurple),
                  buttonColor: kDarkBlack,
                  child: Center(
                    child: Text('السابق',
                        style: textStyle(2, width, height, kLightPurple)),
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
              if (quizQuestionProvider.questionIndex == 1) ...[
                CustomContainer(
                  onTap: null,
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: null,
                  buttonColor: kTransparent,
                  child: null,
                ),
                SizedBox(width: width * 0.02),
              ],
              CustomContainer(
                onTap: () {
                  quizQuestionProvider.questionIndex !=
                          quizProvider.questions.length
                      ? {
                          stopwatch.stop(),
                          quizProvider.editAnswerDuration(
                              quizProvider.questions[
                                  quizQuestionProvider.questionIndex - 1]['id'],
                              stopwatch.elapsed.inSeconds),
                          stopwatch.reset(),
                          quizQuestionProvider.setQuestionIndex(
                              quizQuestionProvider.questionIndex + 1),
                          stopwatch.start(),
                        }
                      : endQuiz();
                },
                width: width * 0.19,
                verticalPadding: width * 0.005,
                horizontalPadding: 0,
                borderRadius: 8,
                border: null,
                buttonColor: kLightPurple,
                child: Center(
                  child: Text(
                      quizQuestionProvider.questionIndex !=
                              quizProvider.questions.length
                          ? 'التالي'
                          : 'انهاء الإمتحان',
                      style: textStyle(2, width, height, kDarkBlack)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget multipleChoiceQuestionWithImage(
      quizQuestionProvider, quizProvider, width, height) {
    int questionIndex = quizQuestionProvider.questionIndex - 1;
    Map question = quizProvider.questions[questionIndex];
    Map answer = quizProvider.answers[question['id']];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(bottom: height / 32),
            child: SizedBox(
              width: width * 0.84,
              child: stringWithLatex(
                  question['body'],
                  // width * 0.84,
                  3,
                  width,
                  height,
                  kWhite),
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
                          onTap: () {
                            answer['answer'] == question['choices'][i]['id']
                                ? quizProvider
                                    .removeQuestionAnswer(question['id'])
                                : quizProvider.editQuestionAnswer(
                                    question['id'],
                                    question['choices'][i]['id']);
                          },
                          verticalPadding: width * 0.01,
                          horizontalPadding: width * 0.02,
                          width: width * 0.4,
                          borderRadius: width * 0.005,
                          border: null,
                          buttonColor:
                              answer['answer'] == question['choices'][i]['id']
                                  ? kLightPurple
                                  : kDarkGray,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: stringWithLatex(
                                question['choices'][i]['body'],
                                3,
                                width,
                                height,
                                kWhite),
                          )),
                    ),
                ],
              ),
              SizedBox(width: width * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.3,
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
                height: height * 0.3,
                width: width * 0.3,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (quizQuestionProvider.questionIndex != 1) ...[
                CustomContainer(
                  onTap: () {
                    stopwatch.stop();
                    quizProvider.editAnswerDuration(
                        quizProvider.questions[
                            quizQuestionProvider.questionIndex - 1]['id'],
                        stopwatch.elapsed.inSeconds);
                    stopwatch.reset();
                    quizQuestionProvider.setQuestionIndex(
                        quizQuestionProvider.questionIndex - 1);
                    stopwatch.start();
                  },
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: fullBorder(kLightPurple),
                  buttonColor: kDarkBlack,
                  child: Center(
                    child: Text('السابق',
                        style: textStyle(2, width, height, kLightPurple)),
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
              if (quizQuestionProvider.questionIndex == 1) ...[
                CustomContainer(
                  onTap: null,
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: null,
                  buttonColor: kTransparent,
                  child: null,
                ),
                SizedBox(width: width * 0.02),
              ],
              CustomContainer(
                onTap: () {
                  quizQuestionProvider.questionIndex !=
                          quizProvider.questions.length
                      ? {
                          stopwatch.stop(),
                          quizProvider.editAnswerDuration(
                              quizProvider.questions[
                                  quizQuestionProvider.questionIndex - 1]['id'],
                              stopwatch.elapsed.inSeconds),
                          stopwatch.reset(),
                          quizQuestionProvider.setQuestionIndex(
                              quizQuestionProvider.questionIndex + 1),
                          stopwatch.start(),
                        }
                      : endQuiz();
                },
                width: width * 0.19,
                verticalPadding: width * 0.005,
                horizontalPadding: 0,
                borderRadius: 8,
                border: null,
                buttonColor: kLightPurple,
                child: Center(
                  child: Text(
                      quizQuestionProvider.questionIndex !=
                              quizProvider.questions.length
                          ? 'التالي'
                          : 'انهاء الإمتحان',
                      style: textStyle(2, width, height, kDarkBlack)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget finalAnswerQuestionWithoutImage(
      quizQuestionProvider, quizProvider, width, height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(bottom: height / 32),
            child: SizedBox(
              width: width * 0.84,
              child: stringWithLatex(
                  quizProvider.questions[quizQuestionProvider.questionIndex - 1]
                      ['body'],
                  // width * 0.84,
                  3,
                  width,
                  height,
                  kWhite),
            ),
          ),
          CustomTextField(
            controller: TextEditingController(),
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
                quizProvider.removeQuestionAnswer(quizProvider
                    .questions[quizQuestionProvider.questionIndex - 1]['id']);
              } else {
                quizProvider.editQuestionAnswer(
                    quizProvider
                            .questions[quizQuestionProvider.questionIndex - 1]
                        ['id'],
                    text);
              }
            },
            onSubmitted: null,
            backgroundColor: kDarkGray,
            verticalPadding: width * 0.01,
            horizontalPadding: width * 0.02,
            isDense: null,
            innerText: quizProvider.answers[
                quizProvider.questions[quizQuestionProvider.questionIndex - 1]
                    ['id']]!['answer'],
            errorText: null,
            hintText: 'اكتب الجواب النهائي',
            hintTextColor: kWhite.withOpacity(0.5),
            suffixIcon: null,
            prefixIcon: null,
            border: outlineInputBorder(width * 0.005, kTransparent),
            focusedBorder: outlineInputBorder(width * 0.005, kLightPurple),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (quizQuestionProvider.questionIndex != 1) ...[
                CustomContainer(
                  onTap: () {
                    stopwatch.stop();
                    quizProvider.editAnswerDuration(
                        quizProvider.questions[
                            quizQuestionProvider.questionIndex - 1]['id'],
                        stopwatch.elapsed.inSeconds);
                    stopwatch.reset();
                    quizQuestionProvider.setQuestionIndex(
                        quizQuestionProvider.questionIndex - 1);
                    stopwatch.start();
                  },
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: fullBorder(kLightPurple),
                  buttonColor: kDarkBlack,
                  child: Center(
                    child: Text('السابق',
                        style: textStyle(2, width, height, kLightPurple)),
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
              if (quizQuestionProvider.questionIndex == 1) ...[
                CustomContainer(
                  onTap: null,
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: null,
                  buttonColor: kTransparent,
                  child: null,
                ),
                SizedBox(width: width * 0.02),
              ],
              CustomContainer(
                onTap: () {
                  quizQuestionProvider.questionIndex !=
                          quizProvider.questions.length
                      ? {
                          stopwatch.stop(),
                          quizProvider.editAnswerDuration(
                              quizProvider.questions[
                                  quizQuestionProvider.questionIndex - 1]['id'],
                              stopwatch.elapsed.inSeconds),
                          stopwatch.reset(),
                          quizQuestionProvider.setQuestionIndex(
                              quizQuestionProvider.questionIndex + 1),
                          stopwatch.start(),
                        }
                      : endQuiz();
                },
                width: width * 0.19,
                verticalPadding: width * 0.005,
                horizontalPadding: 0,
                borderRadius: 8,
                border: null,
                buttonColor: kLightPurple,
                child: Center(
                  child: Text(
                      quizQuestionProvider.questionIndex !=
                              quizProvider.questions.length
                          ? 'التالي'
                          : 'انهاء الإمتحان',
                      style: textStyle(2, width, height, kDarkBlack)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget finalAnswerQuestionWithImage(
      quizQuestionProvider, quizProvider, width, height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: height / 32),
              child: SizedBox(
                width: width * 0.84,
                child: stringWithLatex(
                    quizProvider
                            .questions[quizQuestionProvider.questionIndex - 1]
                        ['body'],
                    // width * 0.84,
                    3,
                    width,
                    height,
                    kWhite),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: TextEditingController(),
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
                  onChanged: (String text) {
                    if (text == '') {
                      quizProvider.removeQuestionAnswer(quizProvider
                              .questions[quizQuestionProvider.questionIndex - 1]
                          ['id']);
                    } else {
                      quizProvider.editQuestionAnswer(
                          quizProvider.questions[
                              quizQuestionProvider.questionIndex - 1]['id'],
                          text);
                    }
                  },
                  onSubmitted: null,
                  backgroundColor: kDarkGray,
                  verticalPadding: width * 0.01,
                  horizontalPadding: width * 0.02,
                  isDense: null,
                  innerText: quizProvider.answers[quizProvider
                          .questions[quizQuestionProvider.questionIndex - 1]
                      ['id']]!['answer'],
                  errorText: null,
                  hintText: 'اكتب الجواب النهائي',
                  hintTextColor: kWhite.withOpacity(0.5),
                  suffixIcon: null,
                  prefixIcon: null,
                  border: outlineInputBorder(width * 0.005, kTransparent),
                  focusedBorder:
                      outlineInputBorder(width * 0.005, kLightPurple),
                ),
                SizedBox(width: width * 0.02),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.3,
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
                  image: NetworkImage(quizProvider
                          .questions[quizQuestionProvider.questionIndex - 1]
                      ['image']),
                  height: height * 0.3,
                  width: width * 0.3,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (quizQuestionProvider.questionIndex != 1) ...[
                CustomContainer(
                  onTap: () {
                    stopwatch.stop();
                    quizProvider.editAnswerDuration(
                        quizProvider.questions[
                            quizQuestionProvider.questionIndex - 1]['id'],
                        stopwatch.elapsed.inSeconds);
                    stopwatch.reset();
                    quizQuestionProvider.setQuestionIndex(
                        quizQuestionProvider.questionIndex - 1);
                    stopwatch.start();
                  },
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: fullBorder(kLightPurple),
                  buttonColor: kDarkBlack,
                  child: Center(
                    child: Text('السابق',
                        style: textStyle(2, width, height, kLightPurple)),
                  ),
                ),
                SizedBox(width: width * 0.02),
              ],
              if (quizQuestionProvider.questionIndex == 1) ...[
                CustomContainer(
                  onTap: null,
                  width: width * 0.19,
                  verticalPadding: width * 0.005,
                  horizontalPadding: 0,
                  borderRadius: 8,
                  border: null,
                  buttonColor: kTransparent,
                  child: null,
                ),
                SizedBox(width: width * 0.02),
              ],
              CustomContainer(
                onTap: () {
                  quizQuestionProvider.questionIndex !=
                          quizProvider.questions.length
                      ? {
                          stopwatch.stop(),
                          quizProvider.editAnswerDuration(
                              quizProvider.questions[
                                  quizQuestionProvider.questionIndex - 1]['id'],
                              stopwatch.elapsed.inSeconds),
                          stopwatch.reset(),
                          quizQuestionProvider.setQuestionIndex(
                              quizQuestionProvider.questionIndex + 1),
                          stopwatch.start(),
                        }
                      : endQuiz();
                },
                width: width * 0.19,
                verticalPadding: width * 0.005,
                horizontalPadding: 0,
                borderRadius: 8,
                border: null,
                buttonColor: kLightPurple,
                child: Center(
                  child: Text(
                      quizQuestionProvider.questionIndex !=
                              quizProvider.questions.length
                          ? 'التالي'
                          : 'انهاء الإمتحان',
                      style: textStyle(2, width, height, kDarkBlack)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget multiSectionQuestionWithoutImage(
      quizQuestionProvider, quizProvider, width, height) {
    int questionIndexActive = quizQuestionProvider.questionIndex - 1;
    Map questionActive = quizProvider.questions[questionIndexActive];
    Map answerActive = quizProvider.answers[questionActive['id']];

    return Column(
      children: [
        SizedBox(height: height * 0.1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: SizedBox(
            width: width * 0.84,
            child: stringWithLatex(
                questionActive['body'], 3, width, height, kWhite),
          ),
        ),
        SizedBox(height: height * 0.05),
        SizedBox(
            height: height * 0.7,
            width: width * 0.85,
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
                    for (Map subQuestion
                        in questionActive['sub_questions']) ...[
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            child: Padding(
                              padding: EdgeInsets.only(right: width * 0.025),
                              child: SizedBox(
                                width: width * 0.84,
                                child: stringWithLatex(subQuestion['body'], 3,
                                    width, height, kWhite),
                              ),
                            ),
                          )),
                      SizedBox(height: height * 0.01),
                      if (subQuestion['type'] == 'finalAnswerQuestion')
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              child: Padding(
                                padding: EdgeInsets.only(right: width * 0.025),
                                child: CustomTextField(
                                  controller: TextEditingController(),
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
                                      Provider.of<QuizProvider>(context,
                                              listen: false)
                                          .removeSubQuestionAnswer(
                                              questionActive['id'],
                                              subQuestion['id']);
                                    } else {
                                      Provider.of<QuizProvider>(context,
                                              listen: false)
                                          .editSubQuestionAnswer(
                                              questionActive['id'],
                                              subQuestion['id'],
                                              text);
                                    }
                                  },
                                  onSubmitted: null,
                                  backgroundColor: kDarkGray,
                                  verticalPadding: width * 0.01,
                                  horizontalPadding: width * 0.02,
                                  isDense: null,
                                  innerText: answerActive['answer'] == null
                                      ? null
                                      : answerActive['answer']
                                          [subQuestion['id']],
                                  errorText: null,
                                  hintText: 'اكتب الجواب النهائي',
                                  hintTextColor: kWhite.withOpacity(0.5),
                                  suffixIcon: null,
                                  prefixIcon: null,
                                  border: outlineInputBorder(
                                      width * 0.005, kTransparent),
                                  focusedBorder: outlineInputBorder(
                                      width * 0.005, kLightPurple),
                                ),
                              )),
                        )
                      else if (subQuestion['type'] == 'multipleChoiceQuestion')
                        Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              child: Padding(
                                padding: EdgeInsets.only(right: width * 0.025),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i < subQuestion['choices'].length;
                                        i++)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height / 64),
                                        child: CustomContainer(
                                            onTap: () {
                                              if (answerActive
                                                      .containsKey('answer') &&
                                                  answerActive['answer']
                                                      .containsKey(
                                                          subQuestion['id']) &&
                                                  answerActive['answer']
                                                          [subQuestion['id']] ==
                                                      subQuestion['choices'][i]
                                                          ['id']) {
                                                Provider.of<QuizProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeSubQuestionAnswer(
                                                        questionActive['id'],
                                                        subQuestion['id']);
                                              } else {
                                                Provider.of<QuizProvider>(
                                                        context,
                                                        listen: false)
                                                    .editSubQuestionAnswer(
                                                        questionActive['id'],
                                                        subQuestion['id'],
                                                        subQuestion['choices']
                                                            [i]['id']);
                                              }
                                            },
                                            verticalPadding: width * 0.01,
                                            horizontalPadding: width * 0.02,
                                            width: width * 0.79,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: answerActive
                                                        .containsKey(
                                                            'answer') &&
                                                    answerActive['answer']
                                                        .containsKey(
                                                            subQuestion[
                                                                'id']) &&
                                                    answerActive['answer'][
                                                            subQuestion[
                                                                'id']] ==
                                                        subQuestion['choices']
                                                            [i]['id']
                                                ? kLightPurple
                                                : kDarkGray,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: stringWithLatex(
                                                  subQuestion['choices'][i]
                                                      ['body'],
                                                  3,
                                                  width,
                                                  height,
                                                  kWhite),
                                            )),
                                      ),
                                  ],
                                ),
                              ),
                            )),
                      SizedBox(height: height * 0.025),
                    ],
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (quizQuestionProvider.questionIndex != 1) ...[
                              CustomContainer(
                                onTap: () {
                                  stopwatch.stop();
                                  quizProvider.editAnswerDuration(
                                      quizProvider.questions[
                                          quizQuestionProvider.questionIndex -
                                              1]['id'],
                                      stopwatch.elapsed.inSeconds);
                                  stopwatch.reset();
                                  quizQuestionProvider.setQuestionIndex(
                                      quizQuestionProvider.questionIndex - 1);
                                  stopwatch.start();
                                },
                                width: width * 0.19,
                                verticalPadding: width * 0.005,
                                horizontalPadding: 0,
                                borderRadius: 8,
                                border: fullBorder(kLightPurple),
                                buttonColor: kDarkBlack,
                                child: Center(
                                  child: Text('السابق',
                                      style: textStyle(
                                          2, width, height, kLightPurple)),
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                            ],
                            if (quizQuestionProvider.questionIndex == 1) ...[
                              CustomContainer(
                                onTap: null,
                                width: width * 0.19,
                                verticalPadding: width * 0.005,
                                horizontalPadding: 0,
                                borderRadius: 8,
                                border: null,
                                buttonColor: kTransparent,
                                child: null,
                              ),
                              SizedBox(width: width * 0.02),
                            ],
                            CustomContainer(
                              onTap: () {
                                quizQuestionProvider.questionIndex !=
                                        quizProvider.questions.length
                                    ? {
                                        stopwatch.stop(),
                                        quizProvider.editAnswerDuration(
                                            quizProvider.questions[
                                                quizQuestionProvider
                                                        .questionIndex -
                                                    1]['id'],
                                            stopwatch.elapsed.inSeconds),
                                        stopwatch.reset(),
                                        quizQuestionProvider.setQuestionIndex(
                                            quizQuestionProvider.questionIndex +
                                                1),
                                        stopwatch.start(),
                                      }
                                    : endQuiz();
                              },
                              width: width * 0.19,
                              verticalPadding: width * 0.005,
                              horizontalPadding: 0,
                              borderRadius: 8,
                              border: null,
                              buttonColor: kLightPurple,
                              child: Center(
                                child: Text(
                                    quizQuestionProvider.questionIndex !=
                                            quizProvider.questions.length
                                        ? 'التالي'
                                        : 'انهاء الإمتحان',
                                    style: textStyle(
                                        2, width, height, kDarkBlack)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    QuizQuestionProvider quizQuestionProvider =
        Provider.of<QuizQuestionProvider>(context);
    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    TasksProvider tasksProvider = Provider.of<TasksProvider>(context);

    return quizProvider.noQuestion
        ? Scaffold(
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
                    'لا يوجد اسئلة لهذه المواضيع حاليا\nستتوفر قريبا',
                    textAlign: TextAlign.center,
                    style: textStyle(3, width, height, kLightPurple),
                  ),
                  SizedBox(height: height * 0.06),
                  CustomContainer(
                    onTap: () {
                      websiteProvider.setLoaded(false);
                      Navigator.pushNamed(context, Dashboard.route);
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
          )
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
                          AssetImage("images/single_question_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomContainer(
                              height: height,
                              width: width * 0.08,
                              buttonColor: kLightPurple,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                                quizProvider.questions[
                                                            quizQuestionProvider
                                                                    .questionIndex -
                                                                1]['writer'] ==
                                                        'نمط اسئلة الكتاب'
                                                    ? 'هذا السؤال على نمط اسئلة الكتاب'
                                                    : 'هذا السؤال من اسئلة الاستاذ ${quizProvider.questions[quizQuestionProvider.questionIndex - 1]['writer']}',
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
                                            Icons.lightbulb_outline_rounded,
                                            size: width * 0.014,
                                            color: kDarkBlack,
                                          ),
                                          Text('معلومات السؤال',
                                              textAlign: TextAlign.center,
                                              style: textStyle(4, width, height,
                                                  kDarkBlack)),
                                        ],
                                      ),
                                    ),
                                    CustomContainer(
                                      onTap: () {
                                        saveQuestion(
                                            quizQuestionProvider,
                                            quizProvider,
                                            quizProvider.questions[
                                                quizQuestionProvider
                                                        .questionIndex -
                                                    1]['id']);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            quizProvider.answers[
                                                    quizProvider.questions[
                                                        quizQuestionProvider
                                                                .questionIndex -
                                                            1]['id']]!['saved']
                                                ? Icons.bookmark_add_rounded
                                                : Icons.bookmark_add_outlined,
                                            size: width * 0.014,
                                            color: kDarkBlack,
                                          ),
                                          Text('حفظ السؤال',
                                              textAlign: TextAlign.center,
                                              style: textStyle(4, width, height,
                                                  kDarkBlack)),
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
                                        Text(
                                            '${quizQuestionProvider.questionIndex}/${quizProvider.questions.length}',
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
                                                style: textStyle(3, width,
                                                    height, kDarkBlack));
                                          },
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Text('رمز السؤال',
                                                textAlign: TextAlign.center,
                                                style: textStyle(3, width,
                                                    height, kDarkBlack)),
                                            CustomContainer(
                                              onTap: () async {
                                                quizQuestionProvider
                                                    .setCopied(true);
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: quizProvider
                                                                .questions[
                                                            quizQuestionProvider
                                                                    .questionIndex -
                                                                1]['id']));
                                                Timer(Duration(seconds: 2), () {
                                                  quizQuestionProvider
                                                      .setCopied(false);
                                                });
                                              },
                                              child: Text(
                                                  quizProvider.questions[
                                                          quizQuestionProvider
                                                                  .questionIndex -
                                                              1]['id']
                                                      .substring(0, 8),
                                                  style: textStyle(3, width,
                                                      height, kDarkBlack)),
                                            ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: quizQuestionProvider.copied,
                                          child: CustomContainer(
                                            borderRadius: width * 0.05,
                                            buttonColor: kDarkBlack,
                                            border: fullBorder(kLightPurple),
                                            horizontalPadding: width * 0.005,
                                            verticalPadding: height * 0.005,
                                            child: Text('تم النسخ',
                                                textAlign: TextAlign.center,
                                                style: textStyle(5, width,
                                                    height, kLightPurple)),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'ملاحظاتك',
                                                      style: textStyle(2, width,
                                                          height, kLightPurple),
                                                    ),
                                                    CustomTextField(
                                                      controller:
                                                          reportController,
                                                      width: width * 0.38,
                                                      fontOption: 4,
                                                      fontColor: kLightPurple,
                                                      textAlign: null,
                                                      obscure: false,
                                                      readOnly: false,
                                                      focusNode: null,
                                                      maxLines: null,
                                                      maxLength: null,
                                                      keyboardType: null,
                                                      onChanged:
                                                          (String text) {},
                                                      onSubmitted: (value) {
                                                        report(quizProvider
                                                                .questions[
                                                            quizQuestionProvider
                                                                    .questionIndex -
                                                                1]['id']);
                                                      },
                                                      backgroundColor:
                                                          kDarkBlack,
                                                      verticalPadding:
                                                          height * 0.02,
                                                      horizontalPadding:
                                                          width * 0.02,
                                                      isDense: null,
                                                      innerText: null,
                                                      errorText: null,
                                                      hintText: 'ادخل ملاحظاتك',
                                                      hintTextColor:
                                                          kLightPurple
                                                              .withOpacity(0.5),
                                                      suffixIcon: null,
                                                      prefixIcon: null,
                                                      border:
                                                          outlineInputBorder(
                                                              width * 0.005,
                                                              kLightPurple),
                                                      focusedBorder:
                                                          outlineInputBorder(
                                                              width * 0.005,
                                                              kLightPurple),
                                                    ),
                                                    CustomContainer(
                                                      onTap: () {
                                                        report(quizProvider
                                                                .questions[
                                                            quizQuestionProvider
                                                                    .questionIndex -
                                                                1]['id']);
                                                      },
                                                      width: width * 0.38,
                                                      verticalPadding:
                                                          height * 0.02,
                                                      horizontalPadding:
                                                          width * 0.02,
                                                      borderRadius:
                                                          width * 0.005,
                                                      buttonColor: kLightPurple,
                                                      child: Center(
                                                        child: Text(
                                                          'تأكيد',
                                                          style: textStyle(
                                                              3,
                                                              width,
                                                              height,
                                                              kDarkBlack),
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
                                                style: textStyle(4, width,
                                                    height, kDarkBlack),
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
                                                    quizProvider.questions[quizQuestionProvider
                                                                            .questionIndex -
                                                                        1]
                                                                    ['hint'] ==
                                                                '' ||
                                                            quizProvider.questions[
                                                                        quizQuestionProvider
                                                                                .questionIndex -
                                                                            1]
                                                                    ['hint'] ==
                                                                null
                                                        ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                        : quizProvider
                                                                .questions[
                                                            quizQuestionProvider
                                                                    .questionIndex -
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
                                                  style: textStyle(4, width,
                                                      height, kDarkBlack)),
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
                                                  'هل تريد انهاء الامتحان',
                                                  style: textStyle(3, width,
                                                      height, kLightPurple),
                                                ),
                                                SizedBox(height: height * 0.04),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomContainer(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      width: width * 0.08,
                                                      verticalPadding:
                                                          height * 0.005,
                                                      horizontalPadding: 0,
                                                      borderRadius:
                                                          width * 0.005,
                                                      buttonColor: kDarkBlack,
                                                      border: fullBorder(
                                                          kLightPurple),
                                                      child: Center(
                                                        child: Text(
                                                          'لا',
                                                          style: textStyle(
                                                              3,
                                                              width,
                                                              height,
                                                              kLightPurple),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * 0.02),
                                                    CustomContainer(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        endQuiz();
                                                      },
                                                      width: width * 0.08,
                                                      verticalPadding:
                                                          height * 0.005,
                                                      horizontalPadding: 0,
                                                      borderRadius:
                                                          width * 0.005,
                                                      buttonColor: kLightPurple,
                                                      border: null,
                                                      child: Center(
                                                        child: Text(
                                                          'نعم',
                                                          style: textStyle(
                                                              3,
                                                              width,
                                                              height,
                                                              kDarkBlack),
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
                                          Text('إنهاء الإمتحان',
                                              textAlign: TextAlign.center,
                                              style: textStyle(4, width, height,
                                                  kDarkBlack)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(),
                                  ],
                                ),
                              )),
                          SizedBox(width: width * 0.03),
                          if (quizProvider.questions[
                                      quizQuestionProvider.questionIndex - 1]
                                  ['type'] ==
                              'multipleChoiceQuestion')
                            if (quizProvider.questions[
                                        quizQuestionProvider.questionIndex - 1]
                                    ['image'] ==
                                null)
                              multipleChoiceQuestionWithoutImage(
                                  quizQuestionProvider,
                                  quizProvider,
                                  width,
                                  height)
                            else
                              multipleChoiceQuestionWithImage(
                                  quizQuestionProvider,
                                  quizProvider,
                                  width,
                                  height)
                          else if (quizProvider.questions[
                                      quizQuestionProvider.questionIndex - 1]
                                  ['type'] ==
                              'finalAnswerQuestion')
                            if (quizProvider.questions[
                                        quizQuestionProvider.questionIndex - 1]
                                    ['image'] ==
                                null)
                              finalAnswerQuestionWithoutImage(
                                  quizQuestionProvider,
                                  quizProvider,
                                  width,
                                  height)
                            else
                              finalAnswerQuestionWithImage(quizQuestionProvider,
                                  quizProvider, width, height)
                          else if (quizProvider.questions[
                                      quizQuestionProvider.questionIndex - 1]
                                  ['type'] ==
                              'multiSectionQuestion')
                            if (quizProvider.questions[
                                        quizQuestionProvider.questionIndex - 1]
                                    ['image'] ==
                                null)
                              multiSectionQuestionWithoutImage(
                                  quizQuestionProvider,
                                  quizProvider,
                                  width,
                                  height)
                        ],
                      ),
                      Visibility(
                        visible: quizQuestionProvider.wait ||
                            quizQuestionProvider.showResult,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: quizQuestionProvider.wait,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: kPurple, strokeWidth: width * 0.05))),
                      Visibility(
                        visible: quizQuestionProvider.showResult,
                        child: Center(
                          child: CustomContainer(
                            onTap: null,
                            width: width * 0.5,
                            height: height * 0.77,
                            verticalPadding: height * 0.03,
                            horizontalPadding: width * 0.02,
                            borderRadius: width * 0.01,
                            border: fullBorder(kDarkBlack),
                            buttonColor: kLightBlack,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    Text(
                                      'أحسنت ، لقد أنهيت امتحانك !',
                                      style: textStyle(
                                          2, width, height, kLightPurple),
                                    ),
                                    CustomContainer(
                                      onTap: () {
                                        websiteProvider.setLoaded(false);
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
                                      },
                                      buttonColor: kTransparent,
                                      border: fullBorder(kLightPurple),
                                      borderRadius: width,
                                      child: Icon(
                                        Icons.home_rounded,
                                        size: width * 0.02,
                                        color: kLightPurple,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.65,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'العلامة :  ${quizProvider.quizResult}',
                                            style: textStyle(
                                                3, width, height, kLightPurple),
                                          ),
                                          SizedBox(
                                            width: width * 0.28,
                                            child: CustomDivider(
                                              dashHeight: 1,
                                              dashWidth: width * 0.005,
                                              dashColor: kDarkGray,
                                              direction: Axis.horizontal,
                                              fillRate: 0.6,
                                            ),
                                          ),
                                          Text(
                                            'مهامك اكتملت بنسبة :',
                                            style: textStyle(
                                                3, width, height, kLightPurple),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomContainer(
                                                onTap: null,
                                                width: width * 0.22,
                                                height: height * 0.02,
                                                verticalPadding: 0,
                                                horizontalPadding: 0,
                                                buttonColor: kLightGray,
                                                border: null,
                                                borderRadius: width * 0.01,
                                                child: Row(
                                                  children: [
                                                    CustomContainer(
                                                        onTap: null,
                                                        width: width * 0.22 * tasksProvider.tasks[quizProvider.subjectName]['task'] == 0
                                                            ? 0
                                                            : (tasksProvider.tasks[quizProvider.subjectName]['done'] / tasksProvider.tasks[quizProvider.subjectName]['task']) *
                                                                width *
                                                                0.22,
                                                        height: height * 0.02,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        buttonColor: kSkin,
                                                        border: null,
                                                        borderRadius:
                                                            width * 0.01,
                                                        child: (tasksProvider.tasks[quizProvider.subjectName]['done'] / tasksProvider.tasks[quizProvider.subjectName]['task'] * 100)
                                                                    .toStringAsFixed(
                                                                        0) ==
                                                                '100'
                                                            ? Center(
                                                                child: Text('100%',
                                                                    style: textStyle(
                                                                        5,
                                                                        width,
                                                                        height,
                                                                        kLightBlack)))
                                                            : const SizedBox()),
                                                    if ((tasksProvider.tasks[
                                                                    quizProvider
                                                                        .subjectName]
                                                                ['done'] !=
                                                            tasksProvider.tasks[
                                                                    quizProvider
                                                                        .subjectName]
                                                                ['task']) ||
                                                        tasksProvider.tasks[
                                                                    quizProvider
                                                                        .subjectName]
                                                                ['task'] ==
                                                            0) ...[
                                                      SizedBox(
                                                          width: width * 0.005),
                                                      Text(
                                                          tasksProvider.tasks[quizProvider
                                                                          .subjectName]
                                                                      [
                                                                      'task'] ==
                                                                  0
                                                              ? '0%'
                                                              : '${(tasksProvider.tasks[quizProvider.subjectName]['done'] / tasksProvider.tasks[quizProvider.subjectName]['task'] * 100).toStringAsFixed(0)}%',
                                                          style: textStyle(
                                                              5,
                                                              width,
                                                              height,
                                                              kLightBlack)),
                                                    ]
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: width * 0.02,
                                              ),
                                              Text(
                                                'أظهر المزيد',
                                                style: textStyle(5, width,
                                                    height, kLightPurple),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(),
                                          const SizedBox(),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.31,
                                            height: height * 0.1,
                                            verticalPadding: height * 0.01,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: width * 0.008,
                                            border: null,
                                            buttonColor: kDarkGray,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'الوقت المستهلك للحل :',
                                                      style: textStyle(3, width,
                                                          height, kLightPurple),
                                                    ),
                                                    Text(
                                                      quizProvider.quizDuration,
                                                      style: textStyle(3, width,
                                                          height, kWhite),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(),
                                                CustomContainer(
                                                    onTap: null,
                                                    width: width * 0.05,
                                                    height: height * 0.06,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.008,
                                                    border: null,
                                                    buttonColor: kLightPurple,
                                                    child: Center(
                                                      child: Text(
                                                        'الوقت',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kLightBlack),
                                                      ),
                                                    )),
                                                const SizedBox(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'الوقت المثالي للحل :',
                                                      style: textStyle(3, width,
                                                          height, kLightPurple),
                                                    ),
                                                    Text(
                                                      quizProvider
                                                          .idealDuration,
                                                      style: textStyle(3, width,
                                                          height, kWhite),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(),
                                          const SizedBox(),
                                          SizedBox(
                                            width: width * 0.25,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'معدل التحصيل في مهارات الامتحان',
                                                  style: textStyle(3, width,
                                                      height, kLightPurple),
                                                ),
                                                CustomContainer(
                                                  onTap: () {
                                                    websiteProvider
                                                        .setLoaded(false);
                                                    Navigator.pushNamed(context,
                                                        QuizReview.route);
                                                  },
                                                  verticalPadding:
                                                      height * 0.01,
                                                  horizontalPadding:
                                                      width * 0.01,
                                                  borderRadius: width * 0.005,
                                                  border: null,
                                                  buttonColor: kTransparent,
                                                  child: Text(
                                                    'أظهر المزيد',
                                                    style: textStyle(5, width,
                                                        height, kLightPurple),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          for (MapEntry skill
                                              in quizProvider.skills.entries)
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CustomContainer(
                                                  onTap: null,
                                                  height: height * 0.05,
                                                  width: width * 0.26,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: null,
                                                  buttonColor: kDarkGray,
                                                  child: Row(
                                                    children: [
                                                      CustomContainer(
                                                          onTap: null,
                                                          height: height * 0.05,
                                                          width: width *
                                                              0.26 *
                                                              skill.value[
                                                                  'correct'] /
                                                              skill
                                                                  .value['all'],
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: null,
                                                          buttonColor: kPurple,
                                                          child:
                                                              const SizedBox()),
                                                    ],
                                                  ),
                                                ),
                                                CustomContainer(
                                                  onTap: null,
                                                  width: width * 0.26,
                                                  verticalPadding: 0,
                                                  horizontalPadding:
                                                      width * 0.01,
                                                  borderRadius: 0,
                                                  border: null,
                                                  buttonColor:
                                                      Colors.transparent,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        skill.key,
                                                        style: textStyle(
                                                            4,
                                                            width,
                                                            height,
                                                            kWhite),
                                                      ),
                                                      Text(
                                                        '${(100 * skill.value['correct'] / skill.value['all']).toStringAsFixed(0)}%',
                                                        style: textStyle(
                                                            4,
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
                                      CustomDivider(
                                        dashHeight: 1,
                                        dashWidth: width * 0.005,
                                        dashColor: kDarkGray,
                                        direction: Axis.vertical,
                                        fillRate: 0.6,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          CustomContainer(
                                            onTap: () {
                                              websiteProvider.setLoaded(false);
                                              Navigator.pushNamed(
                                                  context, QuizReview.route);
                                            },
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kLightPurple,
                                            child: Center(
                                              child: Text(
                                                'ملخص وتحليل الامتحان',
                                                style: textStyle(3, width,
                                                    height, kDarkBlack),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kLightPurple,
                                            child: Center(
                                              child: Text(
                                                'تقرير تقدم المادة',
                                                style: textStyle(3, width,
                                                    height, kDarkBlack),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: () {
                                              similarQuiz(quizQuestionProvider,
                                                  quizProvider);
                                            },
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kLightPurple,
                                            child: Center(
                                              child: Text(
                                                'حل امتحان شبيه',
                                                style: textStyle(3, width,
                                                    height, kDarkBlack),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: () {
                                              retakeQuiz(quizQuestionProvider,
                                                  quizProvider);
                                            },
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kLightPurple,
                                            child: Center(
                                              child: Text('اعادة الامتحان',
                                                  style: textStyle(3, width,
                                                      height, kDarkBlack)),
                                            ),
                                          ),
                                          const SizedBox(),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.015,
                                            borderRadius: width * 0.005,
                                            border: fullBorder(kLightPurple),
                                            buttonColor: kLightBlack,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('قائمة المتصدرين',
                                                    style: textStyle(3, width,
                                                        height, kLightPurple)),
                                                Icon(
                                                  Icons.emoji_events_outlined,
                                                  size: width * 0.02,
                                                  color: kWhite,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.13,
                                            height: height * 0.06,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.015,
                                            borderRadius: width * 0.005,
                                            border: fullBorder(kLightPurple),
                                            buttonColor: kLightBlack,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('مجتمع مدارس',
                                                    style: textStyle(3, width,
                                                        height, kLightPurple)),
                                                Icon(
                                                  Icons.groups,
                                                  size: width * 0.02,
                                                  color: kWhite,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(),
                                          const SizedBox(),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
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
