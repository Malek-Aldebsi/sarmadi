import 'package:flutter/material.dart';
import 'package:math_keyboard/math_keyboard.dart';

class SimilarQuestionsProvider with ChangeNotifier {
  String _subjectId = '';
  String _questionId = '';

  List _questions = [];
  Map _answers = {};

  int _questionIndex = 1;

  bool _copied = false;

  dynamic _questionResult = false;
  bool _showQuestionResult = false;

  String get subjectId => _subjectId;
  String get questionId => _questionId;

  List get questions => _questions;
  Map get answers => _answers;

  int get questionIndex => _questionIndex;

  bool get copied => _copied;

  dynamic get questionResult => _questionResult;
  bool get showResult => _showQuestionResult;

  void setQuestionId(String questionId) {
    reset();
    _questionId = questionId;
    notifyListeners();
  }

  void setSubjectId(String subjectId) {
    _subjectId = subjectId;
    notifyListeners();
  }

  void reset() {
    _subjectId = '';
    _questionId = '';

    _questions = [];
    _answers = {};

    _questionIndex = 1;

    _copied = false;

    _questionResult = false;
    _showQuestionResult = false;
  }

  void setQuestions(List questions) {
    _questions = questions;

    for (Map question in _questions) {
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
      _answers[question['id']] = {'duration': 0, 'saved': false};
    }
    notifyListeners();
  }

  void editQuestionAnswer(String questionID, String answer) {
    _answers[questionID]['answer'] = answer;
    notifyListeners();
  }

  void removeQuestionAnswer(String questionID) {
    _answers[questionID].remove('answer');
    notifyListeners();
  }

  void editSubQuestionAnswer(
      String questionID, String subQuestionID, String answer) {
    if (_answers[questionID]['answer'] == null) {
      _answers[questionID]['answer'] = {};
    }
    _answers[questionID]['answer'][subQuestionID] = answer;

    notifyListeners();
  }

  void removeSubQuestionAnswer(String questionID, String subQuestionID) {
    _answers[questionID]['answer'].remove(subQuestionID);
    if (_answers[questionID]['answer'].isEmpty) {
      _answers[questionID].remove('answer');
    }
    notifyListeners();
  }

  void editAnswerDuration(String questionID, int duration) {
    _answers[questionID]['duration'] += duration;
    notifyListeners();
  }

  void setQuestionIndex(int questionIndex) {
    _questionIndex = questionIndex;
    notifyListeners();
  }

  void setSaveQuestion(String questionID) {
    _answers[questionID]['saved'] = !_answers[questionID]['saved'];
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
