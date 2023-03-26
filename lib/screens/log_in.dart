import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/const/borders.dart';
import 'package:sarmadi/const/colors.dart';
import '../const/fonts.dart';
import '../providers/user_info_provider.dart';
import 'sign_up.dart';
import '../components/custom_container.dart';
import '../components/custom_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../utils/session.dart';
import '../utils/hashCode.dart';
import '../utils/http_requests.dart';

import 'dashboard.dart';

class LogIn extends StatefulWidget {
  static const String route = '/LogIn/';

  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final CarouselController controller = CarouselController();

  // TextEditingController email = TextEditingController();
  //
  // TextEditingController phone = TextEditingController();
  //
  // TextEditingController password = TextEditingController();

  bool obscurePassword = true;

  int current = 0;
  int loginMethod = 0; // 0 email 1 phone

  void logIn(password, [email, phone]) {
    email == ''
        ? post('log_in/', {
            'phone': phone,
            'password': password,
          }).then((value) {
            dynamic result = decode(value);
            switch (result) {
              case 0:
                //TODO:
                Provider.of<UserInfoProvider>(context, listen: false)
                    .setUserPhone(phone);
                Provider.of<UserInfoProvider>(context, listen: false)
                    .setUserPassword(password);
                Navigator.pushNamed(context, Dashboard.route);
                break;
              case 1:
                print('phone or password are wrong');
                break;
              case 404:
                print('check your connection');
                break;
              default:
                print('sth goes wrong, try later');
                break;
            }
          })
        : post('log_in/', {
            'email': email,
            'password': password,
          }).then((value) {
            dynamic result = decode(value);
            switch (result) {
              case 0:
                //TODO:
                Provider.of<UserInfoProvider>(context, listen: false)
                    .setUserEmail(email);
                Provider.of<UserInfoProvider>(context, listen: false)
                    .setUserPassword(password);
                Navigator.pushNamed(context, Dashboard.route);

                break;
              case 1:
                print('email or password are wrong');
                break;
              case 404:
                print('check your connection');
                break;
              default:
                print('sth goes wrong, try later');
                break;
            }
          });
  }

  void checkSession() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    if ((key0 != null || key1 != null) && (value != null)) {
      Navigator.pushNamed(context, Dashboard.route);
    }
  }

  @override
  void initState() {
    // checkSession();
    print(3);
    // delSession('sessionKey0');
    // delSession('sessionKey1');
    // delSession('sessionValue');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // checkSession();
    print(2);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/signup_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height / 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Text(
                            'تسجيل الدخول',
                            style: textStyle(3, width, height, kLightPurple),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: height / 32, right: 12),
                          child: Text(
                            'أهـلا فيـك مرة تانية!',
                            style: textStyle(2, width, height, kWhite),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height / 32, bottom: height / 32),
                          child: Row(
                            children: [
                              CustomContainer(
                                onTap: () {
                                  setState(() {
                                    phone.text = '';
                                    password.text = '';
                                    loginMethod = 0;
                                  });
                                },
                                width: width / 4.84,
                                verticalPadding: height * 0.01,
                                buttonColor: kTransparent,
                                horizontalPadding: 0,
                                borderRadius: null,
                                border: singleBottomBorder(loginMethod == 0
                                    ? kLightPurple
                                    : kDarkGray),
                                child: Center(
                                  child: Text(
                                    'البريد الإلكتروني',
                                    style: textStyle(
                                        3,
                                        width,
                                        height,
                                        loginMethod == 0
                                            ? kLightPurple
                                            : kDarkGray),
                                  ),
                                ),
                              ),
                              CustomContainer(
                                onTap: () {
                                  setState(() {
                                    email.text = '';
                                    password.text = '';
                                    loginMethod = 1;
                                  });
                                },
                                width: width / 4.84,
                                verticalPadding: height * 0.01,
                                horizontalPadding: 0,
                                buttonColor: kTransparent,
                                borderRadius: null,
                                border: singleBottomBorder(loginMethod == 1
                                    ? kLightPurple
                                    : kDarkGray),
                                child: Center(
                                  child: Text(
                                    'رقم الهاتف',
                                    style: textStyle(
                                        3,
                                        width,
                                        height,
                                        loginMethod == 1
                                            ? kLightPurple
                                            : kDarkGray),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 64),
                          child: CustomTextField(
                            controller: loginMethod == 0 ? email : phone,
                            width: width / 2.42,
                            fontOption: 3,
                            fontColor: kWhite,
                            textAlign: null,
                            obscure: false,
                            readOnly: false,
                            focusNode: null,
                            maxLines: null,
                            maxLength: null,
                            keyboardType: loginMethod == 0
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            onChanged: (String text) {},
                            onSubmitted: null,
                            backgroundColor: kDarkGray,
                            verticalPadding: width * 0.01,
                            horizontalPadding: width * 0.02,
                            isDense: null,
                            innerText: null,
                            errorText: null,
                            hintText: loginMethod == 0
                                ? 'البريد الإلكتروني'
                                : 'رقم الهاتف',
                            hintTextColor: kWhite.withOpacity(0.5),
                            suffixIcon: null,
                            prefixIcon: null,
                            border:
                                outlineInputBorder(width * 0.005, kTransparent),
                            focusedBorder:
                                outlineInputBorder(width * 0.005, kLightPurple),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 64),
                          child: CustomTextField(
                            controller: password,
                            width: width / 2.42,
                            fontOption: 3,
                            fontColor: kWhite,
                            textAlign: null,
                            obscure: obscurePassword,
                            readOnly: false,
                            focusNode: null,
                            maxLines: 1,
                            maxLength: null,
                            keyboardType: null,
                            onChanged: (String text) {},
                            onSubmitted: null,
                            backgroundColor: kDarkGray,
                            verticalPadding: width * 0.01,
                            horizontalPadding: width * 0.02,
                            isDense: null,
                            innerText: null,
                            errorText: null,
                            hintText: 'كلمة السر',
                            hintTextColor: kWhite.withOpacity(0.5),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: width / 65,
                                color: obscurePassword
                                    ? kWhite.withOpacity(0.5)
                                    : kWhite,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                            prefixIcon: null,
                            border:
                                outlineInputBorder(width * 0.005, kTransparent),
                            focusedBorder:
                                outlineInputBorder(width * 0.005, kLightPurple),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height / 32, bottom: height / 64),
                          child: CustomContainer(
                            onTap: () async {
                              if ((email.text != '' || phone.text != '') &&
                                  password.text != '') {
                                //TODO:
                                // String passwordSha256 = hashCode(password.text);
                                logIn(password.text, email.text, phone.text);
                              }
                            },
                            width: width / 2.42,
                            verticalPadding: height * 0.02,
                            horizontalPadding: 0,
                            borderRadius: width * 0.005,
                            border: null,
                            buttonColor: kLightPurple,
                            child: Center(
                              child: Text(
                                'سجل دخولك',
                                style: textStyle(3, width, height, kDarkBlack),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, SignUp.route);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: RichText(
                                text: TextSpan(
                              text: 'ما عندك حساب؟ ',
                              style: textStyle(4, width, height, kWhite),
                              children: [
                                TextSpan(
                                  text: ' أنشئ حساب جديد!',
                                  style:
                                      textStyle(4, width, height, kLightPurple),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.12),
                        SizedBox(
                          height: height * 0.1,
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkGray,
                          ),
                        ),
                        Text(
                          'أو',
                          style: textStyle(3, width, height, kDarkGray),
                        ),
                        SizedBox(
                          height: height * 0.1,
                          child: VerticalDivider(
                            thickness: 1,
                            color: kDarkGray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: width * 0.02),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.12),
                        CustomContainer(
                          onTap: () {},
                          width: width * 0.035,
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          borderRadius: 8,
                          buttonColor: kDarkGray,
                          border: null,
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.0025),
                            child: const Image(
                              image: AssetImage('images/facebook_logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        CustomContainer(
                          onTap: () {},
                          width: width * 0.035,
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          borderRadius: 8,
                          buttonColor: kDarkGray,
                          border: null,
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.0025),
                            child: const Image(
                              image: AssetImage('images/google_logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                    text: textList[current][1],
                    style: textStyle(1, width, height, kDarkBlack),
                    children: <TextSpan>[
                      TextSpan(
                        text: textList[current][0],
                        style: textStyle(1, width, height, kDarkPurple),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: width * 0.39,
                    child: CarouselSlider(
                      items: imgList
                          .map(
                            (item) => Image.asset(
                              item,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              width: width * 0.4,
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            current = index;
                          });
                        },
                        viewportFraction: 1,
                        autoPlay: true,
                      ),
                      carouselController: controller,
                    ),
                  ),
                  Row(
                    children: imgList.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => controller.animateToPage(entry.key),
                        child: Container(
                          width: width / 55,
                          height: height / 55,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kDarkBlack.withOpacity(
                                  current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

final List<String> imgList = [
  'images/clock.png',
  'images/led.png',
  'images/magnifying_glass.png'
];

final List<List<String>> textList = [
  ['وقتك المحدود', 'استغل '],
  ['من ذكائك', 'زيد '],
  ['نقاط ضعفك', 'اكتشف ']
];
