import 'package:flutter/material.dart';
import 'welcome.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../const.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';
import 'advance_quiz_setting.dart';
import 'dashboard.dart';

class QuizSetting extends StatefulWidget {
  static const String route = '/QuizSetting/';

  const QuizSetting({Key? key}) : super(key: key);

  @override
  State<QuizSetting> createState() => _QuizSettingState();
}

class _QuizSettingState extends State<QuizSetting> {
  bool loaded = false;

  String? selectedSubjectID;
  String? selectedSubjectName;
  Map subjects = {"scientific": [], "literary": []};

  void getSubjects() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('subject_set/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              subjects = result;
              loaded = true;
            });
    });
  }

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return loaded
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
                    padding: EdgeInsets.only(right: width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height / 128),
                          child: Text(
                            'كتيب المواد',
                            style: textStyle.copyWith(
                              color: kWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: width / 45,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height / 32),
                          child: Text(
                            'يحتوي كتيب المواد على واجهة تقودك إلى امتحانات المواد والتمارين عليها',
                            style: textStyle.copyWith(
                              color: kWhite,
                              fontWeight: FontWeight.normal,
                              fontSize: width / 90,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'المواد العلمية',
                                style: textStyle.copyWith(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width / 60,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.89,
                              height: height / 5,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (int i = 0;
                                      i < subjects['scientific'].length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Button(
                                        onTap: () {
                                          setState(() {
                                            selectedSubjectID ==
                                                    subjects['scientific'][i]
                                                        ['id']
                                                ? {
                                                    selectedSubjectID = null,
                                                    selectedSubjectName = null
                                                  }
                                                : {
                                                    selectedSubjectID =
                                                        subjects['scientific']
                                                            [i]['id'],
                                                    selectedSubjectName =
                                                        subjects['scientific']
                                                            [i]['name']
                                                  };
                                          });
                                        },
                                        width: width * 0.21,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: 8,
                                        border: 0,
                                        buttonColor: selectedSubjectID ==
                                                subjects['scientific'][i]['id']
                                            ? kPurple
                                            : kGray,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: width / 60),
                                              child: Text(
                                                '${subjects['scientific'][i]['name']} ف${subjects['scientific'][i]['semester']}',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 80,
                                                    fontWeight: FontWeight.w700,
                                                    color: selectedSubjectID ==
                                                            subjects[
                                                                    'scientific']
                                                                [i]['id']
                                                        ? kBlack
                                                        : kWhite),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                  image: const AssetImage(
                                                      'images/planet.png'),
                                                  width: width * 0.085,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: height / 64),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'المواد الأدبية',
                                style: textStyle.copyWith(
                                  color: kWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width / 60,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.89,
                              height: height / 5,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  for (int i = 0;
                                      i < subjects['literary'].length;
                                      i++)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Button(
                                        onTap: () {
                                          setState(() {
                                            selectedSubjectID ==
                                                    subjects['literary'][i]
                                                        ['id']
                                                ? {
                                                    selectedSubjectID = null,
                                                    selectedSubjectName = null
                                                  }
                                                : {
                                                    selectedSubjectID =
                                                        subjects['literary'][i]
                                                            ['id'],
                                                    selectedSubjectName =
                                                        subjects['literary'][i]
                                                            ['name']
                                                  };
                                          });
                                        },
                                        width: width * 0.21,
                                        verticalPadding: 0,
                                        horizontalPadding: 0,
                                        borderRadius: 8,
                                        border: 0,
                                        buttonColor: selectedSubjectID ==
                                                subjects['literary'][i]['id']
                                            ? kPurple
                                            : kGray,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: width / 70),
                                              child: Text(
                                                '${subjects['literary'][i]['name']} ف${subjects['literary'][i]['semester']}',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 80,
                                                    fontWeight: FontWeight.w700,
                                                    color: selectedSubjectID ==
                                                            subjects['literary']
                                                                [i]['id']
                                                        ? kBlack
                                                        : kWhite),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                  image: const AssetImage(
                                                      'images/planet.png'),
                                                  width: width * 0.085,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: height / 32),
                        Button(
                          onTap: () {
                            if (selectedSubjectName != null) {
                              Navigator.pushNamed(
                                  context, AdvanceQuizSetting.route,
                                  arguments: {
                                    'subjectName': selectedSubjectName,
                                    'subjectID': selectedSubjectID
                                  });
                            }
                          },
                          width: width * 0.15,
                          verticalPadding: height * 0.01,
                          horizontalPadding: width / 70,
                          borderRadius: 8,
                          border: 0,
                          buttonColor: kPurple,
                          child: Text(
                            'المتابعة',
                            style: textStyle.copyWith(
                                fontSize: width / 60,
                                fontWeight: FontWeight.w900,
                                color: kBlack),
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
