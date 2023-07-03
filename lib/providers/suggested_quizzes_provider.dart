import 'package:flutter/material.dart';

class SuggestedQuizzesProvider with ChangeNotifier {
  List _quizzes = [];

  List get quizzes => _quizzes;

  void setQuizzes(List quizzes) {
    reset();
    _quizzes = quizzes;
    notifyListeners();
  }

  void reset() {
    _quizzes = [];
  }
}
