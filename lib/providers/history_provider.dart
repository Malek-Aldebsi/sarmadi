import 'package:flutter/material.dart';

class HistoryProvider with ChangeNotifier {
  List _quizzes = [];
  int _waitQuizzes = 0;

  List get quizzes => _quizzes;
  int get waitQuizzes => _waitQuizzes;

  void setQuizzes(List quizzes) {
    reset();
    _quizzes = quizzes;
    notifyListeners();
  }

  void reset() {
    _quizzes = [];
    _waitQuizzes = 0;
  }

  void addQuizzes(List quizzes) {
    _quizzes.addAll(quizzes);
    notifyListeners();
  }

  void setWaitQuizzes(int waitQuizzes) {
    _waitQuizzes = waitQuizzes;
    notifyListeners();
  }
}
