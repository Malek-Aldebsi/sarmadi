import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sarmadi/providers/quiz_setting_provider.dart';

class QuizProvider with ChangeNotifier {
  String _subjectID = '';
  String _subjectName = '';

  Set _selectedHeadlines = {};
  int _lessonNum = 0;

  int _questionNum = 20;

  int _duration = 300;
  bool _withTime = true;

  int _quizLevel = 0; // 0 easy, 1 hard, 2 default

  List _questions = [];

  Map _answers = {};

  int _questionIndex = 1;

  bool _copied = false;

  bool _showResult = false;
  bool _wait = false;

  String _quizID = '';

  String _quizResult = '0/0';
  String _quizDuration = '00:00:00';
  String _idealDuration = '00:00:00';
  Map _skills = {};

  String get quizID => _quizID;
  String get subjectID => _subjectID;
  String get subjectName => _subjectName;
  Set get selectedHeadlines => _selectedHeadlines;
  int get lessonNum => _lessonNum;
  int get questionNum => _questionNum;
  int get duration => _duration;
  bool get withTime => _withTime;
  int get quizLevel => _quizLevel;
  List get questions => _questions;
  Map get answers => _answers;
  int get questionIndex => _questionIndex;
  bool get showResult => _showResult;
  bool get wait => _wait;
  bool get copied => _copied;
  String get quizResult => _quizResult;
  String get quizDuration => _quizDuration;
  String get idealDuration => _idealDuration;
  Map get skills => _skills;

  void setSubject(String subjectID, String subjectName) {
    reset();
    _subjectID = subjectID;
    _subjectName = subjectName;
    notifyListeners();
  }

  void reset() {
    _subjectID = '';
    _subjectName = '';

    _lessonNum = 0;

    _selectedHeadlines = {};

    _questionNum = 20;

    _duration = 300;
    _withTime = true;

    _quizLevel = 0; // 0 easy, 1 hard, 2 default

    _questions = [];

    _answers = {};

    _questionIndex = 1;

    _copied = false;

    _showResult = false;
    _wait = false;

    _quizID = '';

    _quizResult = '0/0';
    _quizDuration = '00:00:00';
    _idealDuration = '00:00:00';
    _skills = {};
  }

  void setLessonNum(int lessonNum) {
    _lessonNum = lessonNum;
    notifyListeners();
  }

  void addHeadlines(List headlines, BuildContext context) {
    _selectedHeadlines.addAll(headlines);
    _lessonNum = 0;
    for (Map module
        in Provider.of<QuizSettingProvider>(context, listen: false).moduleSet) {
      for (Map lesson in module['lessons']) {
        if (_selectedHeadlines.containsAll(lesson['h1s'])) {
          _lessonNum++;
        }
      }
    }
    if (questionNum < _lessonNum) {
      setQuestionNum(_lessonNum);
    }
    notifyListeners();
  }

  void removeHeadlines(List headlines, BuildContext context) {
    _selectedHeadlines.removeAll(headlines);
    _lessonNum = 0;
    for (Map module
        in Provider.of<QuizSettingProvider>(context, listen: false).moduleSet) {
      for (Map lesson in module['lessons']) {
        if (_selectedHeadlines.containsAll(lesson['h1s'])) {
          _lessonNum++;
        }
      }
    }
    notifyListeners();
  }

  void setQuestionNum(int questionNum) {
    questionNum < _lessonNum
        ? _questionNum = _lessonNum
        : _questionNum = questionNum;

    notifyListeners();
  }

  void setDuration(String minutes, String hours) {
    _duration = int.parse(hours == '' ? '00' : hours) * 3600 +
        int.parse(minutes == '' ? '05' : minutes) * 60;
    notifyListeners();
  }

  void setWithTime() {
    _withTime = !withTime;
    notifyListeners();
  }

  void setQuizLevel(int quizLevel) {
    _quizLevel = quizLevel;
    notifyListeners();
  }

  void setQuestions(List questions) {
    resetQuiz();
    _questions = questions;
    for (Map question in _questions) {
      if (question['type'] == 'multipleChoiceQuestion') {
        for (Map choice in question['choices']) {
          if (choice['body'] == 'جميع ما ذكر') {
            question['choices'].remove(choice);
            question['choices'].add(choice);
          }
        }
      }
      _answers[question['id']] = {'duration': 0, 'saved': false};
      if (question['type'] == 'finalAnswerQuestion') {
        question['controller'] = TextEditingController();
      }

      if (question['type'] == 'multiSectionQuestion') {
        for (Map subQuestion in question['sub_questions']) {
          if (subQuestion['type'] == 'finalAnswerQuestion') {
            subQuestion['controller'] = TextEditingController();
          }
        }
      }
    }
    notifyListeners();
  }

  void setQuestionIndex(int questionIndex) {
    _questionIndex = questionIndex;
    notifyListeners();
  }

  void resetQuiz() {
    _questions = [];
    _answers = {};
    _questionIndex = 1;
    _copied = false;
    _showResult = false;
    _wait = false;
    _quizID = '';
    _quizResult = '0/0';
    _quizDuration = '00:00:00';
    _idealDuration = '00:00:00';
    _skills = {};
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

  void setSaveQuestion(String questionID) {
    _answers[questionID]['saved'] = !_answers[questionID]['saved'];
    notifyListeners();
  }

  void setCopied(bool copied) {
    _copied = copied;
    notifyListeners();
  }

  void setShowResult(bool showResult) {
    _showResult = showResult;
    notifyListeners();
  }

  void setWait(bool wait) {
    _wait = wait;
    notifyListeners();
  }

  void setQuizID(String quizID) {
    _quizID = quizID;
    notifyListeners();
  }

  void setQuizResult(String quizResult) {
    _quizResult = quizResult;
    notifyListeners();
  }

  void setQuizDuration(String quizDuration) {
    _quizDuration = quizDuration;
    notifyListeners();
  }

  void setQuizIdealDuration(String idealDuration) {
    _idealDuration = idealDuration;
    notifyListeners();
  }

  void setSkills(Map skills) {
    _skills = skills;
    notifyListeners();
  }
}
