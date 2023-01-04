import 'package:flutter/material.dart';
import 'quiz_setting.dart';
import 'welcome.dart';
import '../components/custom_circular_chart.dart';
import '../components/custom_container.dart';
import '../components/custom_pop_up.dart';
import '../const.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../utils/http_requests.dart';
import '../utils/session.dart';

class Dashboard extends StatefulWidget {
  static const String route = '/Dashboard/';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool loaded = false;

  String userName = '';
  double profileCompletionPercentage = 75;

  List advList = [
    {
      'image': 'images/adv_1.png',
      'title': 'حزمة مميزة',
      'details': 'مقابل 4 دنانير فقط!'
    },
    {
      'image': 'images/adv_2.png',
      'title': 'المجتمع',
      'details': 'المكان المناسب لكافة\nاستفساراتك'
    },
    {
      'image': 'images/adv_3.png',
      'title': 'مزايا جديدة',
      'details': 'أبقو قريبين فالعديد من\nالمزايا في الطريق'
    }
  ];

  void getUser() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');
    post('user_name/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              userName = result;
              loaded = true;
            });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

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
                    image: AssetImage("images/home_dashboard_background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: double.infinity,
                            width: width * 0.06,
                            decoration: BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: kGray, width: 1))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: const AssetImage('images/logo.png'),
                                  width: width * 0.05,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, Dashboard.route);
                                        }, //home dashboard
                                        icon: Icon(
                                          Icons.home_rounded,
                                          size: width * 0.02,
                                          color: kPurple,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, QuizSetting.route);
                                        }, //home dashboard
                                        icon: Icon(
                                          Icons.school_outlined,
                                          size: width * 0.02,
                                          color: kWhite,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 40),
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: height / 40),
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
                                                    (value) =>
                                                        Navigator.pushNamed(
                                                            context,
                                                            Welcome.route));
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Button(
                              onTap: () {},
                              width: width * 0.3,
                              verticalPadding: 0,
                              horizontalPadding: width * 0.01,
                              borderRadius: 10,
                              border: 0,
                              buttonColor: kGray,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: height / 80),
                                          child: Row(
                                            children: [
                                              Text(
                                                'أهلا $userName، صباح الخير',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 70,
                                                    color: kWhite),
                                              ),
                                              SizedBox(width: width / 64),
                                              Icon(
                                                Icons.sunny,
                                                color: Colors.amber,
                                                size: width * 0.025,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'حسابك مكتمل بنسبة',
                                              style: textStyle.copyWith(
                                                  fontSize: width / 100,
                                                  color: kWhite),
                                            ),
                                            SizedBox(width: width / 64),
                                            CircularChart(
                                              width: width * 0.03,
                                              label:
                                                  profileCompletionPercentage,
                                              activeColor: kPurple,
                                              inActiveColor: kWhite,
                                              labelColor: kWhite,
                                            )
                                          ],
                                        ),
                                        Text(
                                          'أظهر المزيد',
                                          style: textStyle.copyWith(
                                              fontSize: width / 130,
                                              color: kPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image(
                                    image: const AssetImage(
                                        'images/user_avatar.png'),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                    height: height * 0.2,
                                    width: width * 0.09,
                                  ),
                                ],
                              ),
                            ),
                            Button(
                              onTap: () {},
                              width: width * 0.3,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              borderRadius: 10,
                              border: 0,
                              buttonColor: kGray,
                              child: Container(height: height * 0.72),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Button(
                              onTap: () {},
                              width: width * 0.216,
                              verticalPadding: 0,
                              horizontalPadding: 0,
                              borderRadius: 10,
                              border: 0,
                              buttonColor: kGray,
                              child: Container(height: height * 0.2),
                            ),
                            Button(
                              onTap: () {},
                              width: width * 0.216,
                              verticalPadding: 0,
                              horizontalPadding: width * 0.004,
                              borderRadius: 10,
                              border: 0,
                              buttonColor: kGray,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.004),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'تقدمك الملحوظ',
                                          style: textStyle.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: width * 0.014,
                                              color: kWhite),
                                        ),
                                        Text(
                                          'اظهر المزيد',
                                          style: textStyle.copyWith(
                                              fontSize: width * 0.007,
                                              color: kPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.004),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'الرياضيات',
                                          style: textStyle.copyWith(
                                              fontSize: width * 0.014,
                                              color: kWhite),
                                        ),
                                        CircularChart(
                                          width: width * 0.03,
                                          label: profileCompletionPercentage,
                                          activeColor: kPurple,
                                          inActiveColor: kWhite,
                                          labelColor: kWhite,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.004),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'الفيزياء',
                                          style: textStyle.copyWith(
                                              fontSize: width * 0.014,
                                              color: kWhite),
                                        ),
                                        CircularChart(
                                          width: width * 0.03,
                                          label: profileCompletionPercentage,
                                          activeColor: kPurple,
                                          inActiveColor: kWhite,
                                          labelColor: kWhite,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.004),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'الأحياء',
                                          style: textStyle.copyWith(
                                              fontSize: width * 0.014,
                                              color: kWhite),
                                        ),
                                        CircularChart(
                                          width: width * 0.03,
                                          label: profileCompletionPercentage,
                                          activeColor: kPurple,
                                          inActiveColor: kWhite,
                                          labelColor: kWhite,
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * 0.004),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'اللغة الإنجليزية',
                                          style: textStyle.copyWith(
                                              fontSize: width * 0.014,
                                              color: kWhite),
                                        ),
                                        CircularChart(
                                          width: width * 0.03,
                                          label: profileCompletionPercentage,
                                          activeColor: kPurple,
                                          inActiveColor: kWhite,
                                          labelColor: kWhite,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.008),
                                  child: Button(
                                    onTap: () {},
                                    width: width * 0.1,
                                    verticalPadding: 0,
                                    horizontalPadding: width * 0.005,
                                    borderRadius: 10,
                                    border: 0,
                                    buttonColor: kGray,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'قــائـمـة\nالمتصدرين',
                                              style: textStyle.copyWith(
                                                  fontSize: width / 100,
                                                  color: kWhite),
                                            ),
                                            SizedBox(height: height / 80),
                                            Text(
                                              'أظهر المزيد',
                                              style: textStyle.copyWith(
                                                  fontSize: width / 150,
                                                  color: kPurple),
                                            ),
                                          ],
                                        ),
                                        Image(
                                          image: const AssetImage(
                                              'images/leaderboard_avatar.png'),
                                          fit: BoxFit.contain,
                                          alignment: Alignment.bottomCenter,
                                          height: height * 0.15,
                                          width: width * 0.04,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.008),
                                  child: Button(
                                    onTap: () {},
                                    width: width * 0.1,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    borderRadius: 10,
                                    border: 0,
                                    buttonColor: kGray,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'التحليلات\nوالتنبؤات',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 100,
                                                    color: kWhite),
                                              ),
                                              SizedBox(height: height / 80),
                                              Text(
                                                'أظهر المزيد',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 150,
                                                    color: kPurple),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image(
                                          image: const AssetImage(
                                              'images/analysis.png'),
                                          fit: BoxFit.contain,
                                          alignment: Alignment.centerLeft,
                                          height: height * 0.15,
                                          width: width * 0.04,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.008),
                                  child: Button(
                                    onTap: () {},
                                    width: width * 0.1,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    borderRadius: 10,
                                    border: 0,
                                    buttonColor: kGray,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'مجتمع\nالمدارس',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 100,
                                                    color: kWhite),
                                              ),
                                              SizedBox(height: height / 80),
                                              Text(
                                                'أظهر المزيد',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 150,
                                                    color: kPurple),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image(
                                          image: const AssetImage(
                                              'images/community.png'),
                                          alignment: Alignment.bottomLeft,
                                          fit: BoxFit.contain,
                                          height: height * 0.15,
                                          width: width * 0.04,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.008),
                                  child: Button(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, QuizSetting.route);
                                    },
                                    width: width * 0.1,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    borderRadius: 10,
                                    border: 0,
                                    buttonColor: kGray,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: width * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'الامتحانات\nوالتمارين',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 100,
                                                    color: kWhite),
                                              ),
                                              SizedBox(height: height / 80),
                                              Text(
                                                'أظهر المزيد',
                                                style: textStyle.copyWith(
                                                    fontSize: width / 150,
                                                    color: kPurple),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image(
                                          image: const AssetImage(
                                              'images/quiz_avatar.png'),
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                          height: height * 0.15,
                                          width: width * 0.04,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Button(
                                onTap: () {},
                                width: width * 0.35,
                                verticalPadding: height * 0.01,
                                horizontalPadding: 0,
                                borderRadius: 10,
                                border: 0,
                                buttonColor: kGray,
                                child: Container(height: height * 0.215)),
                            Button(
                                onTap: () {},
                                width: width * 0.35,
                                verticalPadding: height * 0.01,
                                horizontalPadding: 0,
                                borderRadius: 10,
                                border: 0,
                                buttonColor: kGray,
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                      items: advList
                                          .map(
                                            (item) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.01),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item['title'],
                                                        style:
                                                            textStyle.copyWith(
                                                          color: kWhite,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              width * 0.02,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height:
                                                              height * 0.01),
                                                      Text(
                                                        item['details'],
                                                        style:
                                                            textStyle.copyWith(
                                                          color: kWhite,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize:
                                                              width * 0.013,
                                                        ),
                                                      ),
                                                      Text(
                                                        'أظهر المزيد',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width / 130,
                                                                color: kPurple),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Image.asset(
                                                  item['image'],
                                                  fit: BoxFit.contain,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: height * 0.3,
                                                  width: width * 0.2,
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                      options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        viewportFraction: 1,
                                        autoPlay: true,
                                      ),
                                      carouselController: _controller,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children:
                                          advList.asMap().entries.map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controller
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: width / 55,
                                            height: height / 55,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _current == entry.key
                                                    ? kPurple
                                                    : kWhite),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )),
                            Button(
                                onTap: () {},
                                width: width * 0.35,
                                verticalPadding: height * 0.01,
                                horizontalPadding: 0,
                                borderRadius: 10,
                                border: 0,
                                buttonColor: kGray,
                                child: Container(height: height * 0.215)),
                          ],
                        ),
                        const SizedBox(),
                      ]),
                )))
        : Scaffold(
            backgroundColor: kGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}
