import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/const/sarmadi_icons_icons.dart';
import 'package:sarmadi/providers/user_info_provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import '../components/custom_container.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/website_provider.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  void checkSession() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    if ((key0 != null || key1 != null) && (value != null)) {
      delSession('sessionKey0');
      delSession('sessionKey1');
      delSession('sessionValue');
      UserInfoProvider userInfoProvider = UserInfoProvider();
      await post('log_in/', {
        if (key0 != null) 'email': key0,
        if (key1 != null) 'phone': key1,
        'password': value,
      }).then((result) {
        dynamic authenticated = decode(result);
        if (authenticated == 0) {
          if (key0 != null) userInfoProvider.setUserEmail(key0);
          if (key1 != null) userInfoProvider.setUserPhone(key1);
          userInfoProvider.setUserPassword(value);
          context.pushReplacement('/QuizSetting');
        }
      });
    }
  }

  PageController horizontalPageController = PageController(initialPage: 10002);
  ScrollController verticalPageController = ScrollController();

  Timer? timer;
  int currentPageIndex = 0;

  AnimationController? _animationController;
  Animation<double>? _animation;

  bool hideArrow = false;

  @override
  void dispose() {
    horizontalPageController.dispose();
    _animationController!.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkSession();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 25.0,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (horizontalPageController.hasClients) {
        horizontalPageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }

      Timer(const Duration(seconds: 1), () {
        setState(() {
          hideArrow = true;
        });
      });
      Timer(const Duration(seconds: 3), () {
        setState(() {
          hideArrow = false;
        });
      });
    });
  }

  Widget swipeUpArrow(width) {
    return Visibility(
      visible: hideArrow,
      replacement: SizedBox(
        height: width * 0.05,
        width: width,
      ),
      child: AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _animation!.value),
            child: child,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.arrow_downward_rounded,
            //   size: width * 0.05,
            //   color: kPurple,
            // ),
            Icon(
              Icons.arrow_downward_rounded,
              size: width * 0.05,
              color: kPurple,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return width < height
        ? const RotateYourPhone()
        : Scaffold(
            body: Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: width,
              height: height * 3.51,
              child: ListView(
                controller: verticalPageController,
                children: [
                  Container(
                    height: height * 2.83,
                    width: width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/welcome_full_bg.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: width,
                          height: height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: width * 0.05,
                                      height: height * 0.05),
                                  CustomContainer(
                                    onTap: () {
                                      context.pushReplacement('/LogIn');
                                    },
                                    width: width * 0.1,
                                    height: height * 0.05,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    buttonColor: kTransparent,
                                    border: fullBorder(kWhite, 1),
                                    borderRadius: width * 0.005,
                                    child: Text('ابدأ',
                                        style: textStyle(
                                            3, width, height, kWhite)),
                                  ),
                                  CustomContainer(
                                    onTap: () {
                                      verticalPageController.animateTo(height,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut);
                                    },
                                    width: width * 0.1,
                                    height: height * 0.05,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    buttonColor: kTransparent,
                                    border: null,
                                    borderRadius: width * 0.005,
                                    child: Text('من نحن',
                                        style: textStyle(
                                            3, width, height, kWhite)),
                                  ),
                                  CustomContainer(
                                    onTap: () {
                                      verticalPageController.animateTo(
                                          verticalPageController
                                              .positions.last.maxScrollExtent,
                                          duration: const Duration(seconds: 2),
                                          curve: Curves.easeInOut);
                                    },
                                    width: width * 0.1,
                                    height: height * 0.05,
                                    verticalPadding: 0,
                                    horizontalPadding: 0,
                                    buttonColor: kTransparent,
                                    border: null,
                                    borderRadius: width * 0.005,
                                    child: Text('تواصل معنا',
                                        style: textStyle(
                                            3, width, height, kWhite)),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [], //TODO: add the logo
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                            width: width,
                            height: height * 0.9,
                            child: PageView.builder(
                              controller: horizontalPageController,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final item = [
                                  SizedBox(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'آخـــــــــــر تقنيـــــــــــات الذكاء الاصطناعـــــــــــي !',
                                                  style: textStyle(0, width,
                                                      height, kWhite)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.01),
                                                child: Image(
                                                  image: const AssetImage(
                                                    'images/latest_ai_tech.png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: width * 0.3,
                                                  height: height * 0.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'استخدام تقنيات الذكاء الاصطناعي واقتراح اسئلة وامتحانات شبيهة تحديد الوقت المثالي\nلتدريبك على سرعة الحل ودقة الأداء',
                                                      style: textStyle(2, width,
                                                          height, kWhite)),
                                                  Text(
                                                      'سجل دخولك الآن وتمتع بتجربة سلسة وثرية، لتكون من على جاهزية تامة لامتحاناتك في\nالثانوية العامة !',
                                                      style: textStyle(3, width,
                                                          height, kWhite, 5)),
                                                ],
                                              ),
                                              const SizedBox(),
                                              Column(
                                                children: [
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/SignUp');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kPurple,
                                                    border: null,
                                                    borderRadius: width * 0.005,
                                                    child: Text(
                                                        'أنشئ حساب جديد',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/LogIn');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kTransparent,
                                                    border:
                                                        fullBorder(kPurple, 1),
                                                    borderRadius: width * 0.005,
                                                    child: Text('سجل دخولك',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kPurple)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        swipeUpArrow(width)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'مصــــــــــــــادر أسئلــــــــــــــة متنوعــــــــــــــة !',
                                                  style: textStyle(0, width,
                                                      height, kWhite)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.01),
                                                child: Image(
                                                  image: const AssetImage(
                                                    'images/various_question_sources.png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: width * 0.3,
                                                  height: height * 0.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'بنك اسئلة تغطي المادة من مصادر متنوعة سواء من الكتاب، الوزارة، اساتذة\nواستاذات في كل موادك الدراسية',
                                                      style: textStyle(2, width,
                                                          height, kWhite)),
                                                  Text(
                                                      'سجل دخولك الآن وتمتع بتجربة سلسة وثرية، لتكون من على جاهزية تامة لامتحاناتك في\nالثانوية العامة !',
                                                      style: textStyle(3, width,
                                                          height, kWhite, 5)),
                                                ],
                                              ),
                                              const SizedBox(),
                                              Column(
                                                children: [
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/SignUp');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kPurple,
                                                    border: null,
                                                    borderRadius: width * 0.005,
                                                    child: Text(
                                                        'أنشئ حساب جديد',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/LogIn');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kTransparent,
                                                    border:
                                                        fullBorder(kPurple, 1),
                                                    borderRadius: width * 0.005,
                                                    child: Text('سجل دخولك',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kPurple)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        swipeUpArrow(width)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'خــــــــــــــــــــــــلّـــي الــــدراســــــــــــــــــــــة',
                                                  style: textStyle(0, width,
                                                      height, kWhite)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.01),
                                                child: Image(
                                                  image: const AssetImage(
                                                    'images/study_is_your_game.png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: width * 0.3,
                                                  height: height * 0.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'كوكب عالمك المتكامل لكل ما تحتاجه حتى تخلي الدراسة لعبتك !',
                                                      style: textStyle(2, width,
                                                          height, kWhite)),
                                                  Text(
                                                      'سجل دخولك الآن وتمتع بتجربة سلسة وثرية، لتكون من على جاهزية تامة لامتحاناتك في\nالثانوية العامة !',
                                                      style: textStyle(3, width,
                                                          height, kWhite, 5)),
                                                ],
                                              ),
                                              const SizedBox(),
                                              Column(
                                                children: [
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/SignUp');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kPurple,
                                                    border: null,
                                                    borderRadius: width * 0.005,
                                                    child: Text(
                                                        'أنشئ حساب جديد',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/LogIn');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kTransparent,
                                                    border:
                                                        fullBorder(kPurple, 1),
                                                    borderRadius: width * 0.005,
                                                    child: Text('سجل دخولك',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kPurple)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        swipeUpArrow(width)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'حــــــــــدّد نقــــــــــاط ضــــــــــعفك !',
                                                  style: textStyle(0, width,
                                                      height, kWhite)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.01),
                                                child: Image(
                                                  image: const AssetImage(
                                                    'images/your_weakness_point.png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: width * 0.3,
                                                  height: height * 0.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'امتحانات تصممها انت تختبر أي جزء في المادة وحدة، درس، مهارة حسب\nاختيارك.',
                                                      style: textStyle(2, width,
                                                          height, kWhite)),
                                                  Text(
                                                      'سجل دخولك الآن وتمتع بتجربة سلسة وثرية، لتكون من على جاهزية تامة لامتحاناتك في\nالثانوية العامة !',
                                                      style: textStyle(3, width,
                                                          height, kWhite, 5)),
                                                ],
                                              ),
                                              const SizedBox(),
                                              Column(
                                                children: [
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/SignUp');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kPurple,
                                                    border: null,
                                                    borderRadius: width * 0.005,
                                                    child: Text(
                                                        'أنشئ حساب جديد',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/LogIn');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kTransparent,
                                                    border:
                                                        fullBorder(kPurple, 1),
                                                    borderRadius: width * 0.005,
                                                    child: Text('سجل دخولك',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kPurple)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        swipeUpArrow(width)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.9,
                                    width: width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  'مـــــــــــــراقبـــــة أداءك !',
                                                  style: textStyle(0, width,
                                                      height, kWhite)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.01),
                                                child: Image(
                                                  image: const AssetImage(
                                                    'images/monitor_your_performance.png',
                                                  ),
                                                  fit: BoxFit.contain,
                                                  width: width * 0.3,
                                                  height: height * 0.5,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: width,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'نتيجة فورية وتحليل مفصل لأدائك في كل امتحان لتحسين مهاراتك خطوة\nخطوة',
                                                      style: textStyle(2, width,
                                                          height, kWhite)),
                                                  Text(
                                                      'سجل دخولك الآن وتمتع بتجربة سلسة وثرية، لتكون من على جاهزية تامة لامتحاناتك في\nالثانوية العامة !',
                                                      style: textStyle(3, width,
                                                          height, kWhite, 5)),
                                                ],
                                              ),
                                              const SizedBox(),
                                              Column(
                                                children: [
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/SignUp');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kPurple,
                                                    border: null,
                                                    borderRadius: width * 0.005,
                                                    child: Text(
                                                        'أنشئ حساب جديد',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kWhite)),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.02,
                                                  ),
                                                  CustomContainer(
                                                    onTap: () {
                                                      context.pushReplacement(
                                                          '/LogIn');
                                                    },
                                                    width: width * 0.18,
                                                    height: height * 0.08,
                                                    verticalPadding: 0,
                                                    horizontalPadding: 0,
                                                    buttonColor: kTransparent,
                                                    border:
                                                        fullBorder(kPurple, 1),
                                                    borderRadius: width * 0.005,
                                                    child: Text('سجل دخولك',
                                                        style: textStyle(
                                                            3,
                                                            width,
                                                            height,
                                                            kPurple)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(),
                                              const SizedBox(),
                                            ],
                                          ),
                                        ),
                                        swipeUpArrow(width)
                                      ],
                                    ),
                                  ),
                                ][index % 5];
                                return item;
                              },
                            )),
                        SizedBox(
                          width: width,
                          height: height * 0.6,
                          child: Padding(
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'من نحن ؟',
                                  style: textStyle(6, width, height, kWhite, 2),
                                ),
                                Text(
                                    'منصة مختصة بجانب اثراء دراسة الطالب بأساليب التكنلوجيا المعاصرة من\nخلال تدريبه وتهيئته لامتحانات الثانوية العامة طوال مدة دراسته وفي جميع\nالمواد',
                                    style: textStyle(2, width, height, kWhite)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: height * 0.6,
                          child: Padding(
                            padding: EdgeInsets.only(right: width * 0.4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ليش تختار منصتنا ؟',
                                  style: textStyle(6, width, height, kWhite, 2),
                                ),
                                Text(
                                    'نوفر لك كل ما تحتاجه حتى تختبر نفسك بجميع موادك الدراسية لتكون جاهز\nلامتحانات الثانوية العامة',
                                    style: textStyle(2, width, height, kWhite)),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: height * 0.6,
                          child: Padding(
                            padding: EdgeInsets.only(right: width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الأسئلة منوعة وشاملة',
                                  style:
                                      textStyle(1, width, height, kLightBlack),
                                ),
                                Text(
                                    'عنا بتقدر تصمم امتحانك الخاص بك حسب المادة، الوحدة، الدرس أو حتى\nمهارات معينه لتكتشف نقاط الضعف عندك وتقويها',
                                    style: textStyle(
                                        2, width, height, kLightBlack)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 0.6,
                    decoration: BoxDecoration(
                      color: kDarkBlack,
                      image: const DecorationImage(
                        image: AssetImage("images/planet_2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                            image: const AssetImage(
                                'images/following_up_your_analyses.png'),
                            fit: BoxFit.contain,
                            width: width * 0.3,
                            height: height * 0.45,
                            alignment: Alignment.center),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'متابعة وتحليل النتائج',
                              style: textStyle(1, width, height, kWhite),
                            ),
                            Text(
                                'نتيجة فورية وتحليل مفصل لأدائك في كل امتحان تمكنك من متابعة أداءك\nوتطورك الدراسي بشكل دائم!',
                                style: textStyle(2, width, height, kWhite)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 0.08,
                    color: kPurple,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CustomContainer(
                              width: width * 0.03,
                              height: height * 0.05,
                              borderRadius: width * 0.005,
                              buttonColor: kLightBlack.withOpacity(0.6),
                              child: Icon(
                                SarmadiIcons.call,
                                size: width * 0.02,
                                color: kWhite,
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              '+962 7 9937 8997',
                              textDirection: TextDirection.ltr,
                              style: textStyle(3, width, height, kWhite),
                            ),
                          ],
                        ),
                        CustomContainer(
                          onTap: () {
                            html.window.open(
                                'https://www.facebook.com/profile.php?id=100093615428668',
                                "_blank");
                          },
                          child: Row(
                            children: [
                              CustomContainer(
                                width: width * 0.03,
                                height: height * 0.05,
                                borderRadius: width * 0.005,
                                buttonColor: kLightBlack.withOpacity(0.6),
                                child: Icon(
                                  SarmadiIcons.facebookOutline,
                                  size: width * 0.02,
                                  color: kWhite,
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                'مش ضايل وقت',
                                textDirection: TextDirection.ltr,
                                style: textStyle(3, width, height, kWhite),
                              ),
                            ],
                          ),
                        ),
                        CustomContainer(
                          onTap: () {
                            html.window
                                .open('https://wa.me/+962799378997', "_blank");
                          },
                          child: Row(
                            children: [
                              CustomContainer(
                                width: width * 0.03,
                                height: height * 0.05,
                                borderRadius: width * 0.005,
                                buttonColor: kLightBlack.withOpacity(0.6),
                                child: Icon(
                                  SarmadiIcons.whatsUp,
                                  size: width * 0.02,
                                  color: kWhite,
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                '+962 7 9937 8997',
                                textDirection: TextDirection.ltr,
                                style: textStyle(3, width, height, kWhite),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            CustomContainer(
                              width: width * 0.03,
                              height: height * 0.05,
                              borderRadius: width * 0.005,
                              buttonColor: kLightBlack.withOpacity(0.6),
                              child: Center(
                                child: Icon(
                                  SarmadiIcons.email,
                                  size: width * 0.015,
                                  color: kWhite,
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              'sarmadi.tech.ai@gmail.com',
                              textDirection: TextDirection.ltr,
                              style: textStyle(3, width, height, kWhite),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}
