import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'log_in.dart';
import 'sign_up.dart';
import '../components/custom_container.dart';
import '../const.dart';
import '../utils/http_requests.dart';
import '../utils/session.dart';

class Welcome extends StatelessWidget {
  static const String route = '/';

  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/welcome_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: width / 14, vertical: height / 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: const AssetImage('images/logo.png'),
                  width: width / 10,
                ),
                Row(
                  children: [
                    Button(
                      onTap: () {},
                      width: width / 10,
                      verticalPadding: 8,
                      horizontalPadding: 0,
                      borderRadius: 8,
                      border: 0,
                      child: Center(
                        child: Text(
                          'تواصل معنا',
                          style: textStyle.copyWith(
                            fontSize: width / 100,
                          ),
                        ),
                      ),
                    ),
                    Button(
                      onTap: () {},
                      width: width / 10,
                      verticalPadding: 8,
                      horizontalPadding: 0,
                      borderRadius: 8,
                      border: 0,
                      child: Center(
                        child: Text(
                          'من نحن',
                          style: textStyle.copyWith(
                            fontSize: width / 100,
                          ),
                        ),
                      ),
                    ),
                    Button(
                      onTap: () {},
                      width: width / 10,
                      verticalPadding: 8,
                      horizontalPadding: 0,
                      borderRadius: 8,
                      buttonColor: kBlack,
                      borderColor: kWhite,
                      border: 4,
                      child: Center(
                        child: Text(
                          'ابدأ',
                          style: textStyle.copyWith(
                            fontSize: width / 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Image(
              image: AssetImage('images/study_is_your_game.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height / 40),
                      child: Button(
                        buttonColor: kPurple,
                        border: 0,
                        width: width / 6,
                        verticalPadding: 8,
                        horizontalPadding: 0,
                        borderRadius: 8,
                        onTap: () {
                          Navigator.pushNamed(context, SignUp.route);
                        },
                        child: Center(
                          child: Text(
                            'أنشئ حساب جديد',
                            style: textStyle.copyWith(
                              fontSize: width / 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: height / 40),
                      child: Button(
                        buttonColor: kBlack,
                        borderColor: kPurple,
                        border: 4,
                        width: width / 6,
                        verticalPadding: 8,
                        horizontalPadding: 0,
                        borderRadius: 8,
                        onTap: () async {
                          String? key0 = await getSession('sessionKey0');
                          String? key1 = await getSession('sessionKey1');
                          String? value = await getSession('sessionValue');
                          post('log_in/', {
                            if (key0 != null) 'email': key0,
                            if (key1 != null) 'phone': key1,
                            'password': value,
                          }).then((value) {
                            dynamic result = decode(value);
                            switch (result) {
                              case 0:
                                Navigator.pushNamed(context, Dashboard.route);
                                break;
                              default:
                                Navigator.pushNamed(context, LogIn.route);
                                break;
                            }
                          });
                        },
                        child: Center(
                          child: Text(
                            'سجل دخولك',
                            style: textStyle.copyWith(
                              fontSize: width / 80,
                              color: kPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text.rich(
                      textDirection: TextDirection.rtl,
                      TextSpan(
                        text:
                            'اكتشف نقاط ضعفك وزيد من تحصيلك التعليمي عن طريق تقنيات ',
                        style: textStyle.copyWith(
                          fontSize: width / 60,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'الذكاء الاصطناعي',
                            style: textStyle.copyWith(
                              shadows: [
                                Shadow(
                                    color: kWhite, offset: const Offset(0, -5))
                              ],
                              color: Colors.transparent,
                              fontSize: width / 60,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.wavy,
                              decorationColor: kPurple,
                              decorationThickness: 3,
                            ),
                          ),
                          TextSpan(
                            text: '\nالخاصة فينا',
                            style: textStyle.copyWith(
                              fontSize: width / 60,
                            ),
                          ),
                          // can add more TextSpans here...
                        ],
                      ),
                    ),
                    Text(
                      'سجل دخولك وتمتع بتجربة سلسة ومفيدة، اخضع لامتحانات مركزة وتغذية راجعة ما الها مثيل،\nوتقدم بمسواتك الخلاب!',
                      textDirection: TextDirection.rtl,
                      style: textStyle.copyWith(
                        fontSize: width / 60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
