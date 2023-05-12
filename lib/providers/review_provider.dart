import 'package:flutter/material.dart';

class ReviewProvider with ChangeNotifier {
  String _quizID = '';
  int _questionIndex = 1;
  String _quizSubject = '';
  String _quizTime = '';
  List _questions = [];
  bool _questionScrollState = false;
  int _correctQuestionsNum = 0;
  int _questionsNum = 0;
  Map _skills = {};
  List _statements=[];


  String get quizID => _quizID;
  int get questionIndex => _questionIndex;
  String get quizSubject => _quizSubject;
  String get quizTime => _quizTime;
  List get questions => _questions;
  List get statements => _statements;
  bool get questionScrollState => _questionScrollState;
  int get correctQuestionsNum => _correctQuestionsNum;
  int get questionsNum => _questionsNum;
  Map get skills => _skills;

  void setQuizID(String quizID) {
    reset();
    _quizID = quizID;
    notifyListeners();
  }

  void reset() {
    _quizID = '';
    _questionIndex = 1;
    _quizSubject = '';
    _quizTime = '';
    _questions = [];
    _statements=[];
    _questionScrollState = false;
    _correctQuestionsNum = 0;
    _skills = {};
  }

  void setQuestionIndex(int questionIndex) {
    _questionIndex = questionIndex;
    notifyListeners();
  }
  void setStatements(List statements) {
    _statements = statements;
    notifyListeners();
  }

  void setQuizSubject(String quizSubject) {
    _quizSubject = quizSubject;
    notifyListeners();
  }

  void setQuizTime(String quizTime) {
    _quizTime = quizTime;
    notifyListeners();
  }

  void setQuestions(List questions) {
    _questions = questions;
    notifyListeners();
  }

  void setQuestionScrollState(bool questionScrollState) {
    _questionScrollState = questionScrollState;
    notifyListeners();
  }

  void setCorrectQuestionsNum(int correctQuestionsNum) {
    _correctQuestionsNum = correctQuestionsNum;
    notifyListeners();
  }
  void setQuestionsNum(int questionsNum) {
    _questionsNum = questionsNum;
    notifyListeners();
  }

  void setSkills(Map skills) {
    _skills = skills;
    notifyListeners();
  }
}
