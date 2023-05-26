import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth/utils/showSnackbar.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/user_info_provider.dart';
import '../components/custom_container.dart';
import '../components/custom_text_field.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../utils/authentication.dart';
import '../utils/session.dart';
import '../utils/http_requests.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final CarouselController controller = CarouselController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  int current = 0;
  int signUpMethod = 0; // 0 email 1 phone

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<int> validator = [0, 0, 0, 0, 0, 0, 0, 0];

  // String? section;
  // List<String> sectionList = ['العلمي', 'الأدبي', 'الصناعي'];

  Future<bool> checkInfo(UserInfoProvider userInfoProvider) async {
    bool acceptedInfo = false;
    await post('check_new_account_info/', {
      if (userInfoProvider.userEmail.text != '')
        'email': userInfoProvider.userEmail.text,
      if (userInfoProvider.userPhone.text != '')
        'phone': userInfoProvider.userPhone.text,
      'password': userInfoProvider.userPassword.text,
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          acceptedInfo = true;
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
          showSnackBar(
              context, 'تأكد من اتصالك بالإنترنت ثم قم بالمحاولة مجدداً');
          break;
        default:
          showSnackBar(context, 'لقد حصل خطأ غير متوقع قم بالمحاولة لاحقاً');
          break;
      }
    });
    return acceptedInfo;
  }

  Future<bool> signUpWithEmail(UserInfoProvider userInfoProvider) async {
    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .signUpWithEmail(
          context,
          userInfoProvider.userEmail.text,
          userInfoProvider.userPassword.text,
        )
        .then((value) {
      verified = value;
    });
    return verified;
  }

  Future<bool> signUpWithFacebook(UserInfoProvider userInfoProvider) async {
    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .signUpWithFacebook(context, userInfoProvider)
        .then((value) {
      verified = value;
    });
    return verified;
  }

  Future<bool> signUpWithGoogle(UserInfoProvider userInfoProvider) async {
    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .signUpWithGoogle(context, userInfoProvider)
        .then((value) {
      verified = value;
    });
    return verified;
  }

  Future<bool> signUpWithPhone(UserInfoProvider userInfoProvider) async {
    String reStylePhoneNum(String phoneNum) {
      if (phoneNum.startsWith('0')) {
        return '+962${phoneNum.substring(1)}';
      }
      return phoneNum;
    }

    bool verified = false;
    await context
        .read<FirebaseAuthMethods>()
        .signUpWithPhone(
            context, reStylePhoneNum(userInfoProvider.userPhone.text))
        .then((value) {
      verified = value;
    });
    return verified;
  }

  void completeSignUpWithEmailOrPhone(UserInfoProvider userInfoProvider) async {
    post('sign_up/', {
      if (signUpMethod == 0) 'email': userInfoProvider.userEmail.text,
      if (signUpMethod == 1) 'phone': userInfoProvider.userPhone.text,
      'password': userInfoProvider.userPassword.text,
      'auth_method': signUpMethod == 0 ? 2 : 1,
      'firstName': userInfoProvider.firstName.text,
      'lastName': userInfoProvider.lastName.text
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          if (signUpMethod == 0) userInfoProvider.setUserEmail();
          if (signUpMethod == 1) userInfoProvider.setUserPhone();
          userInfoProvider.setUserPassword();
          context.go('/Dashboard');
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

  void completeSignUpWithFacebook(UserInfoProvider userInfoProvider) async {
    post('sign_up/', {
      if (userInfoProvider.userEmail.text != '')
        'email': userInfoProvider.userEmail.text,
      if (userInfoProvider.userPhone.text != '')
        'phone': userInfoProvider.userPhone.text,
      'password': userInfoProvider.userPassword.text,
      'auth_method': 4,
      'firstName': userInfoProvider.firstName.text,
      'lastName': userInfoProvider.lastName.text
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          if (userInfoProvider.userEmail.text != '') {
            userInfoProvider.setUserEmail();
          }
          if (userInfoProvider.userPhone.text != '') {
            userInfoProvider.setUserPhone();
          }
          userInfoProvider.setUserPassword();
          context.go('/Dashboard');
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

  void completeSignUpWithGoogle(UserInfoProvider userInfoProvider) async {
    post('sign_up/', {
      'email': userInfoProvider.userEmail.text,
      'password': userInfoProvider.userPassword.text,
      'auth_method': 3,
      'firstName': userInfoProvider.firstName.text,
      'lastName': userInfoProvider.lastName.text
    }).then((value) {
      dynamic result = decode(value);
      switch (result) {
        case 0:
          userInfoProvider.setUserEmail();
          userInfoProvider.setUserPassword();
          context.go('/Dashboard');
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

  void checkSession() async {
    String? key0 = await getSession('sessionKey0');
    String? key1 = await getSession('sessionKey1');
    String? value = await getSession('sessionValue');

    if ((key0 != null || key1 != null) && (value != null)) {
      context.go('/Dashboard');
    }
  }

  @override
  void initState() {
    super.initState();
    // checkSession();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    UserInfoProvider userInfoProvider =
        Provider.of<UserInfoProvider>(context, listen: false);
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
                            'إنشاء حساب',
                            style: textStyle(3, width, height, kLightPurple),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: height / 32, right: 12),
                          child: Text(
                            'أهـلا فيـك!',
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
                                    signUpMethod = 0;
                                  });
                                },
                                width: width * 0.21,
                                verticalPadding: height * 0.01,
                                buttonColor: kTransparent,
                                horizontalPadding: 0,
                                borderRadius: null,
                                border: singleBottomBorder(signUpMethod == 0
                                    ? kLightPurple
                                    : kDarkGray),
                                child: Center(
                                  child: Text(
                                    'البريد الإلكتروني',
                                    style: textStyle(
                                        3,
                                        width,
                                        height,
                                        signUpMethod == 0
                                            ? kLightPurple
                                            : kDarkGray),
                                  ),
                                ),
                              ),
                              CustomContainer(
                                onTap: () {
                                  setState(() {
                                    userInfoProvider.userEmail.text = '';
                                    signUpMethod = 1;
                                  });
                                },
                                width: width * 0.21,
                                verticalPadding: height * 0.01,
                                horizontalPadding: 0,
                                buttonColor: kTransparent,
                                borderRadius: null,
                                border: singleBottomBorder(signUpMethod == 1
                                    ? kLightPurple
                                    : kDarkGray),
                                child: Center(
                                  child: Text(
                                    'رقم الهاتف',
                                    style: textStyle(
                                        3,
                                        width,
                                        height,
                                        signUpMethod == 1
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
                          child: Row(
                            children: [
                              CustomTextField(
                                controller: userInfoProvider.firstName,
                                width: width * 0.2,
                                fontOption: 3,
                                fontColor: kWhite,
                                textAlign: null,
                                obscure: false,
                                readOnly: false,
                                focusNode: focusNodes[0],
                                maxLines: 1,
                                maxLength: null,
                                keyboardType: null,
                                onChanged: (String text) {},
                                onSubmitted: (value) {
                                  if (userInfoProvider.firstName.text.isEmpty) {
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
                                backgroundColor: kDarkGray,
                                verticalPadding: width * 0.01,
                                horizontalPadding: width * 0.02,
                                isDense: null,
                                errorText: validator[0] == 0
                                    ? null
                                    : 'لا يجب أن يكون فارغاً',
                                hintText: 'الاسم الاول',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: null,
                                prefixIcon: null,
                                border: outlineInputBorder(
                                    width * 0.005, kTransparent),
                                focusedBorder: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              CustomTextField(
                                controller: userInfoProvider.lastName,
                                width: width * 0.2,
                                fontOption: 3,
                                fontColor: kWhite,
                                textAlign: null,
                                obscure: false,
                                readOnly: false,
                                focusNode: focusNodes[1],
                                maxLines: 1,
                                maxLength: null,
                                keyboardType: null,
                                onChanged: (String text) {},
                                onSubmitted: (value) {
                                  if (userInfoProvider.lastName.text.isEmpty) {
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
                                backgroundColor: kDarkGray,
                                verticalPadding: width * 0.01,
                                horizontalPadding: width * 0.02,
                                isDense: null,
                                errorText: validator[1] == 0
                                    ? null
                                    : 'لا يجب أن يكون فارغاً',
                                hintText: 'اسم العائلة',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: null,
                                prefixIcon: null,
                                border: outlineInputBorder(
                                    width * 0.005, kTransparent),
                                focusedBorder: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: height / 64),
                          child: CustomTextField(
                            controller: signUpMethod == 0
                                ? userInfoProvider.userEmail
                                : userInfoProvider.userPhone,
                            width: width * 0.42,
                            fontOption: 3,
                            fontColor: kWhite,
                            textAlign: null,
                            obscure: false,
                            readOnly: false,
                            focusNode: focusNodes[2],
                            maxLines: 1,
                            maxLength: null,
                            keyboardType: signUpMethod == 0
                                ? TextInputType.emailAddress
                                : TextInputType.phone,
                            onChanged: (String text) {},
                            onSubmitted: signUpMethod == 0
                                ? (value) {
                                    if (userInfoProvider
                                        .userEmail.text.isEmpty) {
                                      setState(() {
                                        validator[2] = 1;
                                        focusNodes[2].requestFocus();
                                      });
                                    } else if (!RegExp(
                                            r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                        .hasMatch(
                                            userInfoProvider.userEmail.text)) {
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
                                  }
                                : (value) {
                                    if (userInfoProvider
                                        .userPhone.text.isEmpty) {
                                      setState(() {
                                        validator[3] = 1;
                                        focusNodes[2].requestFocus();
                                      });
                                    } else if (!RegExp(
                                            r'^([+]962|0)7(7|8|9)[0-9]{7,}')
                                        .hasMatch(
                                            userInfoProvider.userPhone.text)) {
                                      setState(() {
                                        validator[3] = 2;
                                        focusNodes[2].requestFocus();
                                      });
                                    } else {
                                      setState(() {
                                        validator[3] = 0;
                                        FocusScope.of(context)
                                            .requestFocus(focusNodes[3]);
                                      });
                                    }
                                  },
                            backgroundColor: kDarkGray,
                            verticalPadding: width * 0.01,
                            horizontalPadding: width * 0.02,
                            isDense: null,
                            errorText: signUpMethod == 0
                                ? validator[2] == 0
                                    ? null
                                    : validator[2] == 1
                                        ? 'لا يجب أن يكون فارغاً'
                                        : validator[2] == 2
                                            ? 'البريد الإلكتروني المدخل غير صحيح'
                                            : 'هذا البريد الإلكتروني مستخدم بالفعل قم بتسجيل الدخول او جرب بريداً اخر'
                                : validator[3] == 0
                                    ? null
                                    : validator[3] == 1
                                        ? 'لا يجب أن يكون فارغاً'
                                        : validator[3] == 2
                                            ? 'رقم الهاتف المدخل غير صحيح'
                                            : 'رقم الهاتف مستخدم بالفعل قم بتسجيل الدخول او جرب رقماً اخر',
                            hintText: signUpMethod == 0
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
                          child: Row(
                            children: [
                              CustomTextField(
                                controller: userInfoProvider.userPassword,
                                width: width * 0.2,
                                fontOption: 3,
                                fontColor: kWhite,
                                textAlign: null,
                                obscure: obscurePassword,
                                readOnly: false,
                                focusNode: focusNodes[3],
                                maxLines: 1,
                                maxLength: null,
                                keyboardType: null,
                                onChanged: (String text) {},
                                onSubmitted: (value) {
                                  if (userInfoProvider
                                          .userPassword.text.length <
                                      8) {
                                    setState(() {
                                      validator[4] = 1;
                                      focusNodes[3].requestFocus();
                                    });
                                  } else if (!RegExp(
                                          r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                      .hasMatch(
                                          userInfoProvider.userPassword.text)) {
                                    setState(() {
                                      validator[4] = 2;
                                      focusNodes[3].requestFocus();
                                    });
                                  } else {
                                    setState(() {
                                      validator[4] = 0;
                                      FocusScope.of(context)
                                          .requestFocus(focusNodes[4]);
                                    });
                                  }
                                },
                                backgroundColor: kDarkGray,
                                verticalPadding: width * 0.01,
                                horizontalPadding: width * 0.02,
                                isDense: null,
                                errorText: validator[4] == 0
                                    ? null
                                    : validator[4] == 1
                                        ? 'يجب أن تتكون كلمة السر من 8 رموز أو أكثر'
                                        : 'يجب أن تحتوي كلمة السر على حروف وأرقام',
                                hintText: 'كلمة السر',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: width / 65,
                                    color: kWhite.withOpacity(0.5),
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
                              SizedBox(
                                width: width * 0.02,
                              ),
                              CustomTextField(
                                controller:
                                    userInfoProvider.userConfirmPassword,
                                width: width * 0.2,
                                fontOption: 3,
                                fontColor: kWhite,
                                textAlign: null,
                                obscure: obscureConfirmPassword,
                                readOnly: false,
                                focusNode: focusNodes[4],
                                maxLines: 1,
                                maxLength: null,
                                keyboardType: null,
                                onChanged: (String text) {},
                                onSubmitted: (value) {
                                  if (userInfoProvider
                                          .userConfirmPassword.text !=
                                      userInfoProvider.userPassword.text) {
                                    setState(() {
                                      validator[5] = 1;
                                      focusNodes[4].requestFocus();
                                    });
                                  } else {
                                    setState(() {
                                      validator[5] = 0;
                                      FocusScope.of(context).unfocus();
                                    });
                                  }
                                },
                                backgroundColor: kDarkGray,
                                verticalPadding: width * 0.01,
                                horizontalPadding: width * 0.02,
                                isDense: null,
                                errorText: validator[5] == 0
                                    ? null
                                    : 'غير مطابق لكلمة السر',
                                hintText: 'تأكيد كلمة السر',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscureConfirmPassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: width / 65,
                                    color: kWhite.withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                          !obscureConfirmPassword;
                                    });
                                  },
                                ),
                                prefixIcon: null,
                                border: outlineInputBorder(
                                    width * 0.005, kTransparent),
                                focusedBorder: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //   EdgeInsets.symmetric(vertical: height / 64),
                        //   child: Row(
                        //     children: [
                        //       CustomDropDownMenu(
                        //         errorText: validator[6] == 0
                        //             ? null
                        //             : 'قم بإختيار جيلك',
                        //         hintText: 'الجيل',
                        //         fontSize: width / 85,
                        //         width: width *0.2,
                        //         controller: grade,
                        //         options: grades.values.toList(),
                        //         onChanged: (text) {
                        //           setState(() {
                        //             validator[6] = 0;
                        //             grade = text;
                        //           });
                        //         },
                        //         icon: Icon(
                        //           Icons.expand_more,
                        //           size: width / 65,
                        //           color: kOffWhite,
                        //         ),
                        //         fillColor: kLightGray,
                        //         hintTextColor: kOffWhite,
                        //       ),
                        //       SizedBox(width: width / 64),
                        //       grade == 'الأول ثانوي' ||
                        //           grade == 'الثاني ثانوي'
                        //           ? CustomDropDownMenu(
                        //         errorText: validator[7] == 0
                        //             ? null
                        //             : 'قم بإختيار فرعك',
                        //         hintText: 'الفرع',
                        //         fontSize: width / 85,
                        //         width: width / 5,
                        //         controller: section,
                        //         options: sectionList,
                        //         onChanged: (text) {
                        //           setState(() {
                        //             validator[7] = 0;
                        //             section = text;
                        //           });
                        //         },
                        //         icon: Icon(
                        //           Icons.expand_more,
                        //           size: width / 65,
                        //           color: kOffWhite,
                        //         ),
                        //         hintTextColor: kOffWhite,
                        //         fillColor: kLightGray,
                        //       )
                        //           : Container(),
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: height / 32, bottom: height / 64),
                          child: CustomContainer(
                            onTap: () async {
                              if (userInfoProvider.firstName.text.isEmpty) {
                                setState(() {
                                  validator[0] = 1;
                                });
                              } else if (userInfoProvider
                                  .lastName.text.isEmpty) {
                                setState(() {
                                  validator[1] = 1;
                                });
                              } else if (userInfoProvider
                                      .userEmail.text.isEmpty &&
                                  signUpMethod == 0) {
                                setState(() {
                                  validator[2] = 1;
                                });
                              } else if (!RegExp(
                                          r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                      .hasMatch(
                                          userInfoProvider.userEmail.text) &&
                                  signUpMethod == 0) {
                                setState(() {
                                  validator[2] = 2;
                                });
                              } else if (userInfoProvider
                                      .userPhone.text.isEmpty &&
                                  signUpMethod == 1) {
                                setState(() {
                                  validator[3] = 1;
                                });
                              } else if (!RegExp(r'^([+]962|0)7(7|8|9)[0-9]{7}')
                                      .hasMatch(
                                          userInfoProvider.userPhone.text) &&
                                  signUpMethod == 1) {
                                setState(() {
                                  validator[3] = 2;
                                });
                              } else if (userInfoProvider
                                  .userPassword.text.isEmpty) {
                                setState(() {
                                  validator[4] = 1;
                                });
                              } else if (!RegExp(
                                      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')
                                  .hasMatch(
                                      userInfoProvider.userPassword.text)) {
                                setState(() {
                                  validator[4] = 2;
                                });
                              } else if (userInfoProvider
                                      .userConfirmPassword.text !=
                                  userInfoProvider.userConfirmPassword.text) {
                                setState(() {
                                  validator[5] = 1;
                                });
                              }
                              // else if (section == null &&
                              //     intGrades[grade]! > 10) {
                              //   setState(() {
                              //     validator[7] = 1;
                              //   });
                              // }
                              else {
                                if (signUpMethod == 0) {
                                  checkInfo(userInfoProvider)
                                      .then((value) async {
                                    if (value) {
                                      await signUpWithEmail(userInfoProvider)
                                          .then((value) {
                                        if (value) {
                                          completeSignUpWithEmailOrPhone(
                                              userInfoProvider);
                                        }
                                      });
                                    }
                                  });
                                } else if (signUpMethod == 1) {
                                  checkInfo(userInfoProvider)
                                      .then((value) async {
                                    if (value) {
                                      await signUpWithPhone(userInfoProvider)
                                          .then((value) {
                                        if (value) {
                                          completeSignUpWithEmailOrPhone(
                                              userInfoProvider);
                                        }
                                      });
                                    }
                                  });
                                }
                              }
                            },
                            width: width * 0.42,
                            verticalPadding: height * 0.02,
                            horizontalPadding: 0,
                            borderRadius: width * 0.005,
                            border: null,
                            buttonColor: kLightPurple,
                            child: Center(
                              child: Text(
                                'أنشئ',
                                style: textStyle(3, width, height, kDarkBlack),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            context.go('/LogIn');
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: RichText(
                                text: TextSpan(
                              text: 'عندك حساب؟ ',
                              style: textStyle(4, width, height, kWhite),
                              children: [
                                TextSpan(
                                  text: ' سجل دخولك!',
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
                          onTap: () async {
                            await signUpWithFacebook(userInfoProvider)
                                .then((value) {
                              if (value) {
                                checkInfo(userInfoProvider).then((value) {
                                  if (value) {
                                    completeSignUpWithFacebook(
                                        userInfoProvider);
                                  } else {
                                    if (userInfoProvider.userEmail.text != '') {
                                      userInfoProvider.setUserEmail();
                                    }
                                    if (userInfoProvider.userPhone.text != '') {
                                      userInfoProvider.setUserPhone();
                                    }
                                    userInfoProvider.setUserPassword();
                                    context.go('/Dashboard');
                                  }
                                });
                              }
                            });
                          },
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
                          onTap: () async {
                            await signUpWithGoogle(userInfoProvider)
                                .then((value) {
                              if (value) {
                                checkInfo(userInfoProvider).then((value) {
                                  if (value) {
                                    completeSignUpWithGoogle(userInfoProvider);
                                  } else {
                                    userInfoProvider.setUserEmail();
                                    userInfoProvider.setUserPassword();
                                    context.go('/Dashboard');
                                  }
                                });
                              }
                            });
                          },
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
