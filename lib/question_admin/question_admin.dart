import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/const/borders.dart';

import '../components/custom_container.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/admin_provider.dart';
import 'edit_question.dart';
import 'final_answer_question.dart';
import 'multi_section_question.dart';
import 'multiple_choice_question.dart';

class QuestionAdmin extends StatefulWidget {
  static const String route = '/QuestionAdmin/';

  const QuestionAdmin({Key? key}) : super(key: key);

  @override
  State<QuestionAdmin> createState() => _QuestionAdminState();
}

class _QuestionAdminState extends State<QuestionAdmin> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AdminProvider adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: kDarkGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomContainer(
              onTap: () {
                adminProvider.reset();
                context.go('/MultipleChoiceQuestion');
              },
              width: width * 0.3,
              height: height * 0.1,
              verticalPadding: height * 0.02,
              horizontalPadding: width * 0.02,
              buttonColor: kLightPurple,
              border: null,
              borderRadius: width * 0.05,
              child: Text(
                'سؤال متعدد الخيارات',
                style: textStyle(2, width, height, kDarkGray),
              ),
            ),
            SizedBox(height: height * 0.02),
            CustomContainer(
              onTap: () {
                adminProvider.reset();
                context.go('/FinalAnswerQuestion');
              },
              width: width * 0.3,
              height: height * 0.1,
              verticalPadding: height * 0.02,
              horizontalPadding: width * 0.02,
              buttonColor: kDarkGray,
              border: fullBorder(kLightPurple),
              borderRadius: width * 0.05,
              child: Text(
                'سؤال جواب نهائي',
                style: textStyle(2, width, height, kLightPurple),
              ),
            ),
            SizedBox(height: height * 0.02),
            CustomContainer(
              onTap: () {
                adminProvider.reset();
                context.go('/MultiSectionQuestion');
              },
              width: width * 0.3,
              height: height * 0.1,
              verticalPadding: height * 0.02,
              horizontalPadding: width * 0.02,
              buttonColor: kLightPurple,
              border: null,
              borderRadius: width * 0.05,
              child: Text(
                'سؤال متعدد الفروع',
                style: textStyle(2, width, height, kDarkGray),
              ),
            ),
            SizedBox(height: height * 0.02),
            CustomContainer(
              onTap: () {
                adminProvider.reset();
                context.go('/EditQuestion');
              },
              width: width * 0.3,
              height: height * 0.1,
              verticalPadding: height * 0.02,
              horizontalPadding: width * 0.02,
              buttonColor: kDarkGray,
              border: fullBorder(kLightPurple),
              borderRadius: width * 0.05,
              child: Text(
                'تعديل سؤال سابق',
                style: textStyle(2, width, height, kLightPurple),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
