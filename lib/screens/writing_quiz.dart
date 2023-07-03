import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../components/custom_container.dart';
import '../components/custom_divider.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/quiz_provider.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class WritingQuiz extends StatefulWidget {
  const WritingQuiz({Key? key}) : super(key: key);

  @override
  State<WritingQuiz> createState() => _WritingQuizState();
}

class _WritingQuizState extends State<WritingQuiz> {
  StopWatchTimer? quizTimer;
  Stopwatch stopwatch = Stopwatch();

  bool contactMethod = true; // false email true whatsapp
  TextEditingController contactController = TextEditingController();

  TextEditingController reportController = TextEditingController();

  String? image;
  Uint8List? fromPicker;

  bool contactEmpty = false;
  bool imageEmpty = false;

  void startQuiz(
      QuizProvider quizProvider, WebsiteProvider websiteProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    post('get_writing_question/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'tag': quizProvider.subjectID == '7376be1e-e252-4d22-874b-9ec129326807'
          ? 'مهارة الكتابة للغة الإنجليزية'
          : 'مهارة الكتابة للغة العربية',
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
              quizProvider.setQuestions([result]),
              quizProvider.setWithTime(false),
              quizTimer = StopWatchTimer(
                mode: StopWatchMode.countUp,
                onEnded: () {},
              ),
              quizTimer!.setPresetTime(mSec: 0),
              quizTimer!.onStartTimer(),
              stopwatch.start(),
              websiteProvider.setLoaded(true),
            };
    });
  }

  void saveQuestion(
      QuizProvider quizProvider, WebsiteProvider websiteProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    if (key0 == null && key1 == null) {
    } else {
      post(
          quizProvider.answers[quizProvider
                  .questions[quizProvider.questionIndex - 1]['id']]!['saved']
              ? 'unsave_question/'
              : 'save_question/',
          {
            if (key0 != null) 'email': key0,
            if (key1 != null) 'phone': key1,
            'password': value,
            'question_id':
                quizProvider.questions[quizProvider.questionIndex - 1]['id'],
          }).then((value) {
        dynamic result = decode(value);
        result == 0
            ? context.pushReplacement('/Welcome')
            : {
                quizProvider.setSaveQuestion(quizProvider
                    .questions[quizProvider.questionIndex - 1]['id'])
              };
      });
    }
  }

  void report(
      QuizProvider quizProvider, WebsiteProvider websiteProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    if (key0 == null && key1 == null) {
      key0 = 'meebe@gmail.com';
      value = 'help';
    }

    post('report/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'body': reportController.text,
      'question_id': quizProvider.questions[quizProvider.questionIndex - 1]
          ['id'],
    }).then((value) {
      dynamic result = decode(value);
      result == 0 ? context.pushReplacement('/Welcome') : context.pop();
    });
  }

  void endQuiz(
      QuizProvider quizProvider, WebsiteProvider websiteProvider) async {
    stopwatch.stop();
    quizTimer?.onStopTimer();

    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    quizProvider.setWait(true);

    post('submit_writing_question/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'question': quizProvider.questions[quizProvider.questionIndex - 1]['id'],
      'image': image,
      'attemptDuration': stopwatch.elapsed.inSeconds,
      'contactMethod': contactController.text
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? context.pushReplacement('/Welcome')
          : {
              if (result == 1)
                {
                  Provider.of<QuizProvider>(context, listen: false)
                      .setWait(false),
                  Provider.of<QuizProvider>(context, listen: false)
                      .setShowResult(true),
                }
            };
    });
  }

  @override
  void initState() {
    super.initState();
    startQuiz(Provider.of<QuizProvider>(context, listen: false),
        Provider.of<WebsiteProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    QuizProvider quizProvider = Provider.of<QuizProvider>(context);
    WebsiteProvider websiteProvider =
        Provider.of<WebsiteProvider>(context, listen: false);

    return width < height
        ? const RotateYourPhone()
        : Provider.of<WebsiteProvider>(context, listen: true).loaded
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
                                    InkWell(
                                      onTap: () {
                                        popUp(
                                            context,
                                            width * 0.2,
                                            height * 0.25,
                                            Center(
                                              child: Text(
                                                'هذا السؤال من اسئلة ${quizProvider.questions[quizProvider.questionIndex - 1]['writer']}',
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
                                    InkWell(
                                      onTap: () {
                                        saveQuestion(
                                            quizProvider, websiteProvider);
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            quizProvider.answers[quizProvider
                                                        .questions[
                                                    quizProvider.questionIndex -
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
                                            '${quizProvider.questionIndex}/${quizProvider.questions.length}',
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
                                    Column(
                                      children: [
                                        Text('رمز السؤال',
                                            textAlign: TextAlign.center,
                                            style: textStyle(
                                                3, width, height, kDarkBlack)),
                                        InkWell(
                                          onTap: () async {
                                            quizProvider.setCopied(true);
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: quizProvider
                                                        .questions[quizProvider
                                                            .questionIndex -
                                                        1]['id']));
                                            Timer(const Duration(seconds: 2),
                                                () {
                                              quizProvider.setCopied(false);
                                            });
                                          },
                                          child: Text(
                                              quizProvider.copied &&
                                                      !quizProvider.showResult
                                                  ? 'تم النسخ'
                                                  : quizProvider
                                                      .questions[quizProvider
                                                              .questionIndex -
                                                          1]['id']
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
                                                        report(quizProvider,
                                                            websiteProvider);
                                                      },
                                                      backgroundColor:
                                                          kDarkBlack,
                                                      verticalPadding:
                                                          height * 0.02,
                                                      horizontalPadding:
                                                          width * 0.02,
                                                      isDense: true,
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
                                                        report(quizProvider,
                                                            websiteProvider);
                                                      },
                                                      width: width * 0.38,
                                                      height: height * 0.06,
                                                      verticalPadding: 0,
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
                                        InkWell(
                                          onTap: () {
                                            popUp(
                                                context,
                                                width * 0.2,
                                                height * 0.25,
                                                Center(
                                                  child: Text(
                                                    quizProvider.questions[quizProvider
                                                                            .questionIndex -
                                                                        1]
                                                                    ['hint'] ==
                                                                '' ||
                                                            quizProvider.questions[
                                                                        quizProvider
                                                                                .questionIndex -
                                                                            1]
                                                                    ['hint'] ==
                                                                null
                                                        ? 'لا توجد اي معلومة اضافية لهذا السؤال'
                                                        : quizProvider
                                                            .questions[quizProvider
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
                                    InkWell(
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
                                                        context.pop();
                                                      },
                                                      width: width * 0.08,
                                                      height: height * 0.06,
                                                      verticalPadding: 0,
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
                                                        context.pop();
                                                        context.pushReplacement(
                                                            '/QuizSetting');
                                                      },
                                                      width: width * 0.08,
                                                      height: height * 0.06,
                                                      verticalPadding: 0,
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(),
                              Column(
                                  crossAxisAlignment: quizProvider.subjectID ==
                                          '7376be1e-e252-4d22-874b-9ec129326807'
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: height / 32),
                                      child: Directionality(
                                        textDirection: quizProvider.subjectID ==
                                                '7376be1e-e252-4d22-874b-9ec129326807'
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        child: SizedBox(
                                          width: width * 0.84,
                                          child: stringWithLatex(
                                              quizProvider.questions[
                                                  quizProvider.questionIndex -
                                                      1]['body'],
                                              3,
                                              width,
                                              height,
                                              kWhite),
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                        onTap: () async {
                                          fromPicker = await ImagePickerWeb
                                              .getImageAsBytes();
                                          image = base64.encode(fromPicker!);
                                          setState(() {
                                            imageEmpty = false;
                                            fromPicker;
                                            image;
                                          });
                                        },
                                        width: width * 0.8,
                                        height: height * 0.3,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        buttonColor: kLightPurple,
                                        border: imageEmpty
                                            ? fullBorder(kRed)
                                            : null,
                                        borderRadius: width * 0.005,
                                        child: Center(
                                          child: fromPicker != null
                                              ? Image.memory(
                                                  fromPicker!,
                                                  width: width * 0.3,
                                                  height: height * 0.3,
                                                  fit: BoxFit.contain,
                                                )
                                              : Text(
                                                  'قم بتصوير الحل\nثم ارفقه هنا',
                                                  style: textStyle(2, width,
                                                      height, kDarkGray),
                                                  textAlign: TextAlign.center,
                                                ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height * 0.05),
                                        Text(
                                          'كيف تفضل ان نتواصل معك عند خروج النتيجة',
                                          textAlign: TextAlign.center,
                                          style: textStyle(
                                              3, width, height, kLightPurple),
                                        ),
                                        SizedBox(height: height * 0.02),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomContainer(
                                              onTap: () {
                                                setState(() {
                                                  contactMethod = true;
                                                });
                                              },
                                              width: width * 0.12,
                                              height: height * 0.061,
                                              verticalPadding: 0,
                                              horizontalPadding: 0,
                                              borderRadius: null,
                                              border: fullBorder(kLightPurple),
                                              buttonColor: contactMethod
                                                  ? kLightPurple
                                                  : kDarkBlack,
                                              child: Center(
                                                child: Text('على الواتس اب',
                                                    style: textStyle(
                                                        3,
                                                        width,
                                                        height,
                                                        contactMethod
                                                            ? kDarkGray
                                                            : kLightPurple)),
                                              ),
                                            ),
                                            CustomContainer(
                                              onTap: () {
                                                setState(() {
                                                  contactMethod = false;
                                                });
                                              },
                                              width: width * 0.12,
                                              height: height * 0.061,
                                              verticalPadding: 0,
                                              horizontalPadding: 0,
                                              borderRadius: null,
                                              border: fullBorder(kLightPurple),
                                              buttonColor: !contactMethod
                                                  ? kLightPurple
                                                  : kDarkBlack,
                                              child: Center(
                                                child: Text('على الايميل',
                                                    style: textStyle(
                                                        3,
                                                        width,
                                                        height,
                                                        !contactMethod
                                                            ? kDarkGray
                                                            : kLightPurple)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.061,
                                              child: CustomTextField(
                                                controller: contactController,
                                                width: width * 0.56,
                                                fontOption: 3,
                                                fontColor: kWhite,
                                                textAlign: null,
                                                obscure: false,
                                                readOnly: false,
                                                focusNode: null,
                                                maxLines: 1,
                                                maxLength: null,
                                                keyboardType: null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    contactEmpty = false;
                                                  });
                                                },
                                                onSubmitted: null,
                                                backgroundColor: kDarkGray,
                                                verticalPadding: 0,
                                                horizontalPadding: width * 0.02,
                                                isDense: false,
                                                errorText: null,
                                                hintText: contactMethod
                                                    ? 'رقم الهاتف'
                                                    : 'البريد الإلكتروني',
                                                hintTextColor:
                                                    kWhite.withOpacity(0.5),
                                                suffixIcon: null,
                                                prefixIcon: null,
                                                border: outlineInputBorder(
                                                    0,
                                                    contactEmpty
                                                        ? kRed
                                                        : kTransparent),
                                                focusedBorder:
                                                    outlineInputBorder(
                                                        0,
                                                        contactEmpty
                                                            ? kRed
                                                            : kLightPurple),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ]),
                              Padding(
                                padding: EdgeInsets.only(bottom: height * 0.1),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.12,
                                      height: height * 0.07,
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
                                        if (image == null) {
                                          setState(() {
                                            imageEmpty = true;
                                          });
                                        } else if (contactController.text ==
                                            '') {
                                          setState(() {
                                            contactEmpty = true;
                                          });
                                        } else if (!RegExp(
                                                    r'^([+]962|0|962)7(7|8|9)[0-9]{7,}')
                                                .hasMatch(
                                                    contactController.text) &&
                                            contactMethod) {
                                          setState(() {
                                            contactEmpty = true;
                                          });
                                        } else if (!RegExp(
                                                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                                .hasMatch(
                                                    contactController.text) &&
                                            !contactMethod) {
                                          setState(() {
                                            contactEmpty = true;
                                          });
                                        } else if (image != null &&
                                            contactController.text != '') {
                                          setState(() {
                                            contactEmpty = false;
                                          });
                                          endQuiz(
                                              quizProvider, websiteProvider);
                                        }
                                      },
                                      width: width * 0.12,
                                      height: height * 0.07,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      border: null,
                                      buttonColor: kLightPurple,
                                      child: Center(
                                        child: Text('انهاء الإمتحان',
                                            style: textStyle(
                                                3, width, height, kDarkBlack)),
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
                        visible: quizProvider.wait || quizProvider.showResult,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: quizProvider.wait,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: kPurple, strokeWidth: width * 0.05))),
                      Visibility(
                        visible: quizProvider.showResult,
                        child: Center(
                          child: CustomContainer(
                            onTap: null,
                            width: width * 0.3,
                            height: height * 0.3,
                            verticalPadding: height * 0.03,
                            horizontalPadding: width * 0.02,
                            borderRadius: width * 0.01,
                            border: fullBorder(kDarkBlack),
                            buttonColor: kLightBlack,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'سنتواصل معك فور خروج النتيجة ابقى بالقرب',
                                      style: textStyle(
                                          3, width, height, kLightPurple),
                                    ),
                                    Text(
                                      '** الزمن التقديري 1-2 يوم',
                                      style: textStyle(
                                          3, width, height, kLightPurple),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.05),
                                CustomContainer(
                                  onTap: () {
                                    context.pushReplacement('/QuizSetting');
                                  },
                                  width: width * 0.13,
                                  height: height * 0.06,
                                  verticalPadding: 0,
                                  horizontalPadding: 0,
                                  borderRadius: 8,
                                  border: null,
                                  buttonColor: kLightPurple,
                                  child: Center(
                                    child: Text('العودة للصفحة الرئيسية',
                                        style: textStyle(
                                            3, width, height, kDarkBlack)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ///////
                      Visibility(
                        visible: quizProvider.notification,
                        child: InkWell(
                          onTap: () {
                            quizProvider.setNotification(false);
                          },
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: quizProvider.notification,
                        child: Center(
                          child: CustomContainer(
                            onTap: null,
                            width: width * 0.3,
                            height: height * 0.25,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            borderRadius: width * 0.01,
                            border: fullBorder(kDarkBlack),
                            buttonColor: kLightBlack,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'يرجى عدم مغادرة الصفحة اثناء كتابة التعبير\nلحساب وقت الكتابة وعدم تغير الموضوع',
                                  style:
                                      textStyle(3, width, height, kLightPurple),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: height * 0.03),
                                CustomContainer(
                                  onTap: () {
                                    quizProvider.setNotification(false);
                                  },
                                  width: width * 0.13,
                                  height: height * 0.06,
                                  verticalPadding: 0,
                                  horizontalPadding: 0,
                                  borderRadius: 8,
                                  border: null,
                                  buttonColor: kLightPurple,
                                  child: Center(
                                    child: Text('المتابعة',
                                        style: textStyle(
                                            3, width, height, kDarkBlack)),
                                  ),
                                ),
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
