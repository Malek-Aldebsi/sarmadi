import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/question_admin/question_admin.dart';

import '../components/custom_container.dart';
import '../components/custom_dropdown_menu.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/admin_provider.dart';
import '../utils/http_requests.dart';

class SuggestedQuiz extends StatefulWidget {
  static const String route = '/FinalAnswerQuestion/';

  const SuggestedQuiz({Key? key}) : super(key: key);

  @override
  State<SuggestedQuiz> createState() => _SuggestedQuizState();
}

class _SuggestedQuizState extends State<SuggestedQuiz> {
  bool acceptedQuiz(AdminProvider adminProvider) {
    bool checkQuestions = true;
    for (TextEditingController questionID
        in adminProvider.suggestedQuizQuestionsIDs) {
      checkQuestions &= questionID.text != '';
    }
    return adminProvider.suggestedQuizName.text != '' &&
        adminProvider.suggestedQuizSubject != '' &&
        adminProvider.suggestedQuizDuration.text != '' &&
        checkQuestions;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AdminProvider adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: kDarkGray,
      body: Align(
        alignment: Alignment.centerRight,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: width,
            child: ListView(
              cacheExtent: 5000000,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              onTap: () {
                                adminProvider.reset();
                                context.pushReplacement('/QuestionAdmin');
                              },
                              buttonColor: kTransparent,
                              border: fullBorder(kLightPurple),
                              borderRadius: width,
                              child: Icon(
                                Icons.home_rounded,
                                size: width * 0.02,
                                color: kLightPurple,
                              ),
                            ),
                            Text(
                              'امتحان مقترح',
                              style: textStyle(1, width, height, kLightPurple),
                            ),
                            SizedBox(
                              width: width * 0.04,
                            ),
                          ]),
                      SizedBox(height: height * 0.05),
                      Row(children: [
                        CustomTextField(
                          controller: adminProvider.suggestedQuizName,
                          width: width * 0.45,
                          fontOption: 3,
                          fontColor: kLightPurple,
                          textAlign: null,
                          obscure: null,
                          readOnly: false,
                          focusNode: null,
                          maxLines: 20,
                          maxLength: null,
                          keyboardType: null,
                          onChanged: (String text) {
                            adminProvider.notify();
                          },
                          onSubmitted: (value) {},
                          backgroundColor: kDarkGray,
                          verticalPadding: height * 0.02,
                          horizontalPadding: width * 0.02,
                          isDense: true,
                          errorText: null,
                          hintText: 'اسم الامتحان',
                          hintTextColor: kWhite.withOpacity(0.5),
                          suffixIcon: null,
                          prefixIcon: null,
                          border:
                              outlineInputBorder(width * 0.005, kLightPurple),
                          focusedBorder:
                              outlineInputBorder(width * 0.005, kLightPurple),
                        ),
                        SizedBox(width: width * 0.02),
                        CustomDropDownMenu(
                          textStyle: textStyle(3, width, height, kLightPurple),
                          hintText: 'مادة الإمتحان',
                          hintTextStyle: textStyle(
                              3, width, height, kWhite.withOpacity(0.5)),
                          width: width * 0.2,
                          menuMaxHeight: height * 0.4,
                          controller: adminProvider.suggestedQuizSubject,
                          onChanged: (subject) {
                            adminProvider.setSuggestedQuizSubject(subject);
                          },
                          options: [
                            'الرياضيات',
                            'الفيزياء',
                            'الأحياء',
                            'الكيمياء',
                            'اللغة العربية',
                            'اللغة الإنجليزية',
                            'التربية الإسلامية',
                            'التاريخ'
                          ],
                          fillColor: kDarkGray,
                          border:
                              outlineInputBorder(width * 0.005, kLightPurple),
                          focusedBorder:
                              outlineInputBorder(width * 0.005, kLightPurple),
                        ),
                        SizedBox(width: width * 0.02),
                        CustomTextField(
                          controller: adminProvider.suggestedQuizDuration,
                          width: width * 0.2,
                          fontOption: 3,
                          fontColor: kLightPurple,
                          textAlign: null,
                          obscure: null,
                          readOnly: false,
                          focusNode: null,
                          maxLines: 20,
                          maxLength: null,
                          keyboardType: null,
                          onChanged: (String text) {
                            adminProvider.notify();
                          },
                          onSubmitted: (value) {},
                          backgroundColor: kDarkGray,
                          verticalPadding: height * 0.02,
                          horizontalPadding: width * 0.02,
                          isDense: true,
                          errorText: null,
                          hintText: 'مدة الامتحان بالدقائق',
                          hintTextColor: kWhite.withOpacity(0.5),
                          suffixIcon: null,
                          prefixIcon: null,
                          border:
                              outlineInputBorder(width * 0.005, kLightPurple),
                          focusedBorder:
                              outlineInputBorder(width * 0.005, kLightPurple),
                        ),
                      ]),
                      SizedBox(height: height * 0.05),
                      for (int questionID = 0;
                          questionID <
                              adminProvider.suggestedQuizQuestionsIDs.length;
                          questionID++) ...[
                        Row(
                          children: [
                            CustomTextField(
                              controller: adminProvider
                                  .suggestedQuizQuestionsIDs[questionID],
                              width: width * 0.45,
                              fontOption: 3,
                              fontColor: kLightPurple,
                              textAlign: null,
                              obscure: null,
                              readOnly: false,
                              focusNode: null,
                              maxLines: 1,
                              maxLength: null,
                              keyboardType: null,
                              onChanged: (String text) {
                                adminProvider.notify();
                              },
                              onSubmitted: (value) {},
                              backgroundColor: kDarkGray,
                              verticalPadding: height * 0.02,
                              horizontalPadding: width * 0.02,
                              isDense: true,
                              errorText: null,
                              hintText: 'كود السؤال',
                              hintTextColor: kWhite.withOpacity(0.5),
                              suffixIcon: null,
                              prefixIcon: null,
                              border: outlineInputBorder(
                                  width * 0.005, kLightPurple),
                              focusedBorder: outlineInputBorder(
                                  width * 0.005, kLightPurple),
                            ),
                            if (questionID ==
                                adminProvider.suggestedQuizQuestionsIDs.length -
                                    1) ...[
                              SizedBox(width: width * 0.03),
                              CustomContainer(
                                onTap: () {
                                  adminProvider.addQuestionID();
                                },
                                width: width * 0.03,
                                height: height * 0.05,
                                verticalPadding: null,
                                horizontalPadding: null,
                                buttonColor: kLightPurple,
                                border: null,
                                borderRadius: width * 0.005,
                                child: Text(
                                  '+',
                                  style: textStyle(3, width, height, kDarkGray),
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              CustomContainer(
                                onTap: () {
                                  if (adminProvider
                                          .suggestedQuizQuestionsIDs.length >
                                      1) {
                                    adminProvider.removeLastQuestionID();
                                  }
                                },
                                width: width * 0.03,
                                height: height * 0.05,
                                verticalPadding: null,
                                horizontalPadding: null,
                                buttonColor: kDarkGray,
                                border: fullBorder(kLightPurple),
                                borderRadius: width * 0.005,
                                child: Text(
                                  '-',
                                  style:
                                      textStyle(3, width, height, kLightPurple),
                                ),
                              ),
                            ]
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                      ],
                      SizedBox(height: height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            onTap: () {
                              if (acceptedQuiz(adminProvider)) {
                                post('add_suggested_quiz/', {
                                  'quiz_name':
                                      adminProvider.suggestedQuizName.text,
                                  'quiz_subject':
                                      adminProvider.suggestedQuizSubject,
                                  'quiz_duration':
                                      adminProvider.suggestedQuizDuration.text,
                                  'questions': [
                                    for (TextEditingController questionID
                                        in adminProvider
                                            .suggestedQuizQuestionsIDs)
                                      questionID.text
                                  ],
                                }).then((value) {
                                  dynamic result = decode(value);
                                  if (result == 1) {
                                    adminProvider.reset();
                                  }
                                });
                              }
                            },
                            width: width * 0.2,
                            height: height * 0.08,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kDarkGray,
                            border: fullBorder(kLightPurple),
                            borderRadius: width * 0.005,
                            child: Text(
                              'حفظ الامتحان',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
