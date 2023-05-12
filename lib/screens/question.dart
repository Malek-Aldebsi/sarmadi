import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import '../providers/question_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'dart:core';
import 'package:flutter/services.dart';

import 'dashboard.dart';

class Question extends StatefulWidget {
  static const String route = '/Question/';


  const Question({super.key});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {

  StopWatchTimer? quizTimer;
  Stopwatch stopwatch = Stopwatch();
  TextEditingController reportController= TextEditingController();

  void endTraining() async {
    quizTimer!.onStopTimer();
    stopwatch.stop();
    Provider.of<QuestionProvider>(context, listen: false).editAnswerDuration(Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
    ['id'], stopwatch.elapsed.inSeconds);
    Provider.of<WebsiteProvider>(context,
        listen: false)
        .setLoaded(false);
    Navigator.pushNamed(
        context, Dashboard.route);
  }

  void endQuestion() async {
    quizTimer!.onStopTimer();
    stopwatch.stop();
    Provider.of<QuestionProvider>(context, listen: false).editAnswerDuration(Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
    ['id'], stopwatch.elapsed.inSeconds);
    stopwatch.reset();
    print({Provider.of<QuestionProvider>(context, listen:false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex-1]['id']:
    Provider
        .of<QuestionProvider>(context, listen: false)
        .answers[Provider.of<QuestionProvider>(context, listen:false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex-1]['id']]});
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        'mark_question/',
        {
          if (key0 != null) 'email': key0,
          if (key1 != null) 'phone': key1,
          'password': value,
          'answers': {Provider.of<QuestionProvider>(context, listen:false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex-1]['id']:
          Provider
              .of<QuestionProvider>(context, listen: false)
              .answers[Provider.of<QuestionProvider>(context, listen:false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex-1]['id']]},
        }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          :
        Provider.of<QuestionProvider>(context, listen: false).setShowResult(true);

    });

  }

  void saveQuestion(questionID) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post(
        Provider.of<QuestionProvider>(context, listen: false).answers[Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']]!['saved']
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
        Provider.of<QuestionProvider>(context, listen: false).answers[Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']]!['saved'] =
        !Provider.of<QuestionProvider>(context, listen: false).answers[Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']]!['saved']
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
          'body':reportController.text,
          'question_id': questionID,
        }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
        Navigator.pop(context)
      };
    });
  }

  void getQuestions() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('similar_questions/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'questions_id': [Provider.of<QuestionProvider>(context, listen: false).questionId],
      'is_single_question':true,
      'by_headlines':true,
      'by_author':true,
      'by_level':true,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {

          quizTimer = StopWatchTimer(
            mode: StopWatchMode.countUp,
            onEnded: () {},
          ),
          quizTimer!.setPresetTime(mSec: 0),

        Provider.of<QuestionProvider>(context, listen: false).setQuestions(result),
        quizTimer!.onStartTimer(),
        stopwatch.start(),
        Provider.of<WebsiteProvider>(context, listen: false).setLoaded(true)
      };
    });
  }

  @override
  void initState() {
    getQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return

        Provider.of<WebsiteProvider>(context, listen: true).loaded
        ? Provider.of<QuestionProvider>(context, listen: true).questions.isEmpty?Scaffold(
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
        ):Scaffold(
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
                                          Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                          ['writer'] ==
                                              'نمط اسئلة الكتاب'
                                              ? 'هذا السؤال على نمط اسئلة الكتاب'
                                              : 'هذا السؤال من اسئلة الاستاذ ${Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['writer']}',
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
                                      Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Provider.of<QuestionProvider>(context, listen: true).answers[Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
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
                                      .of<QuestionProvider>(
                                      context, listen: true)
                                      .questionIndex}/${Provider.of<QuestionProvider>(context, listen: true).questions.length}',
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
                                          Provider.of<QuestionProvider>(context, listen: false).setCopied(true);
                                          await Clipboard.setData(
                                              ClipboardData(
                                                  text: Provider.of<QuestionProvider>(context, listen: false).questions[
                                                  Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                                  ['id']));
                                          Timer(Duration(seconds: 2), () {
                                            Provider.of<QuestionProvider>(context, listen: false).setCopied(false);
                                          });
                                        },
                                        child: Text(
                                            Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']
                                                .substring(0, 8),
                                            style: textStyle(3, width, height,
                                                kDarkBlack)),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: Provider.of<QuestionProvider>(context, listen: true).copied,
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
                                                      Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']);
                                                },
                                                backgroundColor: kDarkBlack,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: width * 0.02,
                                                isDense: null,
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
                                                      Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']);
                                                },
                                                width: width * 0.38,
                                                verticalPadding:
                                                height * 0.02,
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
                                              Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                              ['hint'] ==
                                                  '' ||
                                                  Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex -
                                                      1]['hint'] ==
                                                      null
                                                  ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                  : Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex -
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
                                                  endTraining();
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height / 32),
                              child: SizedBox(
                                width: width * 0.84,
                                child: stringWithLatex(
                                    Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['body'],
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0;
                                    i <
                                        Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                        ['choices']
                                            .length;
                                    i++)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: height / 64),
                                        child: CustomContainer(
                                            onTap: Provider.of<QuestionProvider>(context, listen: true).showResult?null:() {
                                              Provider.of<QuestionProvider>(context, listen: false).answers[Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                              ['id']]!['answer'] ==
                                                  Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                                  ['choices'][i]
                                                  ['id']
                                                  ? Provider.of<QuestionProvider>(context, listen: false).removeQuestionAnswer(Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id'])
                                                  : {
                                                Provider.of<QuestionProvider>(
                                                    context, listen: false)
                                                    .editQuestionAnswer(Provider
                                                    .of<QuestionProvider>(
                                                    context, listen: false)
                                                    .questions[Provider
                                                    .of<QuestionProvider>(
                                                    context, listen: false)
                                                    .questionIndex - 1]['id'],
                                                    Provider
                                                        .of<QuestionProvider>(
                                                        context, listen: false)
                                                        .questions[Provider
                                                        .of<QuestionProvider>(
                                                        context, listen: false)
                                                        .questionIndex -
                                                        1]['choices'][i]['id']),
                                                print(1)
                                              };

                                            },
                                            verticalPadding: height * 0.02,
                                            horizontalPadding: width * 0.02,
                                            width:
                                            Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                            ['image'] ==
                                                null
                                                ? width * 0.84
                                                : width * 0.4,
                                            borderRadius: width * 0.005,
                                            border: Provider.of<QuestionProvider>(context, listen: true).showResult?fullBorder(Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: true).questionIndex-1]['choices'][i]['id'] ==
                                                                                                                                Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: true).questionIndex-1]['correct_answer']['id']
                                                ? kGreen
                                                :                                                                              Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: true).questionIndex-1]['choices'][i]['id'] ==
                                                                                                                               Provider.of<QuestionProvider>(context, listen: true).answers[Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']]!['answer']
                                                ? kRed
                                                : kTransparent):null,
                                            buttonColor: Provider.of<QuestionProvider>(context, listen: true).answers[Provider.of<QuestionProvider>(context, listen: false).questions[
                                            Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                            ['id']]!['answer'] ==
                                                Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex -
                                                    1]['choices'][i]['id']
                                                ? kLightPurple
                                                : kDarkGray,
                                            child: Align(
                                              alignment:
                                              Alignment.centerRight,
                                              child: stringWithLatex(
                                                  Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                                  ['choices'][i]['body'],
                                                  3,
                                                  width,
                                                  height,
                                                  kWhite),
                                            )),
                                      ),
                                    if (Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                    ['choices']
                                        .isEmpty)
                                      Provider.of<QuestionProvider>(context, listen: true).showResult?CustomContainer(
                                          onTap: null,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          width:
                                          Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                          ['image'] ==
                                              null
                                              ? width * 0.84
                                              : width * 0.4,
                                          borderRadius: width * 0.005,
                                          border: Provider.of<QuestionProvider>(context, listen: true).showResult?fullBorder(Provider.of<QuestionProvider>(context, listen: true).answers[Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']]!['answer'] ==
                                              Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: true).questionIndex-1]['correct_answer']['body']
                                              ? kGreen
                                              : kRed
                                              ):null,
                                          buttonColor: kDarkGray,
                                          child: Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: Text(
                                                Provider.of<QuestionProvider>(context, listen: true).answers[
                                                Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                                ['id']]!['answer'], style: textStyle(3,
                                                width,
                                                height,
                                                kWhite),
                                                ),
                                          )):CustomTextField(
                                        controller: TextEditingController(text: Provider.of<QuestionProvider>(context, listen: true).answers[
                                        Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                        ['id']]!['answer']),
                                        width: Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
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
                                            Provider.of<QuestionProvider>(context, listen: false).removeQuestionAnswer(Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['id']);
                                          } else {
                                            Provider.of<QuestionProvider>(context, listen: false).editQuestionAnswer(Provider.of<QuestionProvider>(context, listen: false).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
                                            ['id'], text);
                                          }
                                        },
                                        onSubmitted: null,
                                        backgroundColor: kDarkGray,
                                        verticalPadding: width * 0.01,
                                        horizontalPadding: width * 0.02,
                                        isDense: null,
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
                                if (Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]['image'] !=
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
                                        Provider.of<QuestionProvider>(context, listen: true).questions[Provider.of<QuestionProvider>(context, listen: false).questionIndex - 1]
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
                              CustomContainer(
                                onTap: () {
                                  Provider.of<QuestionProvider>(context, listen: false).showResult?
                                  Provider.of<QuestionProvider>(context, listen: false).questionIndex == Provider.of<QuestionProvider>(context, listen: false).questions.length?endTraining():{
                                    Provider.of<QuestionProvider>(context, listen: false).setShowResult(false),
                                    Provider.of<QuestionProvider>(context, listen: false).setQuestionIndex(Provider.of<QuestionProvider>(context, listen: false).questionIndex+1),
                                    quizTimer!.onResetTimer(),
                                        quizTimer!.onStartTimer(),
                                    stopwatch.start(),
                                }:endQuestion();
                                },
                                width: width * 0.19,
                                verticalPadding: width * 0.005,
                                horizontalPadding: 0,
                                borderRadius: 8,
                                border: null,
                                buttonColor: kLightPurple,
                                child: Center(
                                  child: Text(Provider.of<QuestionProvider>(context, listen: false).showResult?
                                  Provider.of<QuestionProvider>(context, listen: true).questionIndex == Provider.of<QuestionProvider>(context, listen: false).questions.length?'انهاء التدرييب':'السؤال التالي': 'تأكيد الجواب',
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
