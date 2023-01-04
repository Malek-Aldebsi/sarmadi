import 'dart:math';

import 'package:flutter/material.dart';
import 'question.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_checkbox.dart';
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

class _AdvanceQuizSettingState extends State<AdvanceQuizSetting> {
  bool skillsLoaded = false;
  bool lessonsLoaded = false;

  String? selectedSubjectName;
  String? selectedSubjectID;

  int questionNum = 20;

  TextEditingController hours = TextEditingController(text: '00');
  TextEditingController minutes = TextEditingController(text: '05');
  TextEditingController seconds = TextEditingController(text: '00');
  bool withTime = false;

  int searchMethod = 0;

  TextEditingController search = TextEditingController();

  List skillSet = [];
  Set selectedSkills = {};

  List lessonSet = [];
  Set selectedLessons = {};

  void getSkills() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('skill_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject_id': selectedSubjectID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              skillSet = result;
              skillsLoaded = true;
            });
    });
  }

  void getLessons() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('lesson_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'subject_id': selectedSubjectID,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              lessonSet = result;
              lessonsLoaded = true;
            });
    });
  }

  void getSkillQuiz() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('skills_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'skills': selectedSkills.toList(),
      'question_num': questionNum,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              setState(() {
                print(result);
              }),
              Navigator.pushNamed(context, Question.route)
            };
    });
  }

  void getLessonQuiz() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('lessons_quiz/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
      'lessons': selectedLessons.toList(),
      'question_num': questionNum,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : {
              setState(() {
                print(result);
              }),
              Navigator.pushNamed(context, Question.route)
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
        getSkills();
        getLessons();
      } catch (e) {
        Navigator.pushNamed(context, QuizSetting.route);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return lessonsLoaded && skillsLoaded
        ? Scaffold(
            body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/single_question_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: double.infinity,
                      width: width * 0.06,
                      decoration: BoxDecoration(
                          border:
                              Border(left: BorderSide(color: kGray, width: 1))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: const AssetImage('images/logo.png'),
                            width: width * 0.05,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Dashboard.route);
                                  }, //home dashboard
                                  icon: Icon(
                                    Icons.home_outlined,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {}, //userprofile
                                  icon: Icon(
                                    Icons.person_outline_rounded,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, QuizSetting.route);
                                  }, //home dashboard
                                  icon: Icon(
                                    Icons.school_rounded,
                                    size: width * 0.02,
                                    color: kPurple,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {}, //analysis
                                  icon: Icon(
                                    Icons.pie_chart_outline_rounded,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {}, //community
                                  icon: Icon(
                                    Icons.forum_outlined,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {}, //leaderboard
                                  icon: Icon(
                                    Icons.leaderboard_outlined,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 40),
                                child: IconButton(
                                  onPressed: () {}, //settings
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    size: width * 0.02,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 40),
                            child: IconButton(
                              onPressed: () {
                                popUp(context, width * 0.3,
                                    'هل حقاً تريد تسجيل الخروج', [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Button(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        width: width * 0.13,
                                        verticalPadding: 8,
                                        horizontalPadding: 0,
                                        borderRadius: 8,
                                        buttonColor: kBlack,
                                        border: 0,
                                        child: Center(
                                          child: Text(
                                            'لا',
                                            style: textStyle,
                                          ),
                                        ),
                                      ),
                                      Button(
                                        onTap: () {
                                          delSession('sessionKey0');
                                          delSession('sessionKey1');
                                          delSession('sessionValue').then(
                                              (value) => Navigator.pushNamed(
                                                  context, Welcome.route));
                                        },
                                        width: width * 0.13,
                                        verticalPadding: 8,
                                        horizontalPadding: 0,
                                        borderRadius: 8,
                                        buttonColor: kOffWhite,
                                        border: 0,
                                        child: Center(
                                          child: Text(
                                            'نعم',
                                            style: textStyle.copyWith(
                                                color: kBlack),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]);
                              }, //home dashboard
                              icon: Icon(
                                Icons.logout_rounded,
                                size: width * 0.02,
                                color: kWhite,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height / 32),
                          child: Text(
                            selectedSubjectName ?? '',
                            style: textStyle.copyWith(
                              color: kWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: width / 45,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height / 64),
                          child: Row(
                            children: [
                              Button(
                                onTap: () {
                                  setState(() {
                                    searchMethod = 0;
                                  });
                                },
                                width: width / 10,
                                verticalPadding: 8,
                                horizontalPadding: 0,
                                borderRadius: 0,
                                borderColor:
                                    searchMethod == 0 ? kPurple : kOffWhite,
                                border: 1,
                                child: Center(
                                  child: Text(
                                    'الدروس',
                                    style: textStyle.copyWith(
                                      color: searchMethod == 0
                                          ? kPurple
                                          : kOffWhite,
                                      fontSize: width / 85,
                                    ),
                                  ),
                                ),
                              ),
                              Button(
                                onTap: () {
                                  setState(() {
                                    searchMethod = 1;
                                  });
                                },
                                width: width / 10,
                                verticalPadding: 8,
                                horizontalPadding: 0,
                                borderRadius: 20,
                                borderColor:
                                    searchMethod == 1 ? kPurple : kOffWhite,
                                border: 1,
                                child: Center(
                                  child: Text('المهارات',
                                      style: textStyle.copyWith(
                                        color: searchMethod == 1
                                            ? kPurple
                                            : kOffWhite,
                                        fontSize: width / 85,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.73,
                          width: width / 5,
                          child: ListView(
                            children: [
                              if (searchMethod == 1)
                                CustomTextField(
                                  innerText: null,
                                  hintText: 'ابحث...',
                                  fontSize: width / 90,
                                  width: width / 6,
                                  controller: search,
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: width * 0.02,
                                    color: kOffWhite,
                                  ),
                                  isDense: true,
                                  onChanged: (text) {},
                                  readOnly: false,
                                  obscure: false,
                                  suffixIcon: null,
                                  keyboardType: null,
                                  color: kGray,
                                  verticalPadding: height * 0.02,
                                  horizontalPadding: width / 42.5,
                                  border: inputBorder(),
                                  focusedBorder: focusedBorder(),
                                ),
                              if (searchMethod == 1)
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.01),
                                  child: Divider(
                                    thickness: 1,
                                    color: kGray,
                                  ),
                                ),
                              if (searchMethod == 1)
                                for (Map skill in skillSet)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 128),
                                    child: Button(
                                      onTap: null,
                                      width: width * 0.2,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: 10,
                                      border: 0,
                                      buttonColor:
                                          skill['status'] ? kPurple : kGray,
                                      child: Padding(
                                        padding: EdgeInsets.all(width / 75),
                                        child: SizedBox(
                                          width: width * 0.18,
                                          child: Row(children: [
                                            CustomCheckBox(
                                              width: width / 1.5,
                                              checked: skill['status'],
                                              onTap: () {
                                                setState(
                                                  () {
                                                    skill['status']
                                                        ? {
                                                            skill['status'] =
                                                                !skill[
                                                                    'status'],
                                                            selectedSkills
                                                                .remove((skill[
                                                                    'id']))
                                                          }
                                                        : {
                                                            skill['status'] =
                                                                !skill[
                                                                    'status'],
                                                            selectedSkills.add(
                                                                (skill['id']))
                                                          };
                                                  },
                                                );
                                              },
                                            ),
                                            SizedBox(width: width / 80),
                                            Text(
                                              skill['name'],
                                              style: textStyle.copyWith(
                                                  color: skill['status']
                                                      ? kBlack
                                                      : kOffWhite,
                                                  fontSize: width / 90,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                              if (searchMethod == 0)
                                for (Map module in lessonSet)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height / 128),
                                    child: Button(
                                      onTap: null,
                                      width: width * 0.2,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: 10,
                                      border: 0,
                                      buttonColor:
                                          module['status'] ? kPurple : kGray,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: width / 150,
                                            horizontal: width / 75),
                                        child: SizedBox(
                                          width: width * 0.18,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: width / 200),
                                                child: Row(children: [
                                                  CustomCheckBox(
                                                    width: width / 1.5,
                                                    checked: module['status'],
                                                    onTap: () {
                                                      setState(() {
                                                        module['status'] =
                                                            !module['status'];
                                                        for (Map lesson
                                                            in module[
                                                                'lessons']) {
                                                          module['status']
                                                              ? {
                                                                  lesson['status'] =
                                                                      module[
                                                                          'status'],
                                                                  selectedLessons
                                                                      .add(lesson[
                                                                          'id'])
                                                                }
                                                              : {
                                                                  lesson['status'] =
                                                                      module[
                                                                          'status'],
                                                                  selectedLessons
                                                                      .remove(lesson[
                                                                          'id'])
                                                                };
                                                        }
                                                      });
                                                    },
                                                  ),
                                                  SizedBox(width: width / 80),
                                                  Text(
                                                    module['name'],
                                                    style: textStyle.copyWith(
                                                        color: module['status']
                                                            ? kBlack
                                                            : kOffWhite,
                                                        fontSize: width / 90,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ]),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, width / 40, 0),
                                                child: Column(
                                                  children: [
                                                    for (Map lesson
                                                        in module['lessons'])
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    width /
                                                                        450),
                                                        child: Row(children: [
                                                          CustomCheckBox(
                                                            width: width / 3,
                                                            checked: lesson[
                                                                'status'],
                                                            onTap: () {
                                                              setState(
                                                                () {
                                                                  bool
                                                                      isAllChecked() {
                                                                    bool
                                                                        isAllChecked =
                                                                        true;
                                                                    for (Map lesson
                                                                        in module[
                                                                            'lessons']) {
                                                                      isAllChecked =
                                                                          isAllChecked &&
                                                                              lesson['status'];
                                                                    }
                                                                    return isAllChecked;
                                                                  }

                                                                  if (isAllChecked()) {
                                                                    lesson['status']
                                                                        ? {
                                                                            lesson['status'] =
                                                                                !lesson['status'],
                                                                            selectedLessons.remove(lesson['id'])
                                                                          }
                                                                        : {
                                                                            lesson['status'] =
                                                                                !lesson['status'],
                                                                            selectedLessons.add(lesson['id'])
                                                                          };
                                                                    module['status'] =
                                                                        !module[
                                                                            'status'];
                                                                  } else {
                                                                    lesson['status']
                                                                        ? {
                                                                            lesson['status'] =
                                                                                !lesson['status'],
                                                                            selectedLessons.remove(lesson['id'])
                                                                          }
                                                                        : {
                                                                            lesson['status'] =
                                                                                !lesson['status'],
                                                                            selectedLessons.add(lesson['id'])
                                                                          };
                                                                    if (isAllChecked()) {
                                                                      module['status'] =
                                                                          !module[
                                                                              'status'];
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  width / 80),
                                                          Text(
                                                            lesson['name'],
                                                            style: textStyle.copyWith(
                                                                color: module[
                                                                        'status']
                                                                    ? kBlack
                                                                    : kOffWhite,
                                                                fontSize:
                                                                    width / 130,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ]),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: kGray,
                    indent: height * 0.3,
                    endIndent: 0,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'عدد الأسئلة',
                          style: textStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.016,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.31,
                          child: slider(
                            15,
                            40,
                            1,
                            1,
                            questionNum,
                            (double value) {
                              setState(() {
                                questionNum = value == 0 ? 1 : value.floor();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        Text(
                          'وقت الإمتحان',
                          style: textStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.016,
                          ),
                        ),
                        Row(
                          children: [
                            CustomTextField(
                              innerText: null,
                              hintText: '00',
                              fontSize: width * 0.02,
                              width: width * 0.07,
                              controller: seconds,
                              textAlign: TextAlign.center,
                              onChanged: (text) {
                                if (!RegExp(r'^[0-9:]+$').hasMatch(text)) {
                                  seconds.text = '';
                                }
                                if (text.length > 2) {
                                  seconds.text =
                                      min(int.parse(text), 60).toString();
                                }
                              },
                              maxLength: 2,
                              verticalPadding: width * 0.01,
                              horizontalPadding: width * 0.01,
                              readOnly: false,
                              obscure: false,
                              suffixIcon: null,
                              keyboardType: TextInputType.number,
                              color: kGray,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.015,
                                  horizontal: width * 0.02),
                              child: Text(
                                ':',
                                style: textStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: kPurple,
                                ),
                              ),
                            ),
                            CustomTextField(
                              innerText: null,
                              hintText: '05',
                              fontSize: width * 0.02,
                              width: width * 0.07,
                              controller: minutes,
                              textAlign: TextAlign.center,
                              onChanged: (text) {
                                if (!RegExp(r'^[0-9:]+$').hasMatch(text)) {
                                  minutes.text = '';
                                }
                                if (text.length > 1) {
                                  minutes.text =
                                      min(int.parse(text), 60).toString();
                                }
                              },
                              maxLength: 2,
                              verticalPadding: width * 0.01,
                              horizontalPadding: width * 0.01,
                              readOnly: false,
                              obscure: false,
                              suffixIcon: null,
                              keyboardType: TextInputType.number,
                              color: kGray,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.015,
                                  horizontal: width * 0.02),
                              child: Text(
                                ':',
                                style: textStyle.copyWith(
                                  fontSize: width * 0.04,
                                  color: kPurple,
                                ),
                              ),
                            ),
                            CustomTextField(
                              innerText: null,
                              hintText: '00',
                              fontSize: width * 0.02,
                              width: width * 0.07,
                              controller: hours,
                              textAlign: TextAlign.center,
                              onChanged: (text) {
                                if (!RegExp(r'^[0-9:]+$').hasMatch(text)) {
                                  hours.text = '';
                                }
                                if (text.length > 1) {
                                  hours.text =
                                      min(int.parse(text), 5).toString();
                                }
                              },
                              maxLength: 2,
                              verticalPadding: width * 0.01,
                              horizontalPadding: width * 0.01,
                              readOnly: false,
                              obscure: false,
                              suffixIcon: null,
                              keyboardType: TextInputType.number,
                              color: kGray,
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Button(
                          onTap: null,
                          width: width * 0.2,
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          borderRadius: 10,
                          border: 0,
                          child: SizedBox(
                            width: width * 0.18,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Row(children: [
                                CustomCheckBox(
                                  width: width / 1.5,
                                  checked: withTime,
                                  onTap: () {
                                    setState(
                                      () {
                                        withTime = !withTime;
                                      },
                                    );
                                  },
                                ),
                                SizedBox(width: width / 80),
                                Text(
                                  'بدون وقت',
                                  style: textStyle.copyWith(
                                      color: withTime ? kPurple : kOffWhite,
                                      fontSize: width / 90,
                                      fontWeight: FontWeight.w700),
                                ),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.07,
                        ),
                        Button(
                          onTap: () {
                            if (selectedLessons.isNotEmpty ||
                                selectedSkills.isNotEmpty) {
                              searchMethod == 0
                                  ? getLessonQuiz()
                                  : getSkillQuiz();
                            }
                          },
                          width: width * 0.31,
                          verticalPadding: 8,
                          horizontalPadding: 0,
                          borderRadius: 8,
                          buttonColor: kPurple,
                          border: 0,
                          child: Center(
                            child: Text(
                              'أنشئ',
                              style: textStyle.copyWith(
                                fontSize: width / 85,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
        : Scaffold(
            backgroundColor: kGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
