import 'package:flutter/material.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_text_field.dart';
import '../const.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Question extends StatefulWidget {
  static const String route = '/Question/';

  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int questionIndex = 1;
  int questionNum = 40;

  String questionID = '#12632';
  AssetImage questionImage = const AssetImage('images/question_example.png');
  String questionBody = 'ما مشتقة f(x) = x^2 ؟';
  List questionChoices = ['2x', 'x', 'x^2', '2'];
  int? selectedChoices;
  String questionHint =
      'خطوات اشتقاق الإقتران:\n  1. اضرب الإقتران بقيمة الأسس\n  2.اطرح 1 من الاسس ';
  String questionWriter = 'بسام أبو مقدم';
  final StopWatchTimer singleQuestionTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  // final StopWatchTimer quizTimer = StopWatchTimer(
  //   mode: StopWatchMode.countDown,
  //   presetMillisecond: StopWatchTimer.getMilliSecFromSecond(15),
  // );

  @override
  void initState() {
    singleQuestionTimer.onStartTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/single_question_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Image(
            image: questionImage,
            width: width * 0.4,
            height: height * 0.5,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dash(
                  direction: Axis.vertical,
                  dashThickness: 0.5,
                  length: height / 2,
                  dashLength: height * 0.01,
                  dashColor: kPurple),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionBody,
                  style: textStyle.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: width / 40,
                  ),
                ),
                for (int i = 0; i < 4; i++)
                  Padding(
                    padding:
                        EdgeInsets.only(top: height / 32, bottom: height / 64),
                    child: Button(
                      onTap: () {
                        setState(() {
                          selectedChoices = selectedChoices == i ? null : i;
                        });
                      },
                      verticalPadding: 8,
                      horizontalPadding: 0,
                      width: width * 0.3,
                      borderRadius: 8,
                      border: 0,
                      buttonColor: selectedChoices == i ? kPurple : kGray,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width / 40),
                        child: Text(
                          '${[
                            'أ',
                            'ب',
                            'ج',
                            'د',
                          ][i]}.   ${questionChoices[i]}',
                          style: textStyle.copyWith(
                              fontSize: width / 70,
                              fontWeight: FontWeight.w700,
                              color: selectedChoices == i ? kBlack : kWhite),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
              height: double.infinity,
              width: width * 0.1,
              color: kPurple,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Icon(
                          Icons.navigate_next_rounded,
                          size: width / 50,
                          color: kWhite,
                        ),
                        Text(
                          'السؤال التالي',
                          style: textStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: width / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      popUp(context, width / 4, 'معلومات عن السؤال', [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'كاتب السؤال هو الأستاذ $questionWriter',
                            style: textStyle.copyWith(color: kBlack),
                          ),
                        ),
                      ]);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          size: width / 50,
                          color: kWhite,
                        ),
                        Text(
                          'معلومات السؤال',
                          style: textStyle.copyWith(
                            color: kWhite,
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
                          color: kWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: width / 100,
                        ),
                      ),
                      Text(
                        '$questionIndex/$questionNum',
                        style: textStyle.copyWith(
                          color: kWhite,
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
                          color: kWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: width / 100,
                        ),
                      ),
                      StreamBuilder<int>(
                        stream: singleQuestionTimer.rawTime,
                        initialData: singleQuestionTimer.rawTime.value,
                        builder: (context, snap) {
                          final displayTime = StopWatchTimer.getDisplayTime(
                              snap.data!,
                              milliSecond: false);
                          return Text(
                            displayTime,
                            style: textStyle.copyWith(
                              color: kWhite,
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
                        'الرمز',
                        style: textStyle.copyWith(
                          color: kWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: width / 100,
                        ),
                      ),
                      Text(
                        questionID,
                        style: textStyle.copyWith(
                          color: kWhite,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          popUp(context, width / 2, 'بلاغ', [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ملاحظاتك',
                                style: textStyle.copyWith(color: kBlack),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                focusedBorder: const OutlineInputBorder(),
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
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'تنويه',
                                style: textStyle.copyWith(color: kBlack),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'يرجى كتابة كافة ملاحظاتك عن السؤال وسيقوم الفريق المختص بالتأكد من الأمر بأقرب وقت',
                                style: textStyle.copyWith(color: kBlack),
                              ),
                            ),
                          ]);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: width / 50,
                              color: kWhite,
                            ),
                            Text(
                              'بلاغ',
                              style: textStyle.copyWith(
                                color: kWhite,
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
                              questionHint,
                              style: textStyle.copyWith(color: kBlack),
                            ),
                          ]);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.help_outline_rounded,
                              size: width / 50,
                              color: kWhite,
                            ),
                            Text(
                              'مساعدة',
                              style: textStyle.copyWith(
                                color: kWhite,
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
                          color: kWhite,
                        ),
                        Text(
                          'إنهاء الإمتحان',
                          style: textStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: width / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}
