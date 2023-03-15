import 'package:flutter/material.dart';
import '../components/custom_divider.dart';
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

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool loaded = true;

  String userName = '';
  String quote = '';
  String todayDate = '00-00-0000';
  List advertisements = [];
  List tasks = [];

  double profileCompletionPercentage = 0;

  void getInfo() async {
    String? key0 = 'user@gmail.com'; //await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = '123'; //await getSession('sessionValue');
    post('dashboard/', {
      if (key0 != null) 'email': key0,
      if (key1 != null) 'phone': key1,
      'password': value,
    }).then((value) {
      dynamic result = decode(value);
      result == 0
          ? Navigator.pushNamed(context, Welcome.route)
          : setState(() {
              print(result);
              userName = result['user_name'];
              quote = result['quote'];
              todayDate = result['today_date'];
              advertisements = result['advertisements'];
              tasks = result['tasks'];
              loaded = true;
            });
    });
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    getInfo();
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
                color: kLightBlack,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.1,
                      width: width,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: kLightGray, width: 2))),
                      child: Row(
                        children: [
                          SizedBox(width: width * 0.005),
                          Image(
                            image: const AssetImage('images/logo.png'),
                            fit: BoxFit.contain,
                            width: width * 0.05,
                          ),
                          SizedBox(width: width * 0.0037),
                          CustomDivider(
                            dashHeight: 2,
                            dashWith: width * 0.005,
                            dashColor: kLightGray,
                            direction: Axis.vertical,
                            fillRate: 1,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: width * 0.06),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Button(
                                    onTap: () {},
                                    width: width * 0.4,
                                    height: height * 0.2,
                                    verticalPadding: height * 0.02,
                                    horizontalPadding: width * 0.02,
                                    borderRadius: width * 0.005,
                                    border: 0,
                                    buttonColor: kGray,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'أهلا $userName، صباح الخير',
                                              style: textStyle.copyWith(
                                                  fontSize: width * 0.015,
                                                  fontWeight: FontWeight.w600,
                                                  color: kWhite),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            Icon(
                                              Icons.sunny,
                                              color: Colors.amber,
                                              size: width * 0.025,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'حسابك مكتمل بنسبة',
                                              style: textStyle.copyWith(
                                                  fontSize: width * 0.01,
                                                  color: kWhite),
                                            ),
                                            SizedBox(width: width * 0.02),
                                            CircularChart(
                                              width: width * 0.028,
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
                                              fontSize: width * 0.007,
                                              color: kPurple),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Button(
                                        onTap: () {},
                                        width: width * 0.4,
                                        height: height * 0.08,
                                        verticalPadding: height * 0.02,
                                        horizontalPadding: width * 0.02,
                                        borderRadius: 1000,
                                        border: 0,
                                        buttonColor: Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Button(
                                              onTap: () {},
                                              height: height * 0.035,
                                              width: width * 0.06,
                                              verticalPadding: 0,
                                              horizontalPadding: 0,
                                              borderRadius: width * 0.01,
                                              border: 0,
                                              buttonColor: kPurple,
                                              child: Center(
                                                child: Text(
                                                  todayDate,
                                                  style: textStyle.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: width * 0.01,
                                                      color: kWhite),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kDarkYellow,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kDarkPink,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kPurple,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kLightGreen,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kPurple,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kDarkRed,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kPurple,
                                                  child: const SizedBox(),
                                                ),
                                                SizedBox(width: width * 0.008),
                                                Button(
                                                  onTap: () {},
                                                  width: height * 0.02,
                                                  height: height * 0.02,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: 1000,
                                                  border: 0,
                                                  buttonColor: kSkin,
                                                  child: const SizedBox(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Button(
                                        onTap: null,
                                        width: width * 0.4,
                                        height: height * 0.4,
                                        verticalPadding: height * 0.02,
                                        horizontalPadding: width * 0.02,
                                        borderRadius: width * 0.005,
                                        border: 0,
                                        buttonColor: kGray,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                'الجدول اليومي',
                                                style: textStyle.copyWith(
                                                    fontSize: width * 0.015,
                                                    fontWeight: FontWeight.w600,
                                                    color: kWhite),
                                              ),
                                            ),
                                            for (int i = 0;
                                                i < 5 && i < tasks.length;)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Button(
                                                    onTap: null,
                                                    height: height * 0.022,
                                                    width: width * 0.28,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.005,
                                                    border: 0,
                                                    buttonColor: kOffBlack,
                                                    child: Row(
                                                      children: [
                                                        Button(
                                                            onTap: null,
                                                            height:
                                                                height * 0.022,
                                                            width: width *
                                                                (tasks[i][
                                                                        'done'] /
                                                                    tasks[i][
                                                                        'task']),
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            borderRadius:
                                                                width * 0.005,
                                                            border: 0,
                                                            buttonColor: kSkin,
                                                            child:
                                                                const SizedBox()),
                                                        SizedBox(
                                                            width:
                                                                width * 0.005),
                                                        Text(
                                                          '${tasks[i]['done'] / tasks[i]['task']}%',
                                                          style: textStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.007,
                                                                  color:
                                                                      kBlack),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Button(
                                                    onTap: null,
                                                    height: height * 0.03,
                                                    width: width * 0.06,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    borderRadius: width * 0.01,
                                                    border: 0,
                                                    buttonColor: kWhite,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Button(
                                                          onTap: () {},
                                                          width: height * 0.03,
                                                          height: height * 0.03,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius: 1000,
                                                          border: 0,
                                                          buttonColor: kPurple,
                                                          child: Icon(
                                                            Icons.add,
                                                            size: width * 0.01,
                                                            color: kWhite,
                                                          ),
                                                        ),
                                                        Text(
                                                          '10',
                                                          style: textStyle
                                                              .copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.01,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kBlack),
                                                        ),
                                                        Button(
                                                          onTap: () {},
                                                          width: height * 0.03,
                                                          height: height * 0.03,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius: 1000,
                                                          border: 0,
                                                          buttonColor: kPurple,
                                                          child: Icon(
                                                            Icons.remove,
                                                            size: width * 0.01,
                                                            color: kWhite,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.022,
                                                  width: width * 0.28,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kOffBlack,
                                                  child: Row(
                                                    children: [
                                                      Button(
                                                          onTap: null,
                                                          height:
                                                              height * 0.022,
                                                          width: width * 0.18,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 0,
                                                          buttonColor:
                                                              kDarkPink,
                                                          child:
                                                              const SizedBox()),
                                                      SizedBox(
                                                          width: width * 0.005),
                                                      Text(
                                                        '25%',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.007,
                                                                color: kBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.03,
                                                  width: width * 0.06,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.01,
                                                  border: 0,
                                                  buttonColor: kWhite,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        '10',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: kBlack),
                                                      ),
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.022,
                                                  width: width * 0.28,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kOffBlack,
                                                  child: Row(
                                                    children: [
                                                      Button(
                                                          onTap: null,
                                                          height:
                                                              height * 0.022,
                                                          width: width * 0.23,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 0,
                                                          buttonColor:
                                                              kLightGreen,
                                                          child:
                                                              const SizedBox()),
                                                      SizedBox(
                                                          width: width * 0.005),
                                                      Text(
                                                        '25%',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.007,
                                                                color: kBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.03,
                                                  width: width * 0.06,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.01,
                                                  border: 0,
                                                  buttonColor: kWhite,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        '10',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: kBlack),
                                                      ),
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.022,
                                                  width: width * 0.28,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kOffBlack,
                                                  child: Row(
                                                    children: [
                                                      Button(
                                                          onTap: null,
                                                          height:
                                                              height * 0.022,
                                                          width: width * 0.12,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 0,
                                                          buttonColor: kDarkRed,
                                                          child:
                                                              const SizedBox()),
                                                      SizedBox(
                                                          width: width * 0.005),
                                                      Text(
                                                        '25%',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.007,
                                                                color: kBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.03,
                                                  width: width * 0.06,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.01,
                                                  border: 0,
                                                  buttonColor: kWhite,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        '10',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: kBlack),
                                                      ),
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.022,
                                                  width: width * 0.28,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kOffBlack,
                                                  child: Row(
                                                    children: [
                                                      Button(
                                                          onTap: null,
                                                          height:
                                                              height * 0.022,
                                                          width: width * 0.1,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 0,
                                                          buttonColor:
                                                              kDarkYellow,
                                                          child:
                                                              const SizedBox()),
                                                      SizedBox(
                                                          width: width * 0.005),
                                                      Text(
                                                        '25%',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.007,
                                                                color: kBlack),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Button(
                                                  onTap: null,
                                                  height: height * 0.03,
                                                  width: width * 0.06,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.01,
                                                  border: 0,
                                                  buttonColor: kWhite,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.add,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        '10',
                                                        style:
                                                            textStyle.copyWith(
                                                                fontSize:
                                                                    width *
                                                                        0.01,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: kBlack),
                                                      ),
                                                      Button(
                                                        onTap: () {},
                                                        width: height * 0.03,
                                                        height: height * 0.03,
                                                        verticalPadding: 0,
                                                        horizontalPadding: 0,
                                                        borderRadius: 1000,
                                                        border: 0,
                                                        buttonColor: kPurple,
                                                        child: Icon(
                                                          Icons.remove,
                                                          size: width * 0.01,
                                                          color: kWhite,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(),
                                            Row(
                                              children: [
                                                Text(
                                                  'لقد أنجزت مهامك بنسبة:',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kWhite),
                                                ),
                                                SizedBox(width: width * 0.01),
                                                CircularChart(
                                                  width: width * 0.028,
                                                  label:
                                                      profileCompletionPercentage,
                                                  activeColor: kPurple,
                                                  inActiveColor: kWhite,
                                                  labelColor: kWhite,
                                                ),
                                                SizedBox(width: width * 0.03),
                                                Text(
                                                  'معدل إنجازك الاسبوعي:',
                                                  style: textStyle.copyWith(
                                                      fontSize: width * 0.01,
                                                      color: kWhite),
                                                ),
                                                SizedBox(width: width * 0.01),
                                                CircularChart(
                                                  width: width * 0.028,
                                                  label:
                                                      profileCompletionPercentage,
                                                  activeColor: kPurple,
                                                  inActiveColor: kWhite,
                                                  labelColor: kWhite,
                                                )
                                              ],
                                            ),
                                            const SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: height * 0.05),
                                    child: Button(
                                      onTap: () {},
                                      width: width * 0.33,
                                      height: height * 0.3,
                                      verticalPadding: height * 0.02,
                                      horizontalPadding: width * 0.02,
                                      borderRadius: width * 0.005,
                                      border: 0,
                                      buttonColor: kGray,
                                      child: const SizedBox(),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.05),
                                    child: Button(
                                      onTap: null,
                                      width: width * 0.33,
                                      height: height * 0.46,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      border: 0,
                                      buttonColor: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Button(
                                            onTap: null,
                                            width: width * 0.1,
                                            height: height * 0.46,
                                            verticalPadding: 0,
                                            horizontalPadding: 0,
                                            borderRadius: width * 0.005,
                                            border: 0,
                                            buttonColor: kGray,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'أكمل...',
                                                      style: textStyle.copyWith(
                                                          fontSize:
                                                              width * 0.012,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kWhite),
                                                    ),
                                                    Icon(
                                                      Icons.turn_left_rounded,
                                                      size: width * 0.03,
                                                      color: kPurple,
                                                    ),
                                                  ],
                                                ),
                                                Image(
                                                  image: AssetImage(
                                                      'images/question_examplea.png'),
                                                  width: width * 0.08,
                                                  height: height * 0.35,
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox()
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Button(
                                                  onTap: null,
                                                  width: width * 0.1,
                                                  height: height * 0.05,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kGray,
                                                  child: Center(
                                                    child: Text(
                                                      'الأفضل',
                                                      style: textStyle.copyWith(
                                                          fontSize:
                                                              width * 0.012,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kWhite),
                                                    ),
                                                  )),
                                              Button(
                                                onTap: null,
                                                width: width * 0.1,
                                                height: height * 0.4,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                border: 0,
                                                buttonColor: kGray,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/question_answer_imoji.png'),
                                                          width: width * 0.04,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        Button(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 4,
                                                          borderColor: kPurple,
                                                          buttonColor:
                                                              kDarkGreen,
                                                          child: Center(
                                                            child: Text(
                                                              '30',
                                                              style: textStyle.copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.013,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kWhite),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/man_mark_imoji.png'),
                                                          width: width * 0.04,
                                                          height: height * 0.06,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        Button(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 4,
                                                          borderColor: kPurple,
                                                          buttonColor:
                                                              kDarkGreen,
                                                          child: Center(
                                                            child: Text(
                                                              '10',
                                                              style: textStyle.copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.013,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kWhite),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          height: height * 0.2,
                                                          width: width * 0.08,
                                                        ),
                                                        Positioned(
                                                          top: height * 0.025,
                                                          left: 0,
                                                          right: 0,
                                                          child: Button(
                                                              onTap: null,
                                                              width:
                                                                  width * 0.08,
                                                              height:
                                                                  height * 0.16,
                                                              verticalPadding:
                                                                  height * 0.02,
                                                              horizontalPadding:
                                                                  width * 0.01,
                                                              borderRadius:
                                                                  width * 0.01,
                                                              border: 4,
                                                              borderColor:
                                                                  kWhite,
                                                              buttonColor: Colors
                                                                  .transparent,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'تفاضل',
                                                                    style: textStyle.copyWith(
                                                                        fontSize:
                                                                            width *
                                                                                0.008,
                                                                        color:
                                                                            kWhite),
                                                                  ),
                                                                  Text(
                                                                    'النهايات',
                                                                    style: textStyle.copyWith(
                                                                        fontSize:
                                                                            width *
                                                                                0.008,
                                                                        color:
                                                                            kWhite),
                                                                  ),
                                                                  Text(
                                                                    'الإشتقاق',
                                                                    style: textStyle.copyWith(
                                                                        fontSize:
                                                                            width *
                                                                                0.008,
                                                                        color:
                                                                            kWhite),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                        Button(
                                                            onTap: null,
                                                            width:
                                                                width * 0.049,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            borderRadius:
                                                                width * 0.005,
                                                            border: 0,
                                                            buttonColor: kGray,
                                                            child: Center(
                                                              child: Text(
                                                                'الرياضيات',
                                                                style: textStyle.copyWith(
                                                                    fontSize:
                                                                        width *
                                                                            0.012,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        kWhite),
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Button(
                                                  onTap: null,
                                                  width: width * 0.1,
                                                  height: height * 0.05,
                                                  verticalPadding: 0,
                                                  horizontalPadding: 0,
                                                  borderRadius: width * 0.005,
                                                  border: 0,
                                                  buttonColor: kGray,
                                                  child: Center(
                                                    child: Text(
                                                      'الأسوأ',
                                                      style: textStyle.copyWith(
                                                          fontSize:
                                                              width * 0.012,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kWhite),
                                                    ),
                                                  )),
                                              Button(
                                                onTap: null,
                                                width: width * 0.1,
                                                height: height * 0.4,
                                                verticalPadding: height * 0.02,
                                                horizontalPadding: 0,
                                                borderRadius: width * 0.005,
                                                border: 0,
                                                buttonColor: kGray,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/question_answer_imoji.png'),
                                                          width: width * 0.04,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        Button(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 4,
                                                          borderColor: kPurple,
                                                          buttonColor: kDarkRed,
                                                          child: Center(
                                                            child: Text(
                                                              '5',
                                                              style: textStyle.copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.013,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kWhite),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image(
                                                          image: AssetImage(
                                                              'images/man_mark_imoji.png'),
                                                          width: width * 0.04,
                                                          height: height * 0.06,
                                                          fit: BoxFit.contain,
                                                        ),
                                                        Button(
                                                          onTap: null,
                                                          width: width * 0.035,
                                                          height: height * 0.05,
                                                          verticalPadding: 0,
                                                          horizontalPadding: 0,
                                                          borderRadius:
                                                              width * 0.005,
                                                          border: 4,
                                                          borderColor: kPurple,
                                                          buttonColor: kDarkRed,
                                                          child: Center(
                                                            child: Text(
                                                              '1',
                                                              style: textStyle.copyWith(
                                                                  fontSize:
                                                                      width *
                                                                          0.013,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kWhite),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          height: height * 0.2,
                                                          width: width * 0.08,
                                                        ),
                                                        Positioned(
                                                          top: height * 0.025,
                                                          left: 0,
                                                          right: 0,
                                                          child: Button(
                                                              onTap: null,
                                                              width:
                                                                  width * 0.08,
                                                              height:
                                                                  height * 0.16,
                                                              verticalPadding:
                                                                  height * 0.02,
                                                              horizontalPadding:
                                                                  width * 0.01,
                                                              borderRadius:
                                                                  width * 0.01,
                                                              border: 4,
                                                              borderColor:
                                                                  kWhite,
                                                              buttonColor: Colors
                                                                  .transparent,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    'المبتدأ',
                                                                    style: textStyle.copyWith(
                                                                        fontSize:
                                                                            width *
                                                                                0.008,
                                                                        color:
                                                                            kWhite),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                        Button(
                                                            onTap: null,
                                                            width:
                                                                width * 0.049,
                                                            verticalPadding: 0,
                                                            horizontalPadding:
                                                                0,
                                                            borderRadius:
                                                                width * 0.005,
                                                            border: 0,
                                                            buttonColor: kGray,
                                                            child: Center(
                                                              child: Text(
                                                                'عربي',
                                                                style: textStyle.copyWith(
                                                                    fontSize:
                                                                        width *
                                                                            0.012,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        kWhite),
                                                              ),
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Button(
                                      onTap: null,
                                      width: width * 0.1,
                                      height: height * 0.8,
                                      verticalPadding: 0,
                                      horizontalPadding: 0,
                                      borderRadius: width * 0.005,
                                      border: 3,
                                      borderColor: kWhite,
                                      buttonColor: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              //     Row(
                              //       children: [
                              //     Button(
                              //         onTap: () {},
                              //         width: width * 0.35,
                              //         verticalPadding: height * 0.01,
                              //         horizontalPadding: 0,
                              //         borderRadius: 10,
                              //         border: 0,
                              //         buttonColor: kGray,
                              //         child: Column(
                              //           children: [
                              //             CarouselSlider(
                              //               items: advList
                              //                   .map(
                              //                     (item) => Row(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment.spaceBetween,
                              //                       children: [
                              //                         Padding(
                              //                           padding: EdgeInsets.symmetric(
                              //                               horizontal: width * 0.01),
                              //                           child: Column(
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment.center,
                              //                             crossAxisAlignment:
                              //                                 CrossAxisAlignment.start,
                              //                             children: [
                              //                               Text(
                              //                                 item['title'],
                              //                                 style: textStyle.copyWith(
                              //                                   color: kWhite,
                              //                                   fontWeight:
                              //                                       FontWeight.w600,
                              //                                   fontSize: width * 0.02,
                              //                                 ),
                              //                               ),
                              //                               SizedBox(
                              //                                   height: height * 0.01),
                              //                               Text(
                              //                                 item['details'],
                              //                                 style: textStyle.copyWith(
                              //                                   color: kWhite,
                              //                                   fontWeight:
                              //                                       FontWeight.w400,
                              //                                   fontSize: width * 0.013,
                              //                                 ),
                              //                               ),
                              //                               Text(
                              //                                 'أظهر المزيد',
                              //                                 style: textStyle.copyWith(
                              //                                     fontSize: width / 130,
                              //                                     color: kPurple),
                              //                               ),
                              //                             ],
                              //                           ),
                              //                         ),
                              //                         Image.asset(
                              //                           item['image'],
                              //                           fit: BoxFit.contain,
                              //                           alignment: Alignment.centerLeft,
                              //                           height: height * 0.3,
                              //                           width: width * 0.2,
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   )
                              //                   .toList(),
                              //               options: CarouselOptions(
                              //                 onPageChanged: (index, reason) {
                              //                   setState(() {
                              //                     _current = index;
                              //                   });
                              //                 },
                              //                 viewportFraction: 1,
                              //                 autoPlay: true,
                              //               ),
                              //               carouselController: _controller,
                              //             ),
                              //             Row(
                              //               mainAxisAlignment: MainAxisAlignment.center,
                              //               children:
                              //                   advList.asMap().entries.map((entry) {
                              //                 return GestureDetector(
                              //                   onTap: () => _controller
                              //                       .animateToPage(entry.key),
                              //                   child: Container(
                              //                     width: width / 55,
                              //                     height: height / 55,
                              //                     decoration: BoxDecoration(
                              //                         shape: BoxShape.circle,
                              //                         color: _current == entry.key
                              //                             ? kPurple
                              //                             : kWhite),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //             ),
                              //           ],
                              //         )),
                              //     Button(
                              //         onTap: () {},
                              //         width: width * 0.35,
                              //         verticalPadding: height * 0.01,
                              //         horizontalPadding: 0,
                              //         borderRadius: 10,
                              //         border: 0,
                              //         buttonColor: kGray,
                              //         child: Container(height: height * 0.215)),
                              //   ],
                              // ),
                            ]),
                        Row(
                          children: [
                            SizedBox(width: width * 0.41),
                            Column(
                              children: [
                                SizedBox(height: height * 0.03),
                                Image(
                                  image:
                                      const AssetImage('images/quotation.png'),
                                  width: width * 0.2,
                                  height: height * 0.3,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ],
                        ),
                        MouseRegion(
                          onHover: (isHover) {
                            setState(() {
                              forwardAnimationController!.reverse();
                              forwardAnimationCurve!
                                  .addListener(() => setState(() {
                                        forwardAnimationValue =
                                            forwardAnimationCurve!.value;
                                      }));

                              backwardAnimationController!.forward();
                              backwardAnimationCurve!
                                  .addListener(() => setState(() {
                                        backwardAnimationValue =
                                            backwardAnimationCurve!.value;
                                      }));
                            });
                          },
                          onExit: (e) {
                            setState(() {
                              forwardAnimationController!.forward();
                              forwardAnimationCurve!
                                  .addListener(() => setState(() {
                                        forwardAnimationValue =
                                            forwardAnimationCurve!.value;
                                      }));

                              backwardAnimationController!.reverse();
                              backwardAnimationCurve!
                                  .addListener(() => setState(() {
                                        backwardAnimationValue =
                                            backwardAnimationCurve!.value;
                                      }));
                            });
                          },
                          child: Container(
                              height: height * 0.9,
                              width: width *
                                  (0.06 * forwardAnimationValue +
                                      0.2 * backwardAnimationValue),
                              decoration: BoxDecoration(
                                  color: kLightBlack.withOpacity(0.95),
                                  border: Border(
                                      left: BorderSide(
                                          color: kLightGray, width: 2))),
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: height * 0.01,
                                        horizontal: width * 0.01),
                                    child: Button(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                        Navigator.pushNamed(
                                            context, Dashboard.route);
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
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
                                          if (backwardAnimationValue != 1)
                                            SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                )),
          ))
        : Scaffold(
            backgroundColor: kLightGray,
            body: Center(
                child: CircularProgressIndicator(
                    color: kPurple, strokeWidth: width * 0.05)));
  }
}

// Padding(
//   padding:
//   EdgeInsets.symmetric(vertical: height / 40),
//   child: IconButton(
//     onPressed: () {
//       popUp(context, width * 0.3,
//           'هل حقاً تريد تسجيل الخروج', [
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Button(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   width: width * 0.13,
//                   verticalPadding: 8,
//                   horizontalPadding: 0,
//                   borderRadius: 8,
//                   buttonColor: kBlack,
//                   border: 0,
//                   child: Center(
//                     child: Text(
//                       'لا',
//                       style: textStyle,
//                     ),
//                   ),
//                 ),
//                 Button(
//                   onTap: () {
//                     delSession('sessionKey0');
//                     delSession('sessionKey1');
//                     delSession('sessionValue').then(
//                             (value) =>
//                             Navigator.pushNamed(
//                                 context,
//                                 Welcome.route));
//                   },
//                   width: width * 0.13,
//                   verticalPadding: 8,
//                   horizontalPadding: 0,
//                   borderRadius: 8,
//                   buttonColor: kOffWhite,
//                   border: 0,
//                   child: Center(
//                     child: Text(
//                       'نعم',
//                       style: textStyle.copyWith(
//                           color: kBlack),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ]);
//     }, //home dashboard
//     icon: Icon(
//       Icons.logout_rounded,
//       size: width * 0.02,
//       color: kWhite,
//     ),
//   ),
// ),
