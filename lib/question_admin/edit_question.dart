import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/const/borders.dart';

import '../components/custom_text_field.dart';
import '../const/colors.dart';
import '../providers/admin_provider.dart';
import '../utils/http_requests.dart';
import 'final_answer_question.dart';
import 'multi_section_question.dart';
import 'multiple_choice_question.dart';

class EditQuestion extends StatefulWidget {
  static const String route = '/EditQuestion/';

  const EditQuestion({Key? key}) : super(key: key);

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  editMultipleChoiceQuestion(Map result, AdminProvider adminProvider) {
    adminProvider.setQuestion(result['body']);

    adminProvider.setChoices([
      result['correct_answer']['body'],
      for (Map choice in result['choices'])
        if (choice['body'] != result['correct_answer']['body']) choice['body']
    ], [
      result['correct_answer']['notes'],
      for (Map choice in result['choices'])
        if (choice['body'] != result['correct_answer']['body']) choice['notes']
    ]);

    adminProvider.setHeadlines(result['headlines']);
    adminProvider.setQuestionSource(result['author']);
    adminProvider.setQuestionLevel(result['level']);
    Navigator.pushNamed(context, MultipleChoiceQuestion.route);
  }

  editFinalAnswerQuestion(Map result, AdminProvider adminProvider) {
    adminProvider.setQuestion(result['body']);
    adminProvider.setFinalAnswer(result['correct_answer']['body']);
    adminProvider.setHeadlines(result['headlines']);
    adminProvider.setQuestionSource(result['author']);
    adminProvider.setQuestionLevel(result['level']);
    Navigator.pushNamed(context, FinalAnswerQuestion.route);
  }

  editMultiSectionQuestion(Map result, AdminProvider adminProvider) {
    adminProvider.setQuestion(result['body']);
    List subQuestions = [];
    print(result);
    for (Map question in result['sub_questions']) {
      if (question['type'] == 'multipleChoiceQuestion') {
        subQuestions.add({
          'question': TextEditingController(text: question['body']),
          'choices': [
            TextEditingController(text: question['correct_answer']['body']),
            for (Map choice in question['choices'])
              if (question['correct_answer']['id'] != choice['id'])
                TextEditingController(text: choice['body'])
          ],
          'choicesNotes': [
            TextEditingController(text: question['correct_answer']['notes']),
            for (Map choice in question['choices'])
              if (question['correct_answer']['id'] != choice['id'])
                TextEditingController(text: choice['notes'])
          ],
          'headlines': [
            for (Map headline in question['headlines'])
              TextEditingController(text: headline['headline'])
          ],
          'questionSource': TextEditingController(text: question['author']),
          'headlinesLevel': [
            for (Map headline in question['headlines']) headline['level']
          ],
          'questionLevel': question['level'],
          'type': 'multipleChoiceQuestion'
        });
      } else if (question['type'] == 'finalAnswerQuestion') {
        subQuestions.add({
          'question': TextEditingController(text: question['body']),
          'answer':
              TextEditingController(text: question['correct_answer']['body']),
          'headlines': [
            for (Map headline in question['headlines'])
              TextEditingController(text: headline['headline'])
          ],
          'questionSource': TextEditingController(text: question['author']),
          'headlinesLevel': [
            for (Map headline in question['headlines']) headline['level']
          ],
          'questionLevel': question['level'],
          'type': 'finalAnswerQuestion'
        });
      }
    }
    adminProvider.setSubQuestion(subQuestions);
    adminProvider.setQuestionSource(result['author']);

    Navigator.pushNamed(context, MultiSectionQuestion.route);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    AdminProvider adminProvider =
        Provider.of<AdminProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kDarkGray,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: SizedBox(
                height: height * 0.08,
                child: CustomTextField(
                  controller: adminProvider.questionID,
                  width: width * 0.4,
                  fontOption: 2,
                  fontColor: kDarkGray,
                  textAlign: null,
                  obscure: null,
                  readOnly: false,
                  focusNode: null,
                  maxLines: 1,
                  maxLength: 36,
                  keyboardType: null,
                  onChanged: (String text) {
                    adminProvider.notify();
                  },
                  onSubmitted: (value) {
                    post('get_admin_question/', {
                      'ID': adminProvider.questionID.text,
                    }).then((value) {
                      dynamic result = decode(value);

                      if (result['type'] == 'multipleChoiceQuestion') {
                        editMultipleChoiceQuestion(result, adminProvider);
                      } else if (result['type'] == 'finalAnswerQuestion') {
                        editFinalAnswerQuestion(result, adminProvider);
                      } else if (result['type'] == 'multiSectionQuestion') {
                        editMultiSectionQuestion(result, adminProvider);
                      }
                    });
                  },
                  backgroundColor: kLightPurple,
                  verticalPadding: height * 0.02,
                  horizontalPadding: width * 0.02,
                  isDense: true,
                  errorText: null,
                  hintText: 'ادخل كود السؤال',
                  hintTextColor: kDarkGray.withOpacity(0.5),
                  suffixIcon: null,
                  prefixIcon: null,
                  border: outlineInputBorder(width * 0.05, kTransparent),
                  focusedBorder: outlineInputBorder(width * 0.05, kTransparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
