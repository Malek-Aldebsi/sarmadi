import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sarmadi/screens/welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import '../const.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'advance_quiz_setting.dart';
import 'dart:core';

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

    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
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
              waitResult = false;
              showResult = true;
            });
    });
  }

  StopWatchTimer? quizTimer;

  @override
  void initState() {
    quizTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: endQuiz,
    );
    Future.delayed(Duration.zero, () {
      try {
        dynamic arguments = ModalRoute.of(context)?.settings.arguments;
        setState(() {
          quizTimer!.setPresetTime(mSec: arguments['duration'] * 1000);
          questions = arguments['questions'];
          _subjectID = arguments['subjectID'];
          for (Map question in questions) {
            print(answers);
            answers[question['id']] = {'duration': 0};
          }
          loaded = true;
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
                      Container(
                          height: double.infinity,
                          width: width * 0.1,
                          color: kPurple,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  popUp(
                                      context, width / 4, 'معلومات عن السؤال', [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'هذا السؤال على نمط اسئلة ${questions[questionIndex - 1]['writer']}',
                                        style: textStyle.copyWith(
                                            color: kOffPurple),
                                      ),
                                    ),
                                  ]);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline_rounded,
                                      size: width / 50,
                                      color: kBlack,
                                    ),
                                    Text(
                                      'معلومات السؤال',
                                      style: textStyle.copyWith(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width / 100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.bookmark_add_outlined,
                                      size: width / 50,
                                      color: kBlack,
                                    ),
                                    Text(
                                      'حفظ السؤال',
                                      style: textStyle.copyWith(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width / 100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                                color: kBlack,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'السؤال',
                                    style: textStyle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width / 100,
                                    ),
                                  ),
                                  Text(
                                    '$questionIndex/${questions.length}',
                                    style: textStyle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w900,
                                      fontSize: width / 80,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'الوقت',
                                    style: textStyle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width / 100,
                                    ),
                                  ),
                                  StreamBuilder<int>(
                                    stream: quizTimer!.rawTime,
                                    initialData: quizTimer!.rawTime.value,
                                    builder: (context, snap) {
                                      final displayTime =
                                          StopWatchTimer.getDisplayTime(
                                              snap.data!,
                                              milliSecond: false);
                                      return Text(
                                        displayTime,
                                        style: textStyle.copyWith(
                                          color: kBlack,
                                          fontWeight: FontWeight.w900,
                                          fontSize: width / 80,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'رمز السؤال',
                                    style: textStyle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width / 100,
                                    ),
                                  ),
                                  Text(
                                    questions[questionIndex - 1]['id']
                                        .substring(0, 8),
                                    style: textStyle.copyWith(
                                      color: kBlack,
                                      fontWeight: FontWeight.w900,
                                      fontSize: width / 80,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.5,
                                indent: 10,
                                endIndent: 10,
                                color: kBlack,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      popUp(context, width / 2, 'بلاغ', [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'ملاحظاتك',
                                            style: textStyle.copyWith(
                                                color: kOffPurple),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: CustomTextField(
                                            innerText: null,
                                            hintText: '',
                                            fontSize: 15,
                                            width: double.infinity,
                                            controller: TextEditingController(),
                                            onChanged: (text) {},
                                            readOnly: false,
                                            obscure: false,
                                            suffixIcon: null,
                                            keyboardType: null,
                                            color: kWhite,
                                            fontColor: kBlack,
                                            border: const OutlineInputBorder(),
                                            focusedBorder:
                                                const OutlineInputBorder(),
                                            verticalPadding: 7.5,
                                            horizontalPadding: 30,
                                          ),
                                        ),
                                        Button(
                                          onTap: () {
                                            () {};
                                            Navigator.of(context).pop();
                                          },
                                          width: double.infinity,
                                          verticalPadding: 8,
                                          horizontalPadding: 0,
                                          borderRadius: 8,
                                          buttonColor: kBlack,
                                          border: 0,
                                          child: Center(
                                            child: Text(
                                              'تأكيد',
                                              style: textStyle,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            'تنويه',
                                            style: textStyle.copyWith(
                                                color: kOffPurple),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'يرجى كتابة كافة ملاحظاتك عن السؤال وسيقوم الفريق المختص بالتأكد من الأمر بأقرب وقت',
                                            style: textStyle.copyWith(
                                                color: kOffPurple),
                                          ),
                                        ),
                                      ]);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          size: width / 50,
                                          color: kBlack,
                                        ),
                                        Text(
                                          'بلاغ',
                                          style: textStyle.copyWith(
                                            color: kBlack,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width / 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      popUp(context, width / 4, 'مساعدة', [
                                        Text(
                                          questions[questionIndex - 1]
                                                  ['hint'] ??
                                              'لا توجد اي معلومة اضافية لهذا السؤال',
                                          style: textStyle.copyWith(
                                              color: kOffPurple),
                                        ),
                                      ]);
                                    },
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.help_outline_rounded,
                                          size: width / 50,
                                          color: kBlack,
                                        ),
                                        Text(
                                          'مساعدة',
                                          style: textStyle.copyWith(
                                            color: kBlack,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width / 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.exit_to_app_outlined,
                                      size: width / 50,
                                      color: kBlack,
                                    ),
                                    Text(
                                      'إنهاء الإمتحان',
                                      style: textStyle.copyWith(
                                        color: kBlack,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width / 100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
                                      width * 0.016,
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
                                          child: Button(
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
                                              borderRadius: 8,
                                              border: 0,
                                              buttonColor: answers[questions[
                                                              questionIndex - 1]
                                                          ['id']]!['id'] ==
                                                      questions[questionIndex -
                                                          1]['choices'][i]['id']
                                                  ? kPurple
                                                  : kLightGray,
                                              child: SizedBox(
                                                width: width * 0.3,
                                                child: stringWithLatex(
                                                    questions[questionIndex - 1]
                                                        ['choices'][i]['body'],
                                                    width * 0.016,
                                                    kWhite),
                                              )),
                                        ),
                                      if (questions[questionIndex - 1]
                                              ['choices']
                                          .isEmpty)
                                        CustomTextField(
                                          innerText: answers[
                                              questions[questionIndex - 1]
                                                  ['id']]!['body'],
                                          hintText: 'اكتب الجواب النهائي',
                                          fontSize: width * 0.016,
                                          width: questions[questionIndex - 1]
                                                      ['image'] ==
                                                  null
                                              ? width * 0.84
                                              : width * 0.4,
                                          controller: TextEditingController(),
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
                                          readOnly: false,
                                          obscure: false,
                                          suffixIcon: null,
                                          keyboardType: null,
                                          color: kLightGray,
                                          verticalPadding: width * 0.01,
                                          horizontalPadding: width * 0.02,
                                          border: inputBorder(),
                                          focusedBorder: focusedBorder(),
                                        )
                                    ],
                                  ),
                                  if (questions[questionIndex - 1]['image'] !=
                                      null) ...[
                                    SizedBox(width: width * 0.02),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Dash(
                                            direction: Axis.vertical,
                                            dashThickness: 0.2,
                                            length: height / 2,
                                            dashLength: height * 0.01,
                                            dashColor:
                                                kPurple.withOpacity(0.2)),
                                      ],
                                    ),
                                    SizedBox(width: width * 0.02),
                                    Image(
                                      image: NetworkImage(
                                          questions[questionIndex - 1]
                                              ['image']),
                                      height: height * 0.5,
                                      width: width * 0.4,
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
                                  Button(
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
                                    border: 4,
                                    borderColor: kPurple,
                                    buttonColor: kBlack,
                                    child: Center(
                                      child: Text(
                                        'السابق',
                                        style: textStyle.copyWith(
                                          color: kPurple,
                                          fontWeight: FontWeight.w400,
                                          fontSize: width * 0.016,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (questionIndex != 1)
                                  SizedBox(width: width * 0.02),
                                Button(
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
                                  border: 0,
                                  buttonColor: kPurple,
                                  child: Center(
                                    child: Text(
                                      questionIndex != questions.length
                                          ? 'التالي'
                                          : 'انهاء الإمتحان',
                                      style: textStyle.copyWith(
                                        color: kBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.016,
                                      ),
                                    ),
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
                      child: Button(
                        onTap: null,
                        width: width * 0.5,
                        height: height * 0.77,
                        verticalPadding: height * 0.02,
                        horizontalPadding: width * 0.02,
                        borderRadius: width * 0.01,
                        border: 4,
                        borderColor: kBlack,
                        buttonColor: kLightBlack,
                        child: Column(
                          children: [
                            Text(
                              'أحسنت ، لقد أنهيت امتحانك !',
                              style: textStyle.copyWith(
                                  fontSize: width * 0.017,
                                  fontWeight: FontWeight.w600,
                                  color: kOffPurple),
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
                                        'العلامة : $quizResult',
                                        style: textStyle.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.012,
                                            color: kOffPurple),
                                      ),
                                      SizedBox(
                                        width: width * 0.28,
                                        child: CustomDivider(
                                          dashHeight: 1,
                                          dashWith: width * 0.005,
                                          dashColor: kGray,
                                          direction: Axis.horizontal,
                                          fillRate: 0.6,
                                        ),
                                      ),
                                      Text(
                                        'مهامك اكتملت بنسبة :',
                                        style: textStyle.copyWith(
                                            fontSize: width * 0.01,
                                            color: kOffPurple),
                                      ),
                                      Row(
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.022,
                                            width: width * 0.24,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kOffBlack,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.022,
                                                    width: width * 0.07,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kSkin,
                                                    child: const SizedBox()),
                                                SizedBox(width: width * 0.005),
                                                Text(
                                                  '25%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.007,
                                                      color: kBlack),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Text(
                                            'أظهر المزيد',
                                            style: textStyle.copyWith(
                                                fontSize: width * 0.007,
                                                color: kOffPurple),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(),
                                      const SizedBox(),
                                      Button(
                                        onTap: null,
                                        width: width * 0.31,
                                        height: height * 0.1,
                                        verticalPadding: height * 0.01,
                                        horizontalPadding: width * 0.01,
                                        borderRadius: width * 0.008,
                                        border: 0,
                                        buttonColor: kGray,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'الوقت المستهلك للحل :',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kOffPurple),
                                                ),
                                                Text(
                                                  '$quizDuration',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kWhite),
                                                )
                                              ],
                                            ),
                                            const SizedBox(),
                                            Button(
                                                onTap: null,
                                                width: width * 0.05,
                                                height: height * 0.06,
                                                verticalPadding: 0,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.008,
                                                border: 0,
                                                buttonColor: kOffPurple,
                                                child: Center(
                                                  child: Text(
                                                    'الوقت',
                                                    style: textStyle.copyWith(
                                                        fontSize: width * 0.01,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kLightBlack),
                                                  ),
                                                )),
                                            const SizedBox(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'الوقت المثالي للحل :',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kOffPurple),
                                                ),
                                                Text(
                                                  '$ideal_duration',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kWhite),
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
                                        style: textStyle.copyWith(
                                            fontSize: width * 0.01,
                                            color: kOffPurple),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.05,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.05,
                                                    width: width * 0.07,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          Button(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: 0,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'مشتقتا الضرب والقسمة والمشتقات العليا',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                ),
                                                Text(
                                                  '20%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.05,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.05,
                                                    width: width * 0.13,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          Button(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: 0,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'الاشتقاق الضمني',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                ),
                                                Text(
                                                  '50%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.05,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.05,
                                                    width: width * 0.26,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          Button(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: 0,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'قاعدة السلسلة',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                ),
                                                Text(
                                                  '100%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.05,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.05,
                                                    width: width * 0.18,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          Button(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: 0,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'الاشتقاق',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                ),
                                                Text(
                                                  '65%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Button(
                                            onTap: null,
                                            height: height * 0.05,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Row(
                                              children: [
                                                Button(
                                                    onTap: null,
                                                    height: height * 0.05,
                                                    width: width * 0.12,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kPurple,
                                                    child: const SizedBox()),
                                              ],
                                            ),
                                          ),
                                          Button(
                                            onTap: null,
                                            width: width * 0.26,
                                            verticalPadding: 0,
                                            horizontalPadding: width * 0.01,
                                            borderRadius: 0,
                                            border: 0,
                                            buttonColor: Colors.transparent,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'مراجعة الوحدة الأولى',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
                                                ),
                                                Text(
                                                  '40%',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.008,
                                                      color: kWhite),
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
                                    dashWith: width * 0.005,
                                    dashColor: kGray,
                                    direction: Axis.vertical,
                                    fillRate: 0.6,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: width * 0.005,
                                        border: 0,
                                        buttonColor: kOffPurple,
                                        child: Center(
                                          child: Text(
                                            'ملخص وتحليل الامتحان',
                                            style: textStyle.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: width * 0.01,
                                                color: kLightBlack),
                                          ),
                                        ),
                                      ),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: width * 0.005,
                                        border: 0,
                                        buttonColor: kOffPurple,
                                        child: Center(
                                          child: Text(
                                            'تقرير تقدم المادة',
                                            style: textStyle.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: width * 0.01,
                                                color: kLightBlack),
                                          ),
                                        ),
                                      ),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: width * 0.005,
                                        border: 0,
                                        buttonColor: kOffPurple,
                                        child: Center(
                                          child: Text(
                                            'ملخص وتحليل الامتحان',
                                            style: textStyle.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: width * 0.01,
                                                color: kLightBlack),
                                          ),
                                        ),
                                      ),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: width * 0.005,
                                        border: 0,
                                        buttonColor: kOffPurple,
                                        child: Center(
                                          child: Text(
                                            'اعادة الامتحان',
                                            style: textStyle.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: width * 0.01,
                                                color: kLightBlack),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: width * 0.015,
                                        borderRadius: width * 0.005,
                                        border: 4,
                                        borderColor: kOffPurple,
                                        buttonColor: kLightBlack,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'قائمة المتصدرين',
                                              style: textStyle.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width * 0.01,
                                                  color: kOffPurple),
                                            ),
                                            Icon(
                                              Icons.emoji_events_outlined,
                                              size: width * 0.02,
                                              color: kWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Button(
                                        onTap: null,
                                        width: width * 0.13,
                                        height: height * 0.06,
                                        verticalPadding: 0,
                                        horizontalPadding: width * 0.015,
                                        borderRadius: width * 0.005,
                                        border: 4,
                                        borderColor: kOffPurple,
                                        buttonColor: kLightBlack,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'مجتمع مدارس',
                                              style: textStyle.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width * 0.01,
                                                  color: kOffPurple),
                                            ),
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
