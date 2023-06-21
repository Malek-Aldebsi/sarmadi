import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

class SharedQuestionProvider with ChangeNotifier {
  String _questionId = '';
  String _subjectId = '';

  Map _question = {};
  Map _answer = {};

  bool _copied = false;

  dynamic _questionResult = false;
  bool _showQuestionResult = false;

  String get questionId => _questionId;
  String get subjectId => _subjectId;

  Map get question => _question;
  Map get answers => _answer;

  bool get copied => _copied;

  dynamic get questionResult => _questionResult;
  bool get showResult => _showQuestionResult;

  void setQuestionId(String questionId) {
    _questionId = questionId;
  }

  void reset() {
    _subjectId = '';

    _question = {};
    _answer = {};

    _copied = false;

    _questionResult = false;
    _showQuestionResult = false;
  }

  void setSubjectId(String subjectId) {
    reset();
    _subjectId = subjectId;
    notifyListeners();
  }

  void setQuestions(Map question) {
    _question = question;

    if (question['type'] == 'multipleChoiceQuestion') {
      for (Map choice in question['choices']) {
        if (choice['body'] == 'جميع ما ذكر') {
          question['choices'].remove(choice);
          question['choices'].add(choice);
        }
      }
    } else if (question['type'] == 'finalAnswerQuestion') {
      if (_subjectId == 'ee25ba19-a309-4010-a8ca-e6ea242faa96') {
        question['controller'] = MathFieldEditingController();
      } else {
        question['controller'] = TextEditingController();
      }
    } else if (question['type'] == 'multiSectionQuestion') {
      for (Map subQuestion in question['sub_questions']) {
        if (subQuestion['type'] == 'finalAnswerQuestion') {
          if (_subjectId == 'ee25ba19-a309-4010-a8ca-e6ea242faa96') {
            subQuestion['controller'] = MathFieldEditingController();
          } else {
            subQuestion['controller'] = TextEditingController();
          }
        }
      }
    }
    _answer[question['id']] = {'duration': 0, 'saved': false};

    notifyListeners();
  }

  void editQuestionAnswer(String questionID, String answer) {
    _answer[questionID]['answer'] = answer;
    notifyListeners();
  }

  void removeQuestionAnswer(String questionID) {
    _answer[questionID].remove('answer');
    notifyListeners();
  }

  void editSubQuestionAnswer(
      String questionID, String subQuestionID, String answer) {
    if (_answer[questionID]['answer'] == null) {
      _answer[questionID]['answer'] = {};
    }
    _answer[questionID]['answer'][subQuestionID] = answer;

    notifyListeners();
  }

  void removeSubQuestionAnswer(String questionID, String subQuestionID) {
    _answer[questionID]['answer'].remove(subQuestionID);
    if (_answer[questionID]['answer'].isEmpty) {
      _answer[questionID].remove('answer');
    }
    notifyListeners();
  }

  void editAnswerDuration(String questionID, int duration) {
    _answer[questionID]['duration'] += duration;
    notifyListeners();
  }

  void setSaveQuestion(String questionID) {
    _answer[questionID]['saved'] = !_answer[questionID]['saved'];
    notifyListeners();
  }

  void setCopied(bool copied) {
    _copied = copied;
    notifyListeners();
  }

  void setQuestionResult(dynamic questionResult) {
    _questionResult = questionResult;
    notifyListeners();
  }

  void setShowResult(bool showResult) {
    _showQuestionResult = showResult;
    notifyListeners();
  }
}
