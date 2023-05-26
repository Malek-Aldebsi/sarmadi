import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/question_admin/question_admin.dart';

import '../components/custom_container.dart';
import '../components/custom_text_field.dart';
import '../components/string_with_latex.dart';
import '../const/borders.dart';
import '../const/colors.dart';
import '../const/fonts.dart';
import '../providers/admin_provider.dart';
import '../utils/http_requests.dart';

class MultiSectionQuestion extends StatefulWidget {
  static const String route = '/MultiSectionQuestion/';

  const MultiSectionQuestion({Key? key}) : super(key: key);

  @override
  State<MultiSectionQuestion> createState() => _MultiSectionQuestionState();
}

class _MultiSectionQuestionState extends State<MultiSectionQuestion> {
  bool acceptedQuestion(AdminProvider adminProvider) {
    bool accepted = true;
    for (Map ques in adminProvider.subQuestionsControllers) {
      accepted = accepted && ques['question'].text != '';
      if (ques['type'] == 'multipleChoiceQuestion') {
        for (TextEditingController choice in ques['choices']) {
          accepted = accepted && choice.text != '';
        }
        accepted = accepted && ques['choices'].length >= 2;
      } else {
        accepted = accepted && ques['answer'].text != '';
      }
      for (TextEditingController headline in ques['headlines']) {
        accepted = accepted && headline.text != '';
      }
    }
    return adminProvider.questionController.text != '' &&
        adminProvider.subQuestionsControllers.isNotEmpty &&
        accepted &&
        adminProvider.questionSourceController.text != '';
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
                                context.go('/QuestionAdmin');
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
                              'سؤال متعدد الفروع',
                              style: textStyle(1, width, height, kLightPurple),
                            ),
                            SizedBox(
                              width: width * 0.04,
                            ),
                          ]),
                      SizedBox(height: height * 0.05),
                      Row(children: [
                        CustomTextField(
                          controller: adminProvider.questionController,
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
                          hintText: 'السؤال',
                          hintTextColor: kWhite.withOpacity(0.5),
                          suffixIcon: null,
                          prefixIcon: null,
                          border:
                              outlineInputBorder(width * 0.005, kLightPurple),
                          focusedBorder:
                              outlineInputBorder(width * 0.005, kLightPurple),
                        ),
                        SizedBox(width: width * 0.02),
                        CustomContainer(
                          onTap: null,
                          width: width * 0.45,
                          height: null,
                          verticalPadding: height * 0.02,
                          horizontalPadding: width * 0.02,
                          buttonColor: kLightPurple,
                          border: null,
                          borderRadius: width * 0.005,
                          child: stringWithLatex(
                              adminProvider.questionController.text,
                              3,
                              width,
                              height,
                              kDarkGray),
                        ),
                      ]),
                      SizedBox(height: height * 0.05),
                      for (int questionIndex = 0;
                          questionIndex <
                              adminProvider.subQuestionsControllers.length;
                          questionIndex++) ...[
                        SizedBox(height: height * 0.05),
                        Row(children: [
                          CustomTextField(
                            controller: adminProvider
                                    .subQuestionsControllers[questionIndex]
                                ['question'],
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
                            hintText: 'السؤال الفرعي',
                            hintTextColor: kWhite.withOpacity(0.5),
                            suffixIcon: null,
                            prefixIcon: null,
                            border:
                                outlineInputBorder(width * 0.005, kLightPurple),
                            focusedBorder:
                                outlineInputBorder(width * 0.005, kLightPurple),
                          ),
                          SizedBox(width: width * 0.02),
                          CustomContainer(
                            onTap: null,
                            width: width * 0.45,
                            height: null,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kLightPurple,
                            border: null,
                            borderRadius: width * 0.005,
                            child: stringWithLatex(
                                adminProvider
                                    .subQuestionsControllers[questionIndex]
                                        ['question']
                                    .text,
                                3,
                                width,
                                height,
                                kDarkGray),
                          ),
                        ]),
                        SizedBox(height: height * 0.02),
                        if (adminProvider.subQuestionsControllers[questionIndex]
                                ['type'] ==
                            'finalAnswerQuestion') ...[
                          Row(children: [
                            CustomTextField(
                              controller: adminProvider
                                      .subQuestionsControllers[questionIndex]
                                  ['answer'],
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
                              hintText: 'الجواب',
                              hintTextColor: kWhite.withOpacity(0.5),
                              suffixIcon: null,
                              prefixIcon: null,
                              border: outlineInputBorder(
                                  width * 0.005, kLightPurple),
                              focusedBorder: outlineInputBorder(
                                  width * 0.005, kLightPurple),
                            ),
                            SizedBox(width: width * 0.02),
                            CustomContainer(
                              onTap: null,
                              width: width * 0.45,
                              height: null,
                              verticalPadding: height * 0.02,
                              horizontalPadding: width * 0.02,
                              buttonColor: kLightPurple,
                              border: null,
                              borderRadius: width * 0.005,
                              child: stringWithLatex(
                                  adminProvider
                                      .subQuestionsControllers[questionIndex]
                                          ['answer']
                                      .text,
                                  3,
                                  width,
                                  height,
                                  kDarkGray),
                            ),
                          ]),
                        ],
                        if (adminProvider.subQuestionsControllers[questionIndex]
                                ['type'] ==
                            'multipleChoiceQuestion') ...[
                          for (int choiceIndex = 0;
                              choiceIndex <
                                  adminProvider
                                      .subQuestionsControllers[questionIndex]
                                          ['choices']
                                      .length;
                              choiceIndex++) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomTextField(
                                      controller:
                                          adminProvider.subQuestionsControllers[
                                                  questionIndex]['choices']
                                              [choiceIndex],
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
                                      hintText: choiceIndex == 0
                                          ? 'الخيار الصحيح'
                                          : 'ادخل الخيار',
                                      hintTextColor: kWhite.withOpacity(0.5),
                                      suffixIcon: null,
                                      prefixIcon: null,
                                      border: outlineInputBorder(
                                          width * 0.005, kLightPurple),
                                      focusedBorder: outlineInputBorder(
                                          width * 0.005, kLightPurple),
                                    ),
                                    SizedBox(width: width * 0.02),
                                    CustomContainer(
                                      onTap: null,
                                      width: width * 0.45,
                                      height: null,
                                      verticalPadding: height * 0.02,
                                      horizontalPadding: width * 0.02,
                                      buttonColor: kLightPurple,
                                      border: null,
                                      borderRadius: width * 0.005,
                                      child: stringWithLatex(
                                          adminProvider
                                              .subQuestionsControllers[
                                                  questionIndex]['choices']
                                                  [choiceIndex]
                                              .text,
                                          3,
                                          width,
                                          height,
                                          kDarkGray),
                                    ),
                                  ],
                                ),
                                if (choiceIndex != 0) ...[
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    children: [
                                      CustomTextField(
                                        controller: adminProvider
                                                    .subQuestionsControllers[
                                                questionIndex]['choicesNotes']
                                            [choiceIndex],
                                        width: width * 0.2,
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
                                        hintText: 'معلومة إضافية',
                                        hintTextColor: kWhite.withOpacity(0.5),
                                        suffixIcon: null,
                                        prefixIcon: null,
                                        border: outlineInputBorder(
                                            width * 0.005, kLightPurple),
                                        focusedBorder: outlineInputBorder(
                                            width * 0.005, kLightPurple),
                                      ),
                                      if (choiceIndex ==
                                          adminProvider
                                                  .subQuestionsControllers[
                                                      questionIndex]['choices']
                                                  .length -
                                              1) ...[
                                        SizedBox(width: width * 0.02),
                                        CustomContainer(
                                          onTap: () {
                                            adminProvider
                                                .subQuestionsControllers[
                                                    questionIndex]['choices']
                                                .add(TextEditingController());

                                            adminProvider
                                                .subQuestionsControllers[
                                                    questionIndex]
                                                    ['choicesNotes']
                                                .add(TextEditingController());
                                            adminProvider.notify();
                                          },
                                          width: width * 0.2,
                                          height: null,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          buttonColor: kLightPurple,
                                          border: null,
                                          borderRadius: width * 0.005,
                                          child: Text(
                                            'أضف خيار أخر',
                                            style: textStyle(
                                                3, width, height, kDarkGray),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.05),
                                        CustomContainer(
                                          onTap: () {
                                            setState(() {
                                              if (adminProvider
                                                      .subQuestionsControllers[
                                                          questionIndex]
                                                          ['choices']
                                                      .length >
                                                  2) {
                                                adminProvider
                                                    .subQuestionsControllers[
                                                        questionIndex]
                                                        ['choices']
                                                    .removeLast();

                                                adminProvider
                                                    .subQuestionsControllers[
                                                        questionIndex]
                                                        ['choicesNotes']
                                                    .removeLast();
                                                adminProvider.notify();
                                              }
                                            });
                                          },
                                          width: width * 0.2,
                                          height: null,
                                          verticalPadding: height * 0.02,
                                          horizontalPadding: width * 0.02,
                                          buttonColor: kDarkGray,
                                          border: fullBorder(kLightPurple),
                                          borderRadius: width * 0.005,
                                          child: Text(
                                            'احذف أخر خيار',
                                            style: textStyle(
                                                3, width, height, kLightPurple),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                                SizedBox(height: height * 0.02),
                              ],
                            ),
                          ],
                        ],
                        SizedBox(height: height * 0.02),
                        for (int headline = 0;
                            headline <
                                adminProvider
                                    .subQuestionsControllers[questionIndex]
                                        ['headlines']
                                    .length;
                            headline++) ...[
                          Row(
                            children: [
                              CustomTextField(
                                controller: adminProvider
                                        .subQuestionsControllers[questionIndex]
                                    ['headlines'][headline],
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
                                hintText: 'العنوان الفرعي',
                                hintTextColor: kWhite.withOpacity(0.5),
                                suffixIcon: null,
                                prefixIcon: null,
                                border: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                                focusedBorder: outlineInputBorder(
                                    width * 0.005, kLightPurple),
                              ),
                              SizedBox(width: width * 0.02),
                              Text(
                                'التصنيف:',
                                style:
                                    textStyle(3, width, height, kLightPurple),
                              ),
                              SizedBox(width: width * 0.01),
                              for (int i = 1; i < 6; i++) ...[
                                Row(
                                  children: [
                                    SizedBox(width: width * 0.01),
                                    Text(
                                      '$i',
                                      style: textStyle(
                                          3, width, height, kLightPurple),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        adminProvider.subQuestionsControllers[
                                                questionIndex]['headlinesLevel']
                                            [headline] = i;
                                        adminProvider.notify();
                                      },
                                      splashRadius: height * 0.01,
                                      icon: Icon(
                                        adminProvider.subQuestionsControllers[
                                                            questionIndex]
                                                        ['headlinesLevel']
                                                    [headline] ==
                                                i
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: kLightPurple,
                                        size: height * 0.03,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                              if (headline ==
                                  adminProvider
                                          .subQuestionsControllers[
                                              questionIndex]['headlines']
                                          .length -
                                      1) ...[
                                SizedBox(width: width * 0.03),
                                CustomContainer(
                                  onTap: () {
                                    adminProvider
                                        .subQuestionsControllers[questionIndex]
                                            ['headlines']
                                        .add(TextEditingController());
                                    adminProvider
                                        .subQuestionsControllers[questionIndex]
                                            ['headlinesLevel']
                                        .add(1);
                                    adminProvider.notify();
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
                                    style:
                                        textStyle(3, width, height, kDarkGray),
                                  ),
                                ),
                                SizedBox(width: width * 0.01),
                                CustomContainer(
                                  onTap: () {
                                    if (adminProvider
                                            .subQuestionsControllers[
                                                questionIndex]['headlines']
                                            .length >
                                        1) {
                                      adminProvider.subQuestionsControllers[
                                              questionIndex]['headlines']
                                          .removeLast();
                                      adminProvider.subQuestionsControllers[
                                              questionIndex]['headlinesLevel']
                                          .removeLast();
                                      adminProvider.notify();
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
                                    style: textStyle(
                                        3, width, height, kLightPurple),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: height * 0.02),
                        ],
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Text(
                              'مستوى الصعوبة:',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                            SizedBox(width: width * 0.03),
                            Text(
                              'سهل',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                            IconButton(
                              onPressed: () {
                                adminProvider
                                        .subQuestionsControllers[questionIndex]
                                    ['questionLevel'] = 1;
                                adminProvider.notify();
                              },
                              splashRadius: height * 0.01,
                              icon: Icon(
                                adminProvider.subQuestionsControllers[
                                            questionIndex]['questionLevel'] ==
                                        1
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: kLightPurple,
                                size: height * 0.03,
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            Text(
                              'متوسط',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                            IconButton(
                              onPressed: () {
                                adminProvider
                                        .subQuestionsControllers[questionIndex]
                                    ['questionLevel'] = 2;
                                adminProvider.notify();
                              },
                              splashRadius: height * 0.01,
                              icon: Icon(
                                adminProvider.subQuestionsControllers[
                                            questionIndex]['questionLevel'] ==
                                        2
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: kLightPurple,
                                size: height * 0.03,
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                            Text(
                              'صعب',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                            IconButton(
                              onPressed: () {
                                adminProvider
                                        .subQuestionsControllers[questionIndex]
                                    ['questionLevel'] = 3;
                                adminProvider.notify();
                              },
                              splashRadius: height * 0.01,
                              icon: Icon(
                                adminProvider.subQuestionsControllers[
                                            questionIndex]['questionLevel'] ==
                                        3
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: kLightPurple,
                                size: height * 0.03,
                              ),
                            ),
                            SizedBox(width: width * 0.03),
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            onTap: () {
                              adminProvider
                                  .addSubQuestion('finalAnswerQuestion');
                            },
                            width: width * 0.2,
                            height: null,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kLightPurple,
                            border: null,
                            borderRadius: width * 0.005,
                            child: Text(
                              'أضف سؤال جواب نهائي',
                              style: textStyle(3, width, height, kDarkGray),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          CustomContainer(
                            onTap: () {
                              if (adminProvider
                                  .subQuestionsControllers.isNotEmpty) {
                                adminProvider.removeLastSubQuestion();
                              }
                            },
                            width: width * 0.2,
                            height: null,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kDarkGray,
                            border: fullBorder(kLightPurple),
                            borderRadius: width * 0.005,
                            child: Text(
                              'حذف أخر سؤال',
                              style: textStyle(3, width, height, kLightPurple),
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          CustomContainer(
                            onTap: () {
                              adminProvider
                                  .addSubQuestion('multipleChoiceQuestion');
                            },
                            width: width * 0.2,
                            height: null,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kLightPurple,
                            border: null,
                            borderRadius: width * 0.005,
                            child: Text(
                              'أضف سؤال متعدد الخيارات',
                              style: textStyle(3, width, height, kDarkGray),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.05),
                      CustomTextField(
                        controller: adminProvider.questionSourceController,
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
                        hintText: 'مصدر السؤال',
                        hintTextColor: kWhite.withOpacity(0.5),
                        suffixIcon: null,
                        prefixIcon: null,
                        border: outlineInputBorder(width * 0.005, kLightPurple),
                        focusedBorder:
                            outlineInputBorder(width * 0.005, kLightPurple),
                      ),
                      SizedBox(height: height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomContainer(
                            onTap: () async {
                              adminProvider.setFromPicker(
                                  await ImagePickerWeb.getImageAsBytes());
                              adminProvider.setImage(
                                  base64.encode(adminProvider.fromPicker!));
                            },
                            width: width * 0.2,
                            height: height * 0.08,
                            verticalPadding: height * 0.02,
                            horizontalPadding: width * 0.02,
                            buttonColor: kLightPurple,
                            border: null,
                            borderRadius: width * 0.005,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'إرفاق صورة السؤال',
                                  style: textStyle(3, width, height, kDarkGray),
                                ),
                                SizedBox(width: width * 0.01),
                                Icon(
                                  Icons.file_upload_outlined,
                                  color: kDarkGray,
                                  size: (height * 0.01 * width * 0.01) * 0.2,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.2),
                          CustomContainer(
                            onTap: () {
                              if (acceptedQuestion(adminProvider)) {
                                List subQuestions = [];

                                for (Map question
                                    in adminProvider.subQuestionsControllers) {
                                  if (question['type'] ==
                                      'multipleChoiceQuestion') {
                                    subQuestions.add({
                                      'question': question['question'].text,
                                      'choices': [
                                        for (TextEditingController choice
                                            in question['choices'])
                                          choice.text
                                      ],
                                      'choicesNotes': [
                                        for (TextEditingController choiceNotes
                                            in question['choicesNotes'])
                                          choiceNotes.text
                                      ],
                                      'headlines': [
                                        for (TextEditingController headline
                                            in question['headlines'])
                                          headline.text
                                      ],
                                      'questionSource':
                                          question['questionSource'].text,
                                      'headlinesLevel': [
                                        for (int headlineLevel
                                            in question['headlinesLevel'])
                                          headlineLevel
                                      ],
                                      'questionLevel':
                                          question['questionLevel'],
                                      'type': 'multipleChoiceQuestion'
                                    });
                                  } else if (question['type'] ==
                                      'finalAnswerQuestion') {
                                    subQuestions.add({
                                      'question': question['question'].text,
                                      'answer': question['answer'].text,
                                      'headlines': [
                                        for (TextEditingController headline
                                            in question['headlines'])
                                          headline.text
                                      ],
                                      'questionSource':
                                          question['questionSource'].text,
                                      'headlinesLevel': [
                                        for (int headlineLevel
                                            in question['headlinesLevel'])
                                          headlineLevel
                                      ],
                                      'questionLevel':
                                          question['questionLevel'],
                                      'type': 'finalAnswerQuestion'
                                    });
                                  }
                                }

                                post('add_or_edit_multi_section_question/', {
                                  'edit': adminProvider.questionID.text != '',
                                  'ID': adminProvider.questionID.text,
                                  'question':
                                      adminProvider.questionController.text,
                                  'image': adminProvider.image,
                                  'subQuestions': subQuestions,
                                  'source': adminProvider
                                      .questionSourceController.text
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
                              'حفظ السؤال',
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
