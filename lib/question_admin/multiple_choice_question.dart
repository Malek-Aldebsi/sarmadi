import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MultipleChoiceQuestion extends StatefulWidget {
  static const String route = '/MultipleChoiceQuestion/';

  const MultipleChoiceQuestion({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  bool acceptedQuestion(AdminProvider adminProvider) {
    bool checkChoices = true;
    for (TextEditingController choice in adminProvider.choicesControllers) {
      checkChoices &= choice.text != '';
    }
    bool checkHeadlines = true;
    for (TextEditingController headline in adminProvider.headlineController) {
      checkHeadlines &= headline.text != '';
    }
    return adminProvider.questionController.text != '' &&
        checkChoices &&
        adminProvider.choicesControllers.length >= 2 &&
        checkHeadlines &&
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
                                context.pushReplacement('/QuestionAdmin');
                              },
                              buttonColor: kLightPurple,
                              border: null,
                              borderRadius: width,
                              child: Icon(
                                Icons.home_rounded,
                                size: width * 0.02,
                                color: kDarkGray,
                              ),
                            ),
                            Text(
                              'سؤال متعدد الخيارات',
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
                      SizedBox(height: height * 0.1),
                      for (int i = 0;
                          i < adminProvider.choicesControllers.length;
                          i++) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CustomTextField(
                                  controller:
                                      adminProvider.choicesControllers[i],
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
                                  hintText:
                                      i == 0 ? 'الخيار الصحيح' : 'ادخل الخيار',
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
                                      adminProvider.choicesControllers[i].text,
                                      3,
                                      width,
                                      height,
                                      kDarkGray),
                                ),
                              ],
                            ),
                            if (i != 0) ...[
                              SizedBox(height: height * 0.02),
                              Row(
                                children: [
                                  CustomTextField(
                                    controller: adminProvider
                                        .choicesNotesControllers[i],
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
                                    hintText: 'معلومة إضافية',
                                    hintTextColor: kWhite.withOpacity(0.5),
                                    suffixIcon: null,
                                    prefixIcon: null,
                                    border: outlineInputBorder(
                                        width * 0.005, kLightPurple),
                                    focusedBorder: outlineInputBorder(
                                        width * 0.005, kLightPurple),
                                  ),
                                  if (i ==
                                      adminProvider.choicesControllers.length -
                                          1) ...[
                                    SizedBox(width: width * 0.02),
                                    CustomContainer(
                                      onTap: () {
                                        adminProvider.addChoice();
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
                                        if (adminProvider
                                                .choicesControllers.length >
                                            2) {
                                          adminProvider.removeLastChoice();
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
                                        'احذف أخر خيار',
                                        style: textStyle(
                                            3, width, height, kLightPurple),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ]
                          ],
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                      SizedBox(height: height * 0.05),
                      for (int headline = 0;
                          headline < adminProvider.headlineController.length;
                          headline++) ...[
                        Row(
                          children: [
                            CustomTextField(
                              controller:
                                  adminProvider.headlineController[headline],
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
                              style: textStyle(3, width, height, kLightPurple),
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
                                      adminProvider.setHeadlineLevel(
                                          i, headline);
                                    },
                                    splashRadius: height * 0.01,
                                    icon: Icon(
                                      adminProvider.headlineLevel[headline] == i
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
                                adminProvider.headlineController.length -
                                    1) ...[
                              SizedBox(width: width * 0.03),
                              CustomContainer(
                                onTap: () {
                                  adminProvider.addHeadline();
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
                                  if (adminProvider.headlineController.length >
                                      1) {
                                    adminProvider.removeLastHeadline();
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
                      SizedBox(height: height * 0.03),
                      Row(
                        children: [
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
                            border:
                                outlineInputBorder(width * 0.005, kLightPurple),
                            focusedBorder:
                                outlineInputBorder(width * 0.005, kLightPurple),
                          ),
                          SizedBox(width: width * 0.05),
                          Row(
                            children: [
                              Text(
                                'مستوى الصعوبة:',
                                style:
                                    textStyle(3, width, height, kLightPurple),
                              ),
                              SizedBox(width: width * 0.03),
                              Text(
                                'سهل',
                                style:
                                    textStyle(3, width, height, kLightPurple),
                              ),
                              IconButton(
                                onPressed: () {
                                  adminProvider.setQuestionLevel(1);
                                },
                                splashRadius: height * 0.01,
                                icon: Icon(
                                  adminProvider.questionLevel == 1
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: kLightPurple,
                                  size: height * 0.03,
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                              Text(
                                'متوسط',
                                style:
                                    textStyle(3, width, height, kLightPurple),
                              ),
                              IconButton(
                                onPressed: () {
                                  adminProvider.setQuestionLevel(2);
                                },
                                splashRadius: height * 0.01,
                                icon: Icon(
                                  adminProvider.questionLevel == 2
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: kLightPurple,
                                  size: height * 0.03,
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                              Text(
                                'صعب',
                                style:
                                    textStyle(3, width, height, kLightPurple),
                              ),
                              IconButton(
                                onPressed: () {
                                  adminProvider.setQuestionLevel(3);
                                },
                                splashRadius: height * 0.01,
                                icon: Icon(
                                  adminProvider.questionLevel == 3
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: kLightPurple,
                                  size: height * 0.03,
                                ),
                              ),
                              SizedBox(width: width * 0.03),
                            ],
                          )
                        ],
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
                                post('add_or_edit_multiple_choice_question/', {
                                  'edit': adminProvider.questionID.text != '',
                                  'ID': adminProvider.questionID.text,
                                  'question':
                                      adminProvider.questionController.text,
                                  'image': adminProvider.image,
                                  'choices': [
                                    for (TextEditingController choice
                                        in adminProvider.choicesControllers)
                                      choice.text
                                  ],
                                  'notes': [
                                    for (TextEditingController choiceNote
                                        in adminProvider
                                            .choicesNotesControllers)
                                      choiceNote.text
                                  ],
                                  'headlines': [
                                    for (TextEditingController headline
                                        in adminProvider.headlineController)
                                      headline.text
                                  ],
                                  'headlines_level': [
                                    for (int headlineLevel
                                        in adminProvider.headlineLevel)
                                      headlineLevel
                                  ],
                                  'source': adminProvider
                                      .questionSourceController.text,
                                  'level': adminProvider.questionLevel,
                                }).then((value) async {
                                  dynamic result = decode(value);
                                  if (result['check'] == 1) {
                                    await Clipboard.setData(
                                        ClipboardData(text: result['id']));
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
