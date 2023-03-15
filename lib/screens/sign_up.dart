import 'package:flutter/material.dart';
import 'dashboard.dart';
import '../utils/http_requests.dart';
import '../utils/hashCode.dart';
import '../components/custom_container.dart';
import '../components/custom_dropdown_menu.dart';
import '../components/custom_text_field.dart';
import '../const.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../utils/session.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  static const String route = '/SignUp/';

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  CarouselController controller = CarouselController();
  int current = 0;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  TextEditingController password = TextEditingController();
  bool obscurePassword = true;

  TextEditingController confirmPassword = TextEditingController();
  bool obscureConfirmPassword = true;

  String? section;
  List<String> sectionList = ['العلمي', 'الأدبي', 'الصناعي'];

  String? grade;
  Map<int, String> grades = {
    12: 'الثاني ثانوي',
    11: 'الأول ثانوي',
    10: 'العاشر',
    9: 'التاسع',
    8: 'الثامن',
    7: 'السابع',
    6: 'السادس',
    5: 'الخامس',
    4: 'الرابع',
    3: 'الثالث',
    2: 'الثاني',
    1: 'الأول',
  };

  void signUp(email, phone, password, firstName, lastName, section, grade) {
    post('sign_up/', {
      'email': email,
      'phone': phone,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'section': section,
      'grade': grade,
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          setSession('sessionKey0', email);
          setSession('sessionValue', password)
              .then((value) => Navigator.pushNamed(context, Dashboard.route));
          break;
        case 1:
          setState(() {
            validator[2] = 3;
            validator[3] = 3;
          });
          break;
        case 2:
          setState(() {
            validator[2] = 3;
          });
          break;
        case 3:
          setState(() {
            validator[3] = 3;
          });
          break;
        case 404:
          print('check your connection');
          break;
        default:
          print('sth goes wrong, try later');
          print(result);
          break;
      }
    });
  }

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<int> validator = [0, 0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    delSession('sessionKey0');
    delSession('sessionKey1');
    delSession('sessionValue');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
      child: Directionality(
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
                          Text(
                            'إنشاء حساب',
                            style: textStyle.copyWith(
                              color: kPurple,
                              fontWeight: FontWeight.w800,
                              fontSize: width / 90,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height / 32),
                            child: Text(
                              'أهـلا فيـك!',
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: width / 50,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 64),
                            child: Row(
                              children: [
                                CustomTextField(
                                  focusNode: focusNodes[0],
                                  errorText: validator[0] == 0
                                      ? null
                                      : 'لا يجب أن يكون فارغاً',
                                  onSubmitted: (value) {
                                    if (firstName.text.isEmpty) {
                                      setState(() {
                                        validator[0] = 1;
                                        focusNodes[0].requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        validator[0] = 0;
                                        FocusScope.of(context)
                                            .requestFocus(focusNodes[1]);
                                      });
                                    }
                                  },
                                  innerText: null,
                                  hintText: 'الاسم الاول',
                                  fontSize: width / 85,
                                  width: width / 5,
                                  controller: firstName,
                                  onChanged: (text) {},
                                  readOnly: false,
                                  obscure: false,
                                  suffixIcon: null,
                                  keyboardType: null,
                                  color: kLightGray,
                                  verticalPadding: width / 170,
                                  horizontalPadding: width / 42.5,
                                  border: roundedInputBorder(),
                                  focusedBorder: roundedFocusedBorder(),
                                ),
                                SizedBox(width: width / 64),
                                CustomTextField(
                                  focusNode: focusNodes[1],
                                  errorText: validator[1] == 0
                                      ? null
                                      : 'لا يجب أن يكون فارغاً',
                                  onSubmitted: (value) {
                                    if (lastName.text.isEmpty) {
                                      setState(() {
                                        validator[1] = 1;
                                        focusNodes[1].requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        validator[1] = 0;
                                        FocusScope.of(context)
                                            .requestFocus(focusNodes[2]);
                                      });
                                    }
                                  },
                                  innerText: null,
                                  hintText: 'اسم العائلة',
                                  fontSize: width / 85,
                                  width: width / 5,
                                  controller: lastName,
                                  onChanged: (text) {},
                                  readOnly: false,
                                  obscure: false,
                                  suffixIcon: null,
                                  keyboardType: null,
                                  color: kLightGray,
                                  verticalPadding: width / 170,
                                  horizontalPadding: width / 42.5,
                                  border: roundedInputBorder(),
                                  focusedBorder: roundedFocusedBorder(),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 64),
                            child: CustomTextField(
                              focusNode: focusNodes[2],
                              errorText: validator[2] == 0
                                  ? null
                                  : validator[2] == 1
                                      ? 'لا يجب أن يكون فارغاً'
                                      : validator[2] == 2
                                          ? 'البريد الإلكتروني المدخل غير صحيح'
                                          : 'هذا البريد الإلكتروني مستخدم بالفعل قم بتسجيل الدخول او جرب بريداً اخر',
                              onSubmitted: (value) {
                                if (email.text.isEmpty) {
                                  setState(() {
                                    validator[2] = 1;
                                    focusNodes[2].requestFocus();
                                  });
                                } else if (!RegExp(
                                        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(email.text)) {
                                  setState(() {
                                    validator[2] = 2;
                                    focusNodes[2].requestFocus();
                                  });
                                } else {
                                  setState(() {
                                    validator[2] = 0;
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes[3]);
                                  });
                                }
                              },
                              innerText: null,
                              hintText: 'البريد الإلكتروني',
                              fontSize: width / 85,
                              width: width / 2.42,
                              controller: email,
                              onChanged: (text) {},
                              readOnly: false,
                              obscure: false,
                              suffixIcon: null,
                              keyboardType: TextInputType.emailAddress,
                              color: kLightGray,
                              verticalPadding: width / 170,
                              horizontalPadding: width / 42.5,
                              border: roundedInputBorder(),
                              focusedBorder: roundedFocusedBorder(),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 64),
                            child: CustomTextField(
                              focusNode: focusNodes[3],
                              errorText: validator[3] == 0
                                  ? null
                                  : validator[3] == 1
                                      ? 'لا يجب أن يكون فارغاً'
                                      : validator[3] == 2
                                          ? 'رقم الهاتف المدخل غير صحيح'
                                          : 'رقم الهاتف مستخدم بالفعل قم بتسجيل الدخول او جرب رقماً اخر',
                              onSubmitted: (value) {
                                if (phone.text.isEmpty) {
                                  setState(() {
                                    validator[3] = 1;
                                    focusNodes[3].requestFocus();
                                  });
                                } else if (!RegExp(
                                        r'^([+]962|0)7(7|8|9)[0-9]{7,}')
                                    .hasMatch(phone.text)) {
                                  setState(() {
                                    validator[3] = 2;
                                    focusNodes[3].requestFocus();
                                  });
                                } else {
                                  setState(() {
                                    validator[3] = 0;
                                    FocusScope.of(context)
                                        .requestFocus(focusNodes[4]);
                                  });
                                }
                              },
                              innerText: null,
                              hintText: 'رقم الهاتف',
                              fontSize: width / 85,
                              width: width / 2.42,
                              controller: phone,
                              onChanged: (text) {},
                              readOnly: false,
                              obscure: false,
                              suffixIcon: null,
                              keyboardType: TextInputType.phone,
                              color: kLightGray,
                              verticalPadding: width / 170,
                              horizontalPadding: width / 42.5,
                              border: roundedInputBorder(),
                              focusedBorder: roundedFocusedBorder(),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 64),
                            child: Row(
                              children: [
                                CustomTextField(
                                  focusNode: focusNodes[4],
                                  errorText: validator[4] == 0
                                      ? null
                                      : validator[4] == 1
                                          ? 'يجب أن تتكون كلمة السر من 8 رموز أو أكثر'
                                          : 'يجب أن تحتوي كلمة السر على حروف وأرقام',
                                  onSubmitted: (value) {
                                    if (password.text.length < 8) {
                                      setState(() {
                                        validator[4] = 1;
                                        focusNodes[4].requestFocus();
                                      });
                                    } else if (!RegExp(
                                            r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                        .hasMatch(password.text)) {
                                      setState(() {
                                        validator[4] = 2;
                                        focusNodes[4].requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        validator[4] = 0;
                                        FocusScope.of(context)
                                            .requestFocus(focusNodes[5]);
                                      });
                                    }
                                  },
                                  innerText: null,
                                  hintText: 'كلمة السر',
                                  fontSize: width / 85,
                                  width: width / 5,
                                  controller: password,
                                  onChanged: (text) {},
                                  readOnly: false,
                                  obscure: obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: width / 65,
                                      color: kOffWhite,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                  ),
                                  keyboardType: null,
                                  color: kLightGray,
                                  verticalPadding: width / 170,
                                  horizontalPadding: width / 42.5,
                                  border: roundedInputBorder(),
                                  focusedBorder: roundedFocusedBorder(),
                                ),
                                SizedBox(width: width / 64),
                                CustomTextField(
                                  focusNode: focusNodes[5],
                                  errorText: validator[5] == 0
                                      ? null
                                      : 'غير مطابق لكلمة السر',
                                  onSubmitted: (value) {
                                    if (confirmPassword.text != password.text) {
                                      setState(() {
                                        validator[5] = 1;
                                        focusNodes[5].requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        validator[5] = 0;
                                        FocusScope.of(context).unfocus();
                                      });
                                    }
                                  },
                                  innerText: null,
                                  hintText: 'تأكيد كلمة السر',
                                  fontSize: width / 85,
                                  width: width / 5,
                                  controller: confirmPassword,
                                  onChanged: (text) {},
                                  readOnly: false,
                                  obscure: obscureConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      size: width / 65,
                                      color: kOffWhite,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscureConfirmPassword =
                                            !obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  keyboardType: null,
                                  color: kLightGray,
                                  verticalPadding: width / 170,
                                  horizontalPadding: width / 42.5,
                                  border: roundedInputBorder(),
                                  focusedBorder: roundedFocusedBorder(),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: height / 64),
                            child: Row(
                              children: [
                                CustomDropDownMenu(
                                  errorText: validator[6] == 0
                                      ? null
                                      : 'قم بإختيار صفك',
                                  hintText: 'الصف',
                                  fontSize: width / 85,
                                  width: width / 5,
                                  controller: grade,
                                  options: grades.values.toList(),
                                  onChanged: (text) {
                                    setState(() {
                                      validator[6] = 0;
                                      grade = text;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.expand_more,
                                    size: width / 65,
                                    color: kOffWhite,
                                  ),
                                  fillColor: kLightGray,
                                  hintTextColor: kOffWhite,
                                ),
                                SizedBox(width: width / 64),
                                grade == 'الأول ثانوي' ||
                                        grade == 'الثاني ثانوي'
                                    ? CustomDropDownMenu(
                                        errorText: validator[7] == 0
                                            ? null
                                            : 'قم بإختيار فرعك',
                                        hintText: 'الفرع',
                                        fontSize: width / 85,
                                        width: width / 5,
                                        controller: section,
                                        options: sectionList,
                                        onChanged: (text) {
                                          setState(() {
                                            validator[7] = 0;
                                            section = text;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.expand_more,
                                          size: width / 65,
                                          color: kOffWhite,
                                        ),
                                        hintTextColor: kOffWhite,
                                        fillColor: kLightGray,
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: height / 32, bottom: height / 64),
                            child: Button(
                              onTap: () async {
                                var intGrades =
                                    grades.map((k, v) => MapEntry(v, k));

                                if (firstName.text.isEmpty) {
                                  setState(() {
                                    validator[0] = 1;
                                  });
                                } else if (lastName.text.isEmpty) {
                                  setState(() {
                                    validator[1] = 1;
                                  });
                                } else if (email.text.isEmpty) {
                                  setState(() {
                                    validator[2] = 1;
                                  });
                                } else if (!RegExp(
                                        r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(email.text)) {
                                  setState(() {
                                    validator[2] = 2;
                                  });
                                } else if (phone.text.isEmpty) {
                                  setState(() {
                                    validator[3] = 1;
                                  });
                                } else if (!RegExp(
                                        r'^([+]962|0)7(7|8|9)[0-9]{7}')
                                    .hasMatch(phone.text)) {
                                  setState(() {
                                    validator[3] = 2;
                                  });
                                } else if (password.text.isEmpty) {
                                  setState(() {
                                    validator[4] = 1;
                                  });
                                } else if (!RegExp(
                                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                    .hasMatch(password.text)) {
                                  setState(() {
                                    validator[4] = 2;
                                  });
                                } else if (confirmPassword.text !=
                                    password.text) {
                                  setState(() {
                                    validator[5] = 1;
                                  });
                                } else if (grade == null) {
                                  setState(() {
                                    validator[6] = 1;
                                  });
                                } else if (section == null &&
                                    intGrades[grade]! > 10) {
                                  setState(() {
                                    validator[7] = 1;
                                  });
                                } else {
                                  String passwordSha256 =
                                      hashCode(password.text);

                                  signUp(
                                      email.text,
                                      phone.text,
                                      passwordSha256,
                                      firstName.text,
                                      lastName.text,
                                      section,
                                      intGrades[grade]);
                                }
                              },
                              width: width / 2.42,
                              verticalPadding: 8,
                              horizontalPadding: 0,
                              borderRadius: 20,
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
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, LogIn.route);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: RichText(
                                  text: TextSpan(
                                text: 'عندك حساب؟ ',
                                style: textStyle.copyWith(
                                    fontSize: width / 100,
                                    color: kWhite,
                                    fontWeight: FontWeight.w800),
                                children: [
                                  TextSpan(
                                    text: 'سجل دخولك!',
                                    style: textStyle.copyWith(
                                      fontSize: width / 100,
                                      color: kPurple,
                                      fontWeight: FontWeight.w800,
                                    ),
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
                          SizedBox(
                            height: height * 0.1,
                            child: VerticalDivider(
                              thickness: 1,
                              color: kLightGray,
                            ),
                          ),
                          Text(
                            'أو',
                            style: textStyle.copyWith(
                              color: kLightGray,
                              fontWeight: FontWeight.w800,
                              fontSize: width / 90,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.1,
                            child: VerticalDivider(
                              thickness: 1,
                              color: kLightGray,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Button(
                            onTap: () {},
                            width: width * 0.035,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            borderRadius: 8,
                            buttonColor: kLightGray,
                            border: 0,
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.0025),
                              child: const Image(
                                image: AssetImage('images/facebook_logo.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                          Button(
                            onTap: () {},
                            width: width * 0.035,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            borderRadius: 8,
                            buttonColor: kLightGray,
                            border: 0,
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
                      style: textStyle.copyWith(
                          fontSize: width / 40,
                          color: kBlack,
                          fontWeight: FontWeight.w800),
                      children: <TextSpan>[
                        TextSpan(
                          text: textList[current][0],
                          style: textStyle.copyWith(
                            fontSize: width / 40,
                            color: kPurple,
                            fontWeight: FontWeight.w800,
                          ),
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
                                color: kBlack.withOpacity(
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
