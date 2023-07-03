import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/user_info_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../const/sarmadi_icons_icons.dart';
import '../providers/website_provider.dart';
import '../utils/session.dart';
import 'custom_container.dart';
import 'custom_pop_up.dart';

class RightBar extends StatefulWidget {
  const RightBar({Key? key}) : super(key: key);

  @override
  State<RightBar> createState() => _RightBarState();
}

class _RightBarState extends State<RightBar> {
  bool copyPhone = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    WebsiteProvider websiteProvider = Provider.of<WebsiteProvider>(context);
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context);
    return CustomContainer(
      width: width * 0.06,
      height: height,
      border: singleLeftBorder(kDarkGray),
      buttonColor: kLightBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: height * 0.07,
              ),
              Divider(
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: kDarkGray,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.02),
                child: CustomContainer(
                  onTap: () {
                    websiteProvider.setLoaded(false);
                    context.pushReplacement('/QuizSetting');
                  },
                  buttonColor: kDarkBlack,
                  border: null,
                  width: width * 0.035,
                  height: height * 0.06,
                  borderRadius: width * 0.005,
                  child: Icon(
                    Icons.home_rounded,
                    size: width * 0.02,
                    color: kPurple,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.02),
                child: CustomContainer(
                  onTap: () {
                    websiteProvider.setLoaded(false);
                    context.pushReplacement('/QuizHistory');
                  },
                  buttonColor: kDarkBlack,
                  border: null,
                  width: width * 0.035,
                  height: height * 0.06,
                  borderRadius: width * 0.005,
                  child: Icon(
                    SarmadiIcons.history,
                    size: width * 0.02,
                    color: kWhite,
                  ),
                ),
              ),
            ],
          ),
          Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.005),
              child: Divider(
                thickness: 1,
                indent: width * 0.005,
                endIndent: width * 0.005,
                color: kDarkGray,
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: CustomContainer(
                    onTap: () async {
                      setState(() {
                        copyPhone = true;
                      });
                      await Clipboard.setData(
                          const ClipboardData(text: '+962799378997'));
                      Timer(const Duration(seconds: 1), () {
                        setState(() {
                          copyPhone = false;
                        });
                      });
                    },
                    buttonColor: kDarkBlack,
                    border: null,
                    width: width * 0.035,
                    height: height * 0.06,
                    borderRadius: width * 0.005,
                    child: Icon(
                      copyPhone ? Icons.copy : SarmadiIcons.call,
                      size: width * 0.02,
                      color: kWhite,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomContainer(
                onTap: () {
                  html.window.open(
                      'https://www.facebook.com/profile.php?id=100093615428668',
                      "_blank");
                },
                buttonColor: kDarkBlack,
                border: null,
                width: width * 0.035,
                height: height * 0.06,
                borderRadius: width * 0.005,
                child: Icon(
                  SarmadiIcons.facebookOutline,
                  size: width * 0.02,
                  color: kWhite,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomContainer(
                onTap: () {
                  html.window.open('https://wa.me/+962799378997', "_blank");
                },
                buttonColor: kDarkBlack,
                border: null,
                width: width * 0.035,
                height: height * 0.06,
                borderRadius: width * 0.005,
                child: Icon(
                  SarmadiIcons.whatsUp,
                  size: width * 0.02,
                  color: kWhite,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.005),
              child: Divider(
                thickness: 1,
                indent: width * 0.005,
                endIndent: width * 0.005,
                color: kDarkGray,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              child: CustomContainer(
                onTap: () {
                  popUp(
                      context,
                      width * 0.2,
                      height * 0.25,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'هل تريد تسجيل الخروج',
                            style: textStyle(3, width, height, kLightPurple),
                          ),
                          SizedBox(height: height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomContainer(
                                onTap: () {
                                  context.pop();
                                },
                                width: width * 0.08,
                                height: height * 0.06,
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                borderRadius: width * 0.005,
                                buttonColor: kDarkBlack,
                                border: fullBorder(kLightPurple),
                                child: Center(
                                  child: Text(
                                    'لا',
                                    style: textStyle(
                                        3, width, height, kLightPurple),
                                  ),
                                ),
                              ),
                              SizedBox(width: width * 0.02),
                              CustomContainer(
                                onTap: () {
                                  websiteProvider.setLoaded(false);
                                  delSession('sessionKey0');
                                  delSession('sessionKey1');
                                  delSession('sessionValue').then((value) {
                                    context.pop();
                                    userInfoProvider.reset();
                                    context.pushReplacement('/Welcome');
                                  });
                                },
                                width: width * 0.08,
                                height: height * 0.06,
                                verticalPadding: 0,
                                horizontalPadding: 0,
                                borderRadius: width * 0.005,
                                buttonColor: kLightPurple,
                                border: null,
                                child: Center(
                                  child: Text(
                                    'نعم',
                                    style:
                                        textStyle(3, width, height, kDarkBlack),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      kLightBlack,
                      kDarkBlack,
                      width * 0.01);
                },
                buttonColor: kDarkBlack,
                border: null,
                width: width * 0.035,
                height: height * 0.06,
                borderRadius: width * 0.005,
                child: Icon(
                  SarmadiIcons.logout,
                  size: width * 0.02,
                  color: kWhite,
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
