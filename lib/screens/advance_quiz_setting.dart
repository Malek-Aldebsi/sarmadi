import 'package:flutter/material.dart';
import 'question.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../components/custom_slider.dart';
import '../components/custom_text_field.dart';
import '../const.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'dashboard.dart';

class AdvanceQuizSetting extends StatefulWidget {
  static const String route = '/AdvanceQuizSetting/';

  final String? subjectID;
  final String? subjectName;
  const AdvanceQuizSetting({super.key, this.subjectID, this.subjectName});

  @override
  State<AdvanceQuizSetting> createState() => _AdvanceQuizSettingState();
}

class _AdvanceQuizSettingState extends State<AdvanceQuizSetting>
    with TickerProviderStateMixin {
  bool headlinesLoaded = false;
  bool modulesLoaded = false;

  String? selectedSubjectName;
  String? selectedSubjectID;

  int questionNum = 20;

  TextEditingController hours = TextEditingController(text: '00');
  TextEditingController minutes = TextEditingController(text: '05');
  TextEditingController seconds = TextEditingController(text: '00');
  bool withTime = true;

  List headlineSet = [];
  Set selectedHeadlines = {};

  List moduleSet = [];

  int quizLevel = 0; // 0 easy, 1 hard, 2 default

  void getHeadlines() async {
    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('headline_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject_id': selectedSubjectID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              headlineSet = result;
              print(headlineSet);
              headlinesLoaded = true;
            });
    });
  }

  void getModules() async {
    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('module_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject_id': selectedSubjectID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              moduleSet = result;
              print(moduleSet);
              modulesLoaded = true;
            });
    });
  }

  void buildQuiz() async {
    //TODO another one for study
    setState(() {
      headlinesLoaded = false;
      modulesLoaded = false;
    });

    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('build_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'headlines': selectedHeadlines.toList(),
      'question_num': questionNum,
      'duration': 5000,
      'quiz_level': quizLevel,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Dashboard.route)
          : {
              Navigator.pushNamed(context, Question.route, arguments: {
                'questions': result,
                'duration': int.parse(hours.text == '' ? '00' : hours.text) *
                        3600 +
                    int.parse(minutes.text == '' ? '05' : minutes.text) * 60 +
                    int.parse(seconds.text == '' ? '00' : seconds.text),
                'subjectID': selectedSubjectID,
              })
            };
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      try {
        dynamic arguments = ModalRoute.of(context)?.settings.arguments;
        setState(() {
          selectedSubjectName = arguments['subjectName'];
          selectedSubjectID = arguments['subjectID'];
        });
        getHeadlines();
        getModules();
      } catch (e) {
        Navigator.pushNamed(context, QuizSetting.route);
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

  bool barVisibility = false;

  AnimationController? forwardAnimationController;
  CurvedAnimation? forwardAnimationCurve;
  dynamic forwardAnimationValue = 1;

  AnimationController? backwardAnimationController;
  CurvedAnimation? backwardAnimationCurve;
  dynamic backwardAnimationValue = 0;

  bool moduleStatus(Map module) {
    bool status = true;
    for (Map lesson in module['lessons']) {
      status = status && selectedHeadlines.containsAll(lesson['h1s']);
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return modulesLoaded && headlinesLoaded
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: width * 0.05),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: height / 25),
                              child: Text(
                                selectedSubjectName ?? '',
                                style: textStyle.copyWith(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.018,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'الفصل الأول',
                                      style: textStyle.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.012,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.35,
                                      width: width * 0.2,
                                      child: ListView(
                                        children: [
                                          for (Map module in moduleSet)
                                            if (module['semester'] == 1)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: height / 128,
                                                ),
                                                child: Button(
                                                  onTap: () {
                                                    setState(() {
                                                      bool status =
                                                          moduleStatus(module);
                                                      for (Map lesson in module[
                                                          'lessons']) {
                                                        status
                                                            ? selectedHeadlines
                                                                .removeAll(
                                                                    lesson[
                                                                        'h1s'])
                                                            : selectedHeadlines
                                                                .addAll(lesson[
                                                                    'h1s']);
                                                      }
                                                    });
                                                  },
                                                  width: width * 0.2,
                                                  verticalPadding: width / 150,
                                                  horizontalPadding: width / 75,
                                                  borderRadius: width * 0.006,
                                                  border: 0,
                                                  buttonColor:
                                                      moduleStatus(module)
                                                          ? kDarkPurple
                                                          : kLightGray,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        module['name'],
                                                        style:
                                                            textStyle.copyWith(
                                                                color: kWhite,
                                                                fontSize:
                                                                    width *
                                                                        0.009,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          for (Map lesson
                                                              in module[
                                                                  'lessons'])
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      width /
                                                                          350),
                                                              child: Button(
                                                                  onTap: () {
                                                                    setState(
                                                                      () {
                                                                        if (moduleStatus(
                                                                            module)) {
                                                                          selectedHeadlines
                                                                              .removeAll(lesson['h1s']);
                                                                        } else {
                                                                          selectedHeadlines.containsAll(lesson['h1s'])
                                                                              ? selectedHeadlines.removeAll(lesson['h1s'])
                                                                              : selectedHeadlines.addAll(lesson['h1s']);
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  verticalPadding:
                                                                      width /
                                                                          250,
                                                                  horizontalPadding:
                                                                      width /
                                                                          250,
                                                                  borderRadius:
                                                                      width *
                                                                          0.005,
                                                                  border: 0,
                                                                  buttonColor: selectedHeadlines
                                                                          .containsAll(
                                                                              lesson['h1s'])
                                                                      ? kPurple
                                                                      : kGray,
                                                                  child: Text(
                                                                    lesson[
                                                                        'name'],
                                                                    style: textStyle
                                                                        .copyWith(
                                                                      color: selectedHeadlines
                                                                              .containsAll(lesson['h1s'])
                                                                          ? kWhite
                                                                          : kOffWhite,
                                                                      fontSize:
                                                                          width *
                                                                              0.007,
                                                                    ),
                                                                  )),
                                                            )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      'الفصل الثاني',
                                      style: textStyle.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.012,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.35,
                                      width: width * 0.2,
                                      child: ListView(
                                        children: [
                                          for (Map module in moduleSet)
                                            if (module['semester'] == 2)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: height / 128,
                                                ),
                                                child: Button(
                                                  onTap: () {
                                                    setState(() {
                                                      bool status =
                                                          moduleStatus(module);
                                                      for (Map lesson in module[
                                                          'lessons']) {
                                                        status
                                                            ? selectedHeadlines
                                                                .removeAll(
                                                                    lesson[
                                                                        'h1s'])
                                                            : selectedHeadlines
                                                                .addAll(lesson[
                                                                    'h1s']);
                                                      }
                                                    });
                                                  },
                                                  width: width * 0.2,
                                                  verticalPadding: width / 150,
                                                  horizontalPadding: width / 75,
                                                  borderRadius: width * 0.006,
                                                  border: 0,
                                                  buttonColor:
                                                      moduleStatus(module)
                                                          ? kDarkPurple
                                                          : kLightGray,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        module['name'],
                                                        style:
                                                            textStyle.copyWith(
                                                                color: kWhite,
                                                                fontSize:
                                                                    width *
                                                                        0.009,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      Wrap(
                                                        children: [
                                                          for (Map lesson
                                                              in module[
                                                                  'lessons'])
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      width /
                                                                          350),
                                                              child: Button(
                                                                  onTap: () {
                                                                    setState(
                                                                      () {
                                                                        if (moduleStatus(
                                                                            module)) {
                                                                          selectedHeadlines
                                                                              .removeAll(lesson['h1s']);
                                                                        } else {
                                                                          selectedHeadlines.containsAll(lesson['h1s'])
                                                                              ? selectedHeadlines.removeAll(lesson['h1s'])
                                                                              : selectedHeadlines.addAll(lesson['h1s']);
                                                                        }
                                                                      },
                                                                    );
                                                                  },
                                                                  verticalPadding:
                                                                      width /
                                                                          250,
                                                                  horizontalPadding:
                                                                      width /
                                                                          250,
                                                                  borderRadius:
                                                                      width *
                                                                          0.005,
                                                                  border: 0,
                                                                  buttonColor: selectedHeadlines
                                                                          .containsAll(
                                                                              lesson['h1s'])
                                                                      ? kPurple
                                                                      : kGray,
                                                                  child: Text(
                                                                    lesson[
                                                                        'name'],
                                                                    style: textStyle
                                                                        .copyWith(
                                                                      color: selectedHeadlines
                                                                              .containsAll(lesson['h1s'])
                                                                          ? kWhite
                                                                          : kOffWhite,
                                                                      fontSize:
                                                                          width *
                                                                              0.007,
                                                                    ),
                                                                  )),
                                                            )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'المهارات',
                                          style: textStyle.copyWith(
                                            color: kWhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * 0.012,
                                          ),
                                        ),
                                        SizedBox(width: width * 0.035),
                                        Icon(
                                          Icons.search_rounded,
                                          size: width * 0.016,
                                          color: kOffWhite,
                                        ),
                                      ],
                                    ),
                                    Button(
                                      onTap: null,
                                      verticalPadding: width / 150,
                                      horizontalPadding: width / 100,
                                      borderRadius: width * 0.005,
                                      border: 0,
                                      buttonColor: kLightGray,
                                      height: height * 0.5,
                                      width: width * 0.2,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Wrap(
                                          runSpacing: width / 250,
                                          spacing: width / 250,
                                          children: [
                                            for (Map headline in headlineSet)
                                              Button(
                                                  onTap: () {
                                                    setState(
                                                      () {
                                                        selectedHeadlines
                                                                .contains(
                                                                    headline[
                                                                        'id'])
                                                            ? selectedHeadlines
                                                                .remove(
                                                                    (headline[
                                                                        'id']))
                                                            : selectedHeadlines
                                                                .add((headline[
                                                                    'id']));
                                                      },
                                                    );
                                                  },
                                                  verticalPadding: width / 250,
                                                  horizontalPadding:
                                                      width / 100,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: selectedHeadlines
                                                          .contains(
                                                              headline['id'])
                                                      ? kPurple
                                                      : kGray,
                                                  child: Text(
                                                    headline['name'],
                                                    style: textStyle.copyWith(
                                                      color: selectedHeadlines
                                                              .contains(
                                                                  headline[
                                                                      'id'])
                                                          ? kWhite
                                                          : kOffWhite,
                                                      fontSize: width * 0.007,
                                                    ),
                                                  ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width * 0.05),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'عدد الأسئلة',
                                      style: textStyle.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.012,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Center(
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor: kPurple,
                                            inactiveTrackColor: kGray,
                                            trackHeight: height * 0.021,
                                            trackShape:
                                                const RoundedTrackShape(),
                                            thumbShape: CustomSliderThumbRect(
                                                max: 60,
                                                min: 0,
                                                thumbRadius: 1,
                                                thumbHeight: height * 0.04),
                                            overlayColor:
                                                kPurple.withOpacity(0.3),
                                            activeTickMarkColor:
                                                Colors.transparent,
                                            inactiveTickMarkColor:
                                                Colors.transparent,
                                          ),
                                          child: Slider(
                                              min: 0,
                                              max: 60,
                                              value: questionNum >
                                                      selectedHeadlines.length
                                                  ? questionNum.toDouble()
                                                  : selectedHeadlines.length
                                                      .toDouble(),
                                              onChanged: (value) {
                                                setState(() {
                                                  questionNum = value.floor();
                                                });
                                              }),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: height / 32),
                                    Text(
                                      'وقت الإمتحان',
                                      style: textStyle.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.012,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Button(
                                      onTap: null,
                                      width: width * 0.3,
                                      height: height * 0.1,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      border: 0,
                                      buttonColor: kLightGray,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: kGray,
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.005),
                                                    bottomRight:
                                                        Radius.circular(
                                                            width * 0.005))),
                                            height: height * 0.1,
                                            child: MaterialButton(
                                              color: withTime ? kPurple : kGray,
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    withTime = !withTime;
                                                  },
                                                );
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        width * 0.005),
                                                    bottomRight:
                                                        Radius.circular(
                                                            width * 0.005)),
                                              ),
                                              padding:
                                                  EdgeInsets.all(height * 0.03),
                                              minWidth: width * 0.075,
                                              child: Text(
                                                'تفعيل\nالمؤقت',
                                                style: textStyle.copyWith(
                                                    color: withTime
                                                        ? kWhite
                                                        : kOffWhite,
                                                    fontSize: width * 0.009,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          CustomTextField(
                                            innerText: null,
                                            hintText: '00',
                                            fontSize: width * 0.015,
                                            width: width * 0.05,
                                            controller: seconds,
                                            textAlign: TextAlign.center,
                                            onChanged: (text) {
                                              if (!RegExp(r'^[0-9:]+$')
                                                  .hasMatch(text)) {
                                                seconds.text = '';
                                              }
                                              if (int.parse(text) > 60) {
                                                seconds.text = '60';
                                              } else if (text.length > 2) {
                                                seconds.text = '00';
                                              }
                                            },
                                            verticalPadding: width * 0.004,
                                            horizontalPadding: width * 0.008,
                                            readOnly: false,
                                            obscure: false,
                                            suffixIcon: null,
                                            keyboardType: TextInputType.number,
                                            color: kGray,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ':',
                                            style: textStyle.copyWith(
                                              fontSize: width * 0.035,
                                              color: kWhite,
                                            ),
                                          ),
                                          CustomTextField(
                                            innerText: null,
                                            hintText: '05',
                                            fontSize: width * 0.015,
                                            width: width * 0.05,
                                            controller: minutes,
                                            textAlign: TextAlign.center,
                                            onChanged: (text) {
                                              if (!RegExp(r'^[0-9:]+$')
                                                  .hasMatch(text)) {
                                                minutes.text = '';
                                              }
                                              if (int.parse(text) > 60) {
                                                minutes.text = '60';
                                              } else if (text.length > 2) {
                                                minutes.text = '00';
                                              }
                                            },
                                            verticalPadding: width * 0.004,
                                            horizontalPadding: width * 0.008,
                                            readOnly: false,
                                            obscure: false,
                                            suffixIcon: null,
                                            keyboardType: TextInputType.number,
                                            color: kGray,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ':',
                                            style: textStyle.copyWith(
                                              fontSize: width * 0.035,
                                              color: kWhite,
                                            ),
                                          ),
                                          CustomTextField(
                                            innerText: null,
                                            hintText: '00',
                                            fontSize: width * 0.015,
                                            width: width * 0.05,
                                            controller: hours,
                                            textAlign: TextAlign.center,
                                            onChanged: (text) {
                                              if (!RegExp(r'^[0-9:]+$')
                                                  .hasMatch(text)) {
                                                hours.text = '';
                                              }
                                              if (int.parse(text) > 5) {
                                                hours.text = '05';
                                              } else if (text.length > 2) {
                                                hours.text = '00';
                                              }
                                            },
                                            verticalPadding: width * 0.004,
                                            horizontalPadding: width * 0.008,
                                            readOnly: false,
                                            obscure: false,
                                            suffixIcon: null,
                                            keyboardType: TextInputType.number,
                                            color: kGray,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.005)),
                                              borderSide: const BorderSide(
                                                color: Colors.transparent,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height / 32),
                                    Text(
                                      'صعوبة الإمتحان',
                                      style: textStyle.copyWith(
                                        color: kWhite,
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.012,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: kLightGray,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Button(
                                            onTap: () {
                                              setState(() {
                                                quizLevel = 0;
                                              });
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.01,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.006,
                                            buttonColor: quizLevel == 0
                                                ? kPurple
                                                : kLightGray,
                                            border: 0,
                                            child: Center(
                                              child: Text(
                                                'سهل',
                                                style: textStyle.copyWith(
                                                    color: quizLevel == 0
                                                        ? kWhite
                                                        : kOffWhite,
                                                    fontSize: width * 0.009,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Button(
                                            onTap: () {
                                              setState(() {
                                                quizLevel = 1;
                                              });
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.01,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.006,
                                            buttonColor: quizLevel == 1
                                                ? kPurple
                                                : kLightGray,
                                            border: 0,
                                            child: Center(
                                              child: Text(
                                                'صعب',
                                                style: textStyle.copyWith(
                                                    color: quizLevel == 1
                                                        ? kWhite
                                                        : kOffWhite,
                                                    fontSize: width * 0.009,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Button(
                                            onTap: () {
                                              setState(() {
                                                quizLevel = 2;
                                              });
                                            },
                                            width: width * 0.1,
                                            verticalPadding: height * 0.01,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.006,
                                            buttonColor: quizLevel == 2
                                                ? kPurple
                                                : kLightGray,
                                            border: 0,
                                            child: Center(
                                              child: Text(
                                                'تلقائي',
                                                style: textStyle.copyWith(
                                                    color: quizLevel == 2
                                                        ? kWhite
                                                        : kOffWhite,
                                                    fontSize: width * 0.009,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: height / 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Button(
                                          onTap: () {
                                            if (selectedHeadlines.isNotEmpty) {
                                              buildQuiz();
                                            }
                                          },
                                          width: width * 0.13,
                                          verticalPadding: 8,
                                          horizontalPadding: 0,
                                          borderRadius: width * 0.005,
                                          buttonColor: kPurple,
                                          border: 0,
                                          child: Center(
                                            child: Text(
                                              'ادرس',
                                              style: textStyle.copyWith(
                                                  fontSize: width * 0.009,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.04),
                                        Button(
                                          onTap: () {
                                            if (selectedHeadlines.isNotEmpty) {
                                              buildQuiz();
                                            }
                                          },
                                          width: width * 0.13,
                                          verticalPadding: 8,
                                          horizontalPadding: 0,
                                          borderRadius: width * 0.005,
                                          buttonColor: kPurple,
                                          border: 0,
                                          child: Center(
                                            child: Text(
                                              'امتحن',
                                              style: textStyle.copyWith(
                                                  fontSize: width * 0.009,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          ]),
                      const SizedBox(),
                    ],
                  ),
                  MouseRegion(
                    onHover: (isHover) {
                      setState(() {
                        forwardAnimationController!.reverse();
                        forwardAnimationCurve!.addListener(() => setState(() {
                              forwardAnimationValue =
                                  forwardAnimationCurve!.value;
                            }));

                        backwardAnimationController!.forward();
                        backwardAnimationCurve!.addListener(() => setState(() {
                              backwardAnimationValue =
                                  backwardAnimationCurve!.value;
                            }));
                      });
                    },
                    onExit: (e) {
                      setState(() {
                        forwardAnimationController!.forward();
                        forwardAnimationCurve!.addListener(() => setState(() {
                              forwardAnimationValue =
                                  forwardAnimationCurve!.value;
                            }));

                        backwardAnimationController!.reverse();
                        backwardAnimationCurve!.addListener(() => setState(() {
                              backwardAnimationValue =
                                  backwardAnimationCurve!.value;
                            }));
                      });
                    },
                    child: Container(
                        height: height,
                        width: width *
                            (0.06 * forwardAnimationValue +
                                0.2 * backwardAnimationValue),
                        decoration: BoxDecoration(
                            color: kLightBlack.withOpacity(0.95),
                            border: Border(
                                left: BorderSide(color: kLightGray, width: 2))),
                        child: ListView(
                          children: [
                            SizedBox(
                              height: height * 0.06,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'الصفحة الرئيسية',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.home_rounded,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'معلوماتي',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                              child: Divider(
                                thickness: 1,
                                indent: width * 0.005,
                                endIndent: width * 0.005,
                                color: kLightGray,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'يلا نساعدك بالدراسة',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.school_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'امتحانات وأسئلة',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.fact_check_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'نتائج وتحليلات',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.analytics_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'مجتمع مدارس',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.groups,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'قائمة المتصدرين',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.emoji_events_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                              child: Divider(
                                thickness: 1,
                                indent: width * 0.005,
                                endIndent: width * 0.005,
                                color: kLightGray,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'الإعدادات',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.settings_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.01,
                                  horizontal: width * 0.01),
                              child: Button(
                                onTap: () {
                                  Navigator.pushNamed(context, Dashboard.route);
                                },
                                width: width *
                                    (0.032 * forwardAnimationValue +
                                        0.16 * backwardAnimationValue),
                                verticalPadding: width * 0.006,
                                horizontalPadding: width * 0.006,
                                borderRadius: 8,
                                buttonColor: kBlack.withOpacity(0.5),
                                border: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (backwardAnimationValue == 1)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: width *
                                                0.02 *
                                                backwardAnimationValue),
                                        child: Text(
                                          'تواصل معنا',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: width *
                                                  (0.01 *
                                                      backwardAnimationValue),
                                              color: kWhite),
                                        ),
                                      ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: width *
                                              0.02 *
                                              backwardAnimationValue),
                                      child: Icon(
                                        Icons.phone_outlined,
                                        size: width * 0.02,
                                        color: kWhite,
                                      ),
                                    ),
                                    if (backwardAnimationValue != 1) SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
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
