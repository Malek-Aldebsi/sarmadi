import 'package:flutter/material.dart';

import 'components/custom_container.dart';
import 'const/borders.dart';
import 'const/colors.dart';
import 'const/fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Page1(),
  ));
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  get mainAxisAlignment => Page1();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: kWhite,
        body: CustomContainer(
          onTap: null,
          width: width * 0.3,
          height: height * 0.8,
          verticalPadding: 0,
          horizontalPadding: 0,
          borderRadius: width * 0.005,
          border: fullBorder(kLightBlack),
          buttonColor: kTransparent,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              'login or sign up to \ncontinue',
              textAlign: TextAlign.center,
              style: textStyle(1, width, height, kLightBlack),
            ),
            SizedBox(
              height: height * 0.3,
            ),
            Text(
                'i agree to Terms of Service and confirm that i have \nread Yelps Privacy Policy.     ',
                textAlign: TextAlign.center,
                style: textStyle(4, width, height, kBlue)),
            SizedBox(
              height: height * 0.02,
            ),
            CustomContainer(
                onTap: () {},
                width: width * 0.25,
                height: height * 0.05,
                verticalPadding: 0,
                horizontalPadding: 0,
                borderRadius: width * 0.003,
                border: null,
                buttonColor: kBlue,
                child: Text('Continue with Facebook',
                    style: textStyle(3, width, height, kWhite))),
            SizedBox(
              height: height * 0.01,
            ),
            CustomContainer(
                onTap: () {},
                width: width * 0.25,
                height: height * 0.05,
                verticalPadding: 0,
                horizontalPadding: 0,
                borderRadius: width * 0.003,
                border: fullBorder(kLightGray, 0.5),
                buttonColor: kWhite,
                child: Text('Continue with Google',
                    style: textStyle(3, width, height, kLightBlack))),
            SizedBox(
              height: height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                    onTap: () {},
                    width: width * 0.12,
                    height: height * 0.05,
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    borderRadius: width * 0.003,
                    border: fullBorder(kLightGray, 0.5),
                    buttonColor: kWhite,
                    child: Text('Log in',
                        style: textStyle(3, width, height, kLightBlack))),
                SizedBox(
                  width: width * 0.01,
                ),
                CustomContainer(
                    onTap: () {},
                    width: width * 0.12,
                    height: height * 0.05,
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    borderRadius: width * 0.003,
                    border: null,
                    buttonColor: kRed,
                    child: Text('I\'m new',
                        style: textStyle(3, width, height, kWhite))),
              ],
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomContainer(
              onTap: null,
              width: width * 0.30,
              height: height * 0.05,
              verticalPadding: 0,
              horizontalPadding: 0,
              borderRadius: width * 0,
              border: null,
              buttonColor: Colors.grey[200],
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.02,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: width * 0.015,
                      color: kLightGray,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: width * 0.015,
                      color: kLightGray,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.circle_outlined,
                      size: width * 0.015,
                      color: kLightGray,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.05,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.crop_square_rounded,
                      size: width * 0.015,
                      color: kLightGray,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
