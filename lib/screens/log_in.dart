import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/screens/rotate_your_phone.dart';
import '../components/snack_bar.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/user_info_provider.dart';
import '../components/custom_container.dart';
import '../components/custom_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../providers/website_provider.dart';
import '../utils/authentication.dart';
import '../utils/session.dart';
import '../utils/encrypt.dart';
import '../utils/http_requests.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final CarouselController controller = CarouselController();

  bool obscurePassword = true;

  int current = 0;
  int loginMethod = 0; // 0 email 1 phone

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<int> validator = [0, 0, 0, 0, 0, 0];

  Future<bool> logInWithGoogle(UserInfoProvider userInfoProvider) async {
    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .logInWithGoogle(context, userInfoProvider)
        .then((value) {
      verified = value;
    });
    return verified;
  }

  Future<bool> logInWithFacebook(UserInfoProvider userInfoProvider) async {
    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .logInWithFacebook(context, userInfoProvider)
        .then((value) {
      verified = value;
    });
    return verified;
  }

  void completeLogInWithEmailOrPhone(
      UserInfoProvider userInfoProvider, WebsiteProvider websiteProvider) {
    post('log_in/', {
      if (loginMethod == 0) 'email': userInfoProvider.userEmail.text,
      if (loginMethod == 1) 'phone': userInfoProvider.userPhone.text,
      'password': encrypt(userInfoProvider.userPassword.text),
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          if (loginMethod == 0) userInfoProvider.setUserEmail();
          if (loginMethod == 1) userInfoProvider.setUserPhone();
          userInfoProvider.setUserPassword();
          context.pushReplacement(websiteProvider.lastRoot);
          break;
        case 1:
          setState(() {
            validator[0] = 3;
          });
          break;
        case 2:
          setState(() {
            validator[1] = 3;
          });
          break;
        case 404:
          showSnackBar(
              context, 'تأكد من اتصالك بالإنترنت ثم قم بالمحاولة مجدداً');
          break;
        default:
          showSnackBar(context, 'لقد حصل خطأ غير متوقع قم بالمحاولة لاحقاً');
          break;
      }
    });
  }

  void completeLogInWithGoogle(
      UserInfoProvider userInfoProvider, WebsiteProvider websiteProvider) {
    post('log_in/', {
      'email': userInfoProvider.userEmail.text,
      'password': encrypt(userInfoProvider.userPassword.text),
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          if (loginMethod == 0) userInfoProvider.setUserEmail();
          if (loginMethod == 1) userInfoProvider.setUserPhone();
          userInfoProvider.setUserPassword();
          context.pushReplacement(websiteProvider.lastRoot);
          break;
        case 1:
          showSnackBar(context,
              'لا يوجد حساب مربوط بحساب قوقل المدخل قم بانشاء حساب أولاً');
          break;
        case 2:
          showSnackBar(context,
              'لا يوجد حساب مربوط بحساب قوقل المدخل قم بانشاء حساب أولاً');
          break;
        case 404:
          showSnackBar(
              context, 'تأكد من اتصالك بالإنترنت ثم قم بالمحاولة مجدداً');
          break;
        default:
          showSnackBar(context, 'لقد حصل خطأ غير متوقع قم بالمحاولة لاحقاً');
          break;
      }
    });
  }

  void completeLogInWithFacebook(
      UserInfoProvider userInfoProvider, WebsiteProvider websiteProvider) {
    post('log_in/', {
      if (userInfoProvider.userEmail.text != '')
        'email': userInfoProvider.userEmail.text,
      if (userInfoProvider.userPhone.text != '')
        'phone': userInfoProvider.userPhone.text,
      'password': encrypt(userInfoProvider.userPassword.text),
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          if (loginMethod == 0) userInfoProvider.setUserEmail();
          if (loginMethod == 1) userInfoProvider.setUserPhone();
          userInfoProvider.setUserPassword();
          context.pushReplacement(websiteProvider.lastRoot);
          break;
        case 1:
          showSnackBar(context,
              'لا يوجد حساب مربوط بحساب فيسبوك المدخل قم بانشاء حساب أولاً');
          break;
        case 2:
          showSnackBar(context,
              'لا يوجد حساب مربوط بحساب فيسبوك المدخل قم بانشاء حساب أولاً');
          break;
        case 404:
          showSnackBar(
              context, 'تأكد من اتصالك بالإنترنت ثم قم بالمحاولة مجدداً');
          break;
        default:
          showSnackBar(context, 'لقد حصل خطأ غير متوقع قم بالمحاولة لاحقاً');
          break;
      }
    });
  }

  void checkSession(UserInfoProvider userInfoProvider,
      WebsiteProvider websiteProvider) async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    if ((key0 != null || key1 != null) && (value != null)) {
      delSession('sessionKey0');
      delSession('sessionKey1');
      delSession('sessionValue');

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
          context.pushReplacement(websiteProvider.lastRoot);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkSession(Provider.of<UserInfoProvider>(context, listen: false),
        Provider.of<WebsiteProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);

    WebsiteProvider websiteProvider =
        Provider.of<WebsiteProvider>(context, listen: false);
    return
      width < height
        ? const RotateYourPhone()
        :
    Scaffold(
        body: Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/signup_background.jpg"),
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
                    SizedBox(
                      height: height * 0.72,
                      width: width * 0.42,
                      child: ListView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  'تسجيل الدخول',
                                  style:
                                      textStyle(3, width, height, kLightPurple),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: height / 64, right: 12),
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
                                          userInfoProvider.userPhone.text = '';
                                          userInfoProvider.userPassword.text =
                                              '';
                                          loginMethod = 0;
                                        });
                                      },
                                      width: width / 4.84,
                                      verticalPadding: height * 0.01,
                                      buttonColor: kTransparent,
                                      horizontalPadding: 0,
                                      borderRadius: null,
                                      border: singleBottomBorder(
                                          loginMethod == 0
                                              ? kLightPurple
                                              : kWhite.withOpacity(0.2)),
                                      child: Center(
                                        child: Text(
                                          'البريد الإلكتروني',
                                          style: textStyle(
                                              3,
                                              width,
                                              height,
                                              loginMethod == 0
                                                  ? kLightPurple
                                                  : kWhite.withOpacity(0.2)),
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                      onTap: () {
                                        setState(() {
                                          userInfoProvider.userEmail.text = '';
                                          userInfoProvider.userPassword.text =
                                              '';
                                          loginMethod = 1;
                                        });
                                      },
                                      width: width / 4.84,
                                      verticalPadding: height * 0.01,
                                      horizontalPadding: 0,
                                      buttonColor: kTransparent,
                                      borderRadius: null,
                                      border: singleBottomBorder(
                                          loginMethod == 1
                                              ? kLightPurple
                                              : kWhite.withOpacity(0.2)),
                                      child: Center(
                                        child: Text(
                                          'رقم الهاتف',
                                          style: textStyle(
                                              3,
                                              width,
                                              height,
                                              loginMethod == 1
                                                  ? kLightPurple
                                                  : kWhite.withOpacity(0.2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 64),
                                child: CustomTextField(
                                  controller: loginMethod == 0
                                      ? userInfoProvider.userEmail
                                      : userInfoProvider.userPhone,
                                  width: width / 2.42,
                                  fontOption: 3,
                                  fontColor: kWhite,
                                  textAlign: null,
                                  obscure: false,
                                  readOnly: false,
                                  focusNode: focusNodes[0],
                                  maxLines: 1,
                                  maxLength: null,
                                  keyboardType: loginMethod == 0
                                      ? TextInputType.emailAddress
                                      : TextInputType.phone,
                                  onChanged: (String text) {},
                                  onSubmitted: loginMethod == 0
                                      ? (value) {
                                          if (userInfoProvider
                                              .userEmail.text.isEmpty) {
                                            setState(() {
                                              validator[0] = 1;
                                              if (width > 750 && height > 400) {
                                                focusNodes[0].requestFocus();
                                              }
                                            });
                                          } else if (!RegExp(
                                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                              .hasMatch(userInfoProvider
                                                  .userEmail.text)) {
                                            setState(() {
                                              validator[0] = 0;
                                              if (width > 750 && height > 400) {
                                                focusNodes[0].requestFocus();
                                              }
                                            });
                                          } else {
                                            setState(() {
                                              validator[0] = 0;
                                              if (width > 750 && height > 400) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        focusNodes[1]);
                                              }
                                            });
                                          }
                                        }
                                      : (value) {
                                          if (userInfoProvider
                                              .userPhone.text.isEmpty) {
                                            setState(() {
                                              validator[1] = 1;
                                              if (width > 750 && height > 400) {
                                                focusNodes[0].requestFocus();
                                              }
                                            });
                                          } else if (!RegExp(
                                                  r'^([+]962|0)7(7|8|9)[0-9]{7,}')
                                              .hasMatch(userInfoProvider
                                                  .userPhone.text)) {
                                            setState(() {
                                              validator[1] = 2;
                                              if (width > 750 && height > 400) {
                                                focusNodes[0].requestFocus();
                                              }
                                            });
                                          } else {
                                            setState(() {
                                              validator[1] = 0;
                                              if (width > 750 && height > 400) {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        focusNodes[1]);
                                              }
                                            });
                                          }
                                        },
                                  backgroundColor: kDarkGray,
                                  verticalPadding: width * 0.01,
                                  horizontalPadding: width * 0.02,
                                  isDense: true,
                                  errorText: loginMethod == 0
                                      ? validator[0] == 0
                                          ? null
                                          : validator[0] == 1
                                              ? 'لا يجب أن يكون فارغاً'
                                              : validator[0] == 2
                                                  ? 'البريد الإلكتروني المدخل غير صحيح'
                                                  : 'البريد الإلكتروني او كلمة السر غير صحيحان'
                                      : validator[1] == 0
                                          ? null
                                          : validator[1] == 1
                                              ? 'لا يجب أن يكون فارغاً'
                                              : validator[1] == 2
                                                  ? 'رقم الهاتف المدخل غير صحيح'
                                                  : 'رقم الهاتف او كلمة السر غير صحيحان',
                                  hintText: loginMethod == 0
                                      ? 'البريد الإلكتروني'
                                      : 'رقم الهاتف',
                                  hintTextColor: kWhite.withOpacity(0.5),
                                  suffixIcon: null,
                                  prefixIcon: null,
                                  border: outlineInputBorder(
                                      width * 0.005, kTransparent),
                                  focusedBorder: outlineInputBorder(
                                      width * 0.005, kLightPurple),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: height / 64),
                                child: CustomTextField(
                                  controller: userInfoProvider.userPassword,
                                  width: width / 2.42,
                                  fontOption: 3,
                                  fontColor: kWhite,
                                  textAlign: null,
                                  obscure: obscurePassword,
                                  readOnly: false,
                                  focusNode: focusNodes[1],
                                  maxLines: 1,
                                  maxLength: null,
                                  keyboardType: null,
                                  onChanged: (String text) {},
                                  onSubmitted: (value) {
                                    if (userInfoProvider
                                            .userPassword.text.length <
                                        8) {
                                      setState(() {
                                        validator[2] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[1].requestFocus();
                                        }
                                      });
                                    } else if (!RegExp(
                                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                        .hasMatch(userInfoProvider
                                            .userPassword.text)) {
                                      setState(() {
                                        validator[2] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[1].requestFocus();
                                        }
                                      });
                                    } else {
                                      setState(() {
                                        validator[2] = 0;
                                        FocusScope.of(context).unfocus();
                                        if ((userInfoProvider.userEmail.text !=
                                                    '' ||
                                                userInfoProvider
                                                        .userPhone.text !=
                                                    '') &&
                                            userInfoProvider
                                                    .userPassword.text !=
                                                '') {
                                          completeLogInWithEmailOrPhone(
                                              userInfoProvider,
                                              websiteProvider);
                                        }
                                      });
                                    }
                                  },
                                  backgroundColor: kDarkGray,
                                  verticalPadding: width * 0.01,
                                  horizontalPadding: width * 0.02,
                                  isDense: true,
                                  errorText: validator[2] == 0
                                      ? null
                                      : 'كلمة السر غير صحيحة',
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
                                  border: outlineInputBorder(
                                      width * 0.005, kTransparent),
                                  focusedBorder: outlineInputBorder(
                                      width * 0.005, kLightPurple),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: height / 32, bottom: height / 64),
                                child: CustomContainer(
                                  onTap: () {
                                    if (loginMethod == 0 &&
                                        userInfoProvider
                                            .userEmail.text.isEmpty) {
                                      setState(() {
                                        validator[0] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[0].requestFocus();
                                        }
                                      });
                                    } else if (loginMethod == 0 &&
                                        !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(
                                            userInfoProvider.userEmail.text)) {
                                      setState(() {
                                        validator[0] = 0;
                                        if (width > 750 && height > 400) {
                                          focusNodes[0].requestFocus();
                                        }
                                      });
                                    } else if (loginMethod == 1 &&
                                        userInfoProvider
                                            .userPhone.text.isEmpty) {
                                      setState(() {
                                        validator[1] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[0].requestFocus();
                                        }
                                      });
                                    } else if (loginMethod == 1 &&
                                        !RegExp(r'^([+]962|0)7(7|8|9)[0-9]{7,}')
                                            .hasMatch(userInfoProvider
                                                .userPhone.text)) {
                                      setState(() {
                                        validator[1] = 2;
                                        if (width > 750 && height > 400) {
                                          focusNodes[0].requestFocus();
                                        }
                                      });
                                    } else if (userInfoProvider
                                            .userPassword.text.length <
                                        8) {
                                      setState(() {
                                        validator[2] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[1].requestFocus();
                                        }
                                      });
                                    } else if (!RegExp(
                                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                        .hasMatch(userInfoProvider
                                            .userPassword.text)) {
                                      setState(() {
                                        validator[2] = 1;
                                        if (width > 750 && height > 400) {
                                          focusNodes[1].requestFocus();
                                        }
                                      });
                                    } else if ((userInfoProvider.userEmail.text !=
                                                '' ||
                                            userInfoProvider.userPhone.text !=
                                                '') &&
                                        userInfoProvider.userPassword.text != '') {
                                      completeLogInWithEmailOrPhone(
                                          userInfoProvider, websiteProvider);
                                    }
                                  },
                                  width: width / 2.42,
                                  height: width * 0.04,
                                  verticalPadding: 0,
                                  horizontalPadding: 0,
                                  borderRadius: width * 0.005,
                                  border: null,
                                  buttonColor: kLightPurple,
                                  child: Center(
                                    child: Text(
                                      'سجل دخولك',
                                      style: textStyle(
                                          3, width, height, kDarkBlack),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  context.pushReplacement('/SignUp');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: RichText(
                                      text: TextSpan(
                                    text: 'ما عندك حساب؟ ',
                                    style: textStyle(4, width, height, kWhite),
                                    children: [
                                      TextSpan(
                                        text: ' أنشئ حساب جديد!',
                                        style: textStyle(
                                            4, width, height, kLightPurple),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                          onTap: () async {
                            await logInWithFacebook(userInfoProvider)
                                .then((value) {
                              if (value) {
                                completeLogInWithFacebook(
                                    userInfoProvider, websiteProvider);
                              }
                            });
                          },
                          width: width * 0.035,
                          height: width * 0.035,
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
                          onTap: () async {
                            await logInWithGoogle(userInfoProvider)
                                .then((value) {
                              if (value) {
                                completeLogInWithGoogle(
                                    userInfoProvider, websiteProvider);
                              }
                            });
                          },
                          width: width * 0.035,
                          height: width * 0.035,
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
