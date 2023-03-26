import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/dashboard.dart';
import 'package:sarmadi/screens/quiz_result.dart';
import 'package:sarmadi/screens/welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'advance_quiz_setting.dart';
import 'dart:core';
import 'package:flutter/services.dart';

class Question extends StatefulWidget {
  static const String route = '/Question/';

  final int? duration;
  final List? questions;
  final String? subjectID;
  const Question({super.key, this.duration, this.questions, this.subjectID});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool loaded = false;

  bool showResult = false;
  bool waitResult = false;

  bool copied = false;

  String quizResult = '0/0';
  String quizDuration = '00:00:00';
  String ideal_duration = '00:00:00';

  String _subjectID = '';

  List questions = [];

  Map<String, Map<String, dynamic>> answers = {};

  int questionIndex = 1;
  Stopwatch stopwatch = Stopwatch();

  void endQuiz() async {
    stopwatch.stop();
    quizTimer?.onStopTimer();

    setState(() {
      waitResult = true;
    });

    answers[questions[questionIndex - 1]['id']]!['duration'] +=
        stopwatch.elapsed.inSeconds;

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('marking/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject': _subjectID,
      'answers': answers,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              quizResult =
                  '${result['correct_questions']}/${result['total_question_num']}';
              quizDuration = result['attempt_duration'];
              ideal_duration = result['ideal_duration'];
              Provider.of<QuizProvider>(context, listen: false)
                  .setQuizID(result['quiz_id']);
              waitResult = false;
              showResult = true;
            });
    });
  }

  void saveQuestion(questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        answers[questions[questionIndex - 1]['id']]!['saved']
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
          : setState(() {
              answers[questions[questionIndex - 1]['id']]!['saved'] =
                  !answers[questions[questionIndex - 1]['id']]!['saved'];
            });
    });
  }

  StopWatchTimer? quizTimer;

  @override
  void initState() {
    if (Provider.of<QuizProvider>(context, listen: false).withTime) {
      quizTimer = StopWatchTimer(
        mode: StopWatchMode.countDown,
        onEnded: endQuiz,
      );
    } else {
      quizTimer = StopWatchTimer(
        mode: StopWatchMode.countUp,
        onEnded: () {},
      );
    }
    Future.delayed(Duration.zero, () {
      try {
        dynamic arguments = ModalRoute.of(context)?.settings.arguments;
        setState(() {
          if (Provider.of<QuizProvider>(context, listen: false).withTime) {
            quizTimer!.setPresetTime(mSec: arguments['duration'] * 1000);
          } else {
            quizTimer!.setPresetTime(mSec: 1);
          }
          questions = arguments['questions'];
          print(questions);
          _subjectID = arguments['subjectID'];
          for (Map question in questions) {
            answers[question['id']] = {'duration': 0, 'saved': false};
          }
          print(answers);
          loaded = true;
          print(loaded);
        });
      } catch (e) {
        Navigator.pushNamed(context, AdvanceQuizSetting.route);
      }
    });

    super.initState();
    quizTimer!.onStartTimer();
    stopwatch.start();
  }

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
                                            questions[questionIndex - 1]
                                                        ['writer'] ==
                                                    'نمط اسئلة الكتاب'
                                                ? 'هذا السؤال على نمط اسئلة الكتاب'
                                                : 'هذا السؤال من اسئلة الاستاذ ${questions[questionIndex - 1]['writer']}',
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
                                    saveQuestion(
                                        questions[questionIndex - 1]['id']);
                                  },
                                  child: Column(
                                    children: [
                                      Icon(
                                        answers[questions[questionIndex - 1]
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
                                    Text('$questionIndex/${questions.length}',
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
                                        Text('رمز السؤال',
                                            textAlign: TextAlign.center,
                                            style: textStyle(
                                                3, width, height, kDarkBlack)),
                                        CustomContainer(
                                          onTap: () async {
                                            setState(() {
                                              copied = true;
                                            });
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: questions[
                                                            questionIndex - 1]
                                                        ['id']));
                                            Timer(Duration(seconds: 2), () {
                                              setState(() {
                                                copied = false;
                                              });
                                            });
                                          },
                                          child: Text(
                                              questions[questionIndex - 1]['id']
                                                  .substring(0, 8),
                                              style: textStyle(3, width, height,
                                                  kDarkBlack)),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: copied,
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
                                        //TODO:
                                        //   popUp(context, width / 2, 'بلاغ', [
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(8.0),
                                        //       child: Text(
                                        //         'ملاحظاتك',
                                        //         style: textStyle.copyWith(
                                        //             color: kLightPurple),
                                        //       ),
                                        //     ),
                                        //     Padding(
                                        //       padding: const EdgeInsets.symmetric(
                                        //           vertical: 8.0),
                                        //       child: CustomTextField(
                                        //         innerText: null,
                                        //         hintText: '',
                                        //         fontSize: 15,
                                        //         width: double.infinity,
                                        //         controller: TextEditingController(),
                                        //         onChanged: (text) {},
                                        //         readOnly: false,
                                        //         obscure: false,
                                        //         suffixIcon: null,
                                        //         keyboardType: null,
                                        //         color: kWhite,
                                        //         fontColor: kDarkBlack,
                                        //         border: const OutlineInputBorder(),
                                        //         focusedBorder:
                                        //             const OutlineInputBorder(),
                                        //         verticalPadding: 7.5,
                                        //         horizontalPadding: 30,
                                        //       ),
                                        //     ),
                                        //     Button(
                                        //       onTap: () {
                                        //         () {};
                                        //         Navigator.of(context).pop();
                                        //       },
                                        //       width: double.infinity,
                                        //       verticalPadding: 8,
                                        //       horizontalPadding: 0,
                                        //       borderRadius: 8,
                                        //       buttonColor: kDarkBlack,
                                        //       border: null,
                                        //       child: Center(
                                        //         child: Text(
                                        //           'تأكيد',
                                        //           style: textStyle,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       padding:
                                        //           const EdgeInsets.only(top: 16.0),
                                        //       child: Text(
                                        //         'تنويه',
                                        //         style: textStyle.copyWith(
                                        //             color: kLightPurple),
                                        //       ),
                                        //     ),
                                        //     Padding(
                                        //       padding: const EdgeInsets.all(8.0),
                                        //       child: Text(
                                        //         'يرجى كتابة كافة ملاحظاتك عن السؤال وسيقوم الفريق المختص بالتأكد من الأمر بأقرب وقت',
                                        //         style: textStyle.copyWith(
                                        //             color: kLightPurple),
                                        //       ),
                                        //     ),
                                        //   ]);
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
                                                questions[questionIndex - 1]
                                                                ['hint'] ==
                                                            '' ||
                                                        questions[questionIndex -
                                                                1]['hint'] ==
                                                            null
                                                    ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                    : questions[questionIndex -
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
                                              'هل تريد انهاء الامتحان',
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
                                                    Navigator.pop(context);
                                                  },
                                                  width: width * 0.08,
                                                  verticalPadding:
                                                      height * 0.005,
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
                                                    Navigator.pop(context);
                                                    endQuiz();
                                                  },
                                                  width: width * 0.08,
                                                  verticalPadding:
                                                      height * 0.005,
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
                                      Text('إنهاء الإمتحان',
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
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: height / 32),
                                child: SizedBox(
                                  width: width * 0.84,
                                  child: stringWithLatex(
                                      questions[questionIndex - 1]['body'],
                                      3,
                                      width,
                                      height,
                                      kWhite),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              questions[questionIndex - 1]
                                                      ['choices']
                                                  .length;
                                          i++)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: height / 64),
                                          child: CustomContainer(
                                              onTap: () {
                                                setState(() {
                                                  answers[questions[questionIndex - 1]
                                                              ['id']]!['id'] ==
                                                          questions[questionIndex - 1]
                                                                  ['choices'][i]
                                                              ['id']
                                                      ? answers[questions[questionIndex - 1]['id']]!
                                                          .remove('id')
                                                      : answers[questions[questionIndex - 1]
                                                              ['id']]!['id'] =
                                                          questions[questionIndex - 1]
                                                                  ['choices'][i]
                                                              ['id'];
                                                });
                                              },
                                              verticalPadding: width * 0.01,
                                              horizontalPadding: width * 0.02,
                                              width:
                                                  questions[questionIndex - 1]
                                                              ['image'] ==
                                                          null
                                                      ? width * 0.84
                                                      : width * 0.4,
                                              borderRadius: width * 0.005,
                                              border: null,
                                              buttonColor: answers[questions[
                                                              questionIndex - 1]
                                                          ['id']]!['id'] ==
                                                      questions[questionIndex -
                                                          1]['choices'][i]['id']
                                                  ? kLightPurple
                                                  : kDarkGray,
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: stringWithLatex(
                                                    questions[questionIndex - 1]
                                                        ['choices'][i]['body'],
                                                    3,
                                                    width,
                                                    height,
                                                    kWhite),
                                              )),
                                        ),
                                      if (questions[questionIndex - 1]
                                              ['choices']
                                          .isEmpty)
                                        CustomTextField(
                                          controller: TextEditingController(),
                                          width: questions[questionIndex - 1]
                                                      ['image'] ==
                                                  null
                                              ? width * 0.84
                                              : width * 0.4,
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
                                              answers[questions[
                                                      questionIndex - 1]['id']]!
                                                  .remove('body');
                                            } else {
                                              answers[
                                                  questions[questionIndex - 1]
                                                      ['id']]!['body'] = text;
                                            }
                                          },
                                          onSubmitted: null,
                                          backgroundColor: kDarkGray,
                                          verticalPadding: width * 0.01,
                                          horizontalPadding: width * 0.02,
                                          isDense: null,
                                          innerText: answers[
                                              questions[questionIndex - 1]
                                                  ['id']]!['body'],
                                          errorText: null,
                                          hintText: 'اكتب الجواب النهائي',
                                          hintTextColor:
                                              kWhite.withOpacity(0.5),
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          border: outlineInputBorder(
                                              width * 0.005, kTransparent),
                                          focusedBorder: outlineInputBorder(
                                              width * 0.005, kLightPurple),
                                        ),
                                    ],
                                  ),
                                  if (questions[questionIndex - 1]['image'] !=
                                      null) ...[
                                    SizedBox(width: width * 0.02),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      image: NetworkImage(
                                          questions[questionIndex - 1]
                                              ['image']),
                                      height: height * 0.3,
                                      width: width * 0.3,
                                      fit: BoxFit.contain,
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (questionIndex != 1)
                                  CustomContainer(
                                    onTap: () {
                                      setState(() {
                                        stopwatch.stop();
                                        answers[questions[questionIndex - 1]
                                                ['id']]!['duration'] +=
                                            stopwatch.elapsed.inSeconds;
                                        stopwatch.reset();
                                        questionIndex--;
                                        stopwatch.start();
                                      });
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
                                if (questionIndex != 1)
                                  SizedBox(width: width * 0.02),
                                CustomContainer(
                                  onTap: () {
                                    questionIndex != questions.length
                                        ? setState(() {
                                            stopwatch.stop();
                                            answers[questions[questionIndex - 1]
                                                    ['id']]!['duration'] +=
                                                stopwatch.elapsed.inSeconds;
                                            stopwatch.reset();
                                            questionIndex++;
                                            stopwatch.start();
                                          })
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
                                        questionIndex != questions.length
                                            ? 'التالي'
                                            : 'انهاء الإمتحان',
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
                  Visibility(
                    visible: waitResult || showResult,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: waitResult,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: kPurple, strokeWidth: width * 0.05))),
                  Visibility(
                    visible: showResult,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),
                                Text(
                                  'أحسنت ، لقد أنهيت امتحانك !',
                                  style:
                                      textStyle(2, width, height, kLightPurple),
                                ),
                                CustomContainer(
                                  onTap: () {
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
                                        'العلامة :  $quizResult',
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
                                        children: [
                                          CustomContainer(
                                            onTap: null,
                                            height: height * 0.022,
                                            width: width * 0.24,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: null,
                                            buttonColor: kLightGray,
                                            child: Row(
                                              children: [
                                                CustomContainer(
                                                    onTap: null,
                                                    height: height * 0.022,
                                                    width: width * 0.07,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kSkin,
                                                    child: const SizedBox()),
                                                SizedBox(width: width * 0.005),
                                                Text(
                                                  '25%',
                                                  style: textStyle(5, width,
                                                      height, kLightBlack),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Text(
                                            'أظهر المزيد',
                                            style: textStyle(
                                                5, width, height, kLightPurple),
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
                                                  '$quizDuration',
                                                  style: textStyle(
                                                      3, width, height, kWhite),
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
                                                    style: textStyle(3, width,
                                                        height, kLightBlack),
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
                                                  '$ideal_duration',
                                                  style: textStyle(
                                                      3, width, height, kWhite),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(),
                                      const SizedBox(),
                                      Text(
                                        'معدل التحصيل لكل مهارات الامتحان',
                                        style: textStyle(
                                            3, width, height, kLightPurple),
                                      ),
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
                                                    width: width * 0.07,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: null,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'مشتقتا الضرب والقسمة والمشتقات العليا',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                ),
                                                Text(
                                                  '20%',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                                    width: width * 0.13,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: null,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'الاشتقاق الضمني',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                ),
                                                Text(
                                                  '50%',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                                    width: width * 0.26,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: null,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'قاعدة السلسلة',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                ),
                                                Text(
                                                  '100%',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                                    width: width * 0.18,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: null,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'الاشتقاق',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                ),
                                                Text(
                                                  '65%',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
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
                                                    width: width * 0.12,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: null,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          CustomContainer(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: null,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'مراجعة الوحدة الأولى',
                                                  style: textStyle(
                                                      4, width, height, kWhite),
                                                ),
                                                Text('40%',
                                                    style: textStyle(4, width,
                                                        height, kWhite))
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
                                          Navigator.pushNamed(
                                              context, QuizResult.route);
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
                                            style: textStyle(
                                                3, width, height, kDarkBlack),
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
                                            style: textStyle(
                                                3, width, height, kDarkBlack),
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
                                            'حل امتحان شبيه',
                                            style: textStyle(
                                                3, width, height, kDarkBlack),
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
                                          child: Text('اعادة الامتحان',
                                              style: textStyle(3, width, height,
                                                  kDarkBlack)),
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
                                              MainAxisAlignment.spaceBetween,
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
                                              MainAxisAlignment.spaceBetween,
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
            backgroundColor: kLightGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
