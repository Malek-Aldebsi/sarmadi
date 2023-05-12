import 'package:flutter/material.dart';

class QuestionProvider with ChangeNotifier {
  String _questionId = '';
  int _questionIndex = 1;
  bool _copied = false;
  bool _showQuestionResult = false;
  List _questions = [];
  Map _answers = {};

  String get questionId => _questionId;
  int get questionIndex => _questionIndex;
  bool get copied => _copied;
  bool get showResult => _showQuestionResult;
  List get questions => _questions;
  Map get answers => _answers;

  void setQuestionId(String questionId) {
    reset();
    _questionId = questionId;
    notifyListeners();
  }

  void reset() {
    _questionId = '';
    _questionIndex = 1;
    _copied = false;
    _showQuestionResult = false;
    _questions = [];
    _answers = {};
  }

  void setQuestionIndex(int questionIndex) {
    _questionIndex = questionIndex;
    notifyListeners();
  }

  void setCopied(bool copied) {
    _copied = copied;
    notifyListeners();
  }

  void setShowResult(bool showResult) {
    _showQuestionResult = showResult;
    notifyListeners();
  }

  void setQuestions(List questions) {
    _questions = questions;
    for (Map question in _questions) {
      for (Map choice in question['choices']) {
        if (choice['body'] == 'جميع ما ذكر') {
          question['choices'].remove(choice);
          question['choices'].add(choice);
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

  void editAnswerDuration(String questionID, int duration) {
    _answers[questionID]['duration'] += duration;
    notifyListeners();
  }
}
