import 'dart:typed_data';

import 'package:flutter/material.dart';

class AdminProvider with ChangeNotifier {
  TextEditingController _questionID = TextEditingController();

  TextEditingController _questionController = TextEditingController();

  List _choicesControllers = [TextEditingController(), TextEditingController()];
  List _choicesNotesControllers = [
    TextEditingController(),
    TextEditingController()
  ];

  TextEditingController _finalAnswerController = TextEditingController();

  List _subQuestionsControllers = [];

  List _headlineController = [TextEditingController()];
  List _headlineLevel = [1];

  TextEditingController _questionSourceController = TextEditingController();

  int _questionLevel = 2;

  String? _image;
  Uint8List? _fromPicker;

  TextEditingController get questionController => _questionController;
  TextEditingController get questionID => _questionID;
  TextEditingController get finalAnswerController => _finalAnswerController;
  List get choicesNotesControllers => _choicesNotesControllers;
  List get choicesControllers => _choicesControllers;
  List get subQuestionsControllers => _subQuestionsControllers;
  TextEditingController get questionSourceController =>
      _questionSourceController;
  int get questionLevel => _questionLevel;
  List get headlineController => _headlineController;
  List get headlineLevel => _headlineLevel;
  String? get image => _image;
  Uint8List? get fromPicker => _fromPicker;

  void notify() {
    notifyListeners();
  }

  void setQuestion(question) {
    _questionController.text = question;
    notifyListeners();
  }

  void addSubQuestion(String type) {
    if (type == 'multipleChoiceQuestion') {
      _subQuestionsControllers.add({
        'question': TextEditingController(),
        'choices': [TextEditingController(), TextEditingController()],
        'choicesNotes': [TextEditingController(), TextEditingController()],
        'headlines': [TextEditingController()],
        'questionSource': TextEditingController(),
        'headlinesLevel': [1],
        'questionLevel': 2,
        'type': 'multipleChoiceQuestion'
      });
    } else if (type == 'finalAnswerQuestion') {
      _subQuestionsControllers.add({
        'question': TextEditingController(),
        'answer': TextEditingController(),
        'headlines': [TextEditingController()],
        'questionSource': TextEditingController(),
        'headlinesLevel': [1],
        'questionLevel': 2,
        'type': 'finalAnswerQuestion'
      });
    }
    notifyListeners();
  }

  void setSubQuestion(List subQuestion) {
    _subQuestionsControllers = subQuestion;
    notifyListeners();
  }

  void removeLastSubQuestion() {
    _subQuestionsControllers.removeLast();
    notifyListeners();
  }

  void setFinalAnswer(finalAnswer) {
    _finalAnswerController.text = finalAnswer;
    notifyListeners();
  }

  void setImage(image) {
    _image = image;
    notifyListeners();
  }

  void setFromPicker(fromPicker) {
    _fromPicker = fromPicker;
    notifyListeners();
  }

  void setQuestionSource(questionSource) {
    _questionSourceController.text = questionSource;
    notifyListeners();
  }

  void setQuestionLevel(int questionLevel) {
    _questionLevel = questionLevel;
    notifyListeners();
  }

  void setHeadlines(List headlines) {
    _headlineController = headlines
        .map((headline) => TextEditingController(text: headline['headline']))
        .toList();
    _headlineLevel = headlines.map((headline) => headline['level']).toList();

    notifyListeners();
  }

  void addHeadline() {
    _headlineController.add(TextEditingController());
    _headlineLevel.add(1);
    notifyListeners();
  }

  void removeLastHeadline() {
    _headlineController.removeLast();
    _headlineLevel.removeLast();
    notifyListeners();
  }

  void setHeadlineLevel(int headlineLevel, int index) {
    _headlineLevel[index] = headlineLevel;
    notifyListeners();
  }

  void setChoices(List choices, List notes) {
    _choicesControllers = [];
    _choicesNotesControllers = [];
    for (int i = 0; i < choices.length; i++) {
      _choicesControllers.add(TextEditingController(text: choices[i]));
      _choicesNotesControllers.add(TextEditingController(text: notes[i]));
    }
    notifyListeners();
  }

  void addChoice() {
    _choicesControllers.add(TextEditingController());
    _choicesNotesControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeLastChoice() {
    _choicesControllers.removeLast();
    _choicesNotesControllers.removeLast();
    notifyListeners();
  }

  void reset() {
    _questionID = TextEditingController();

    _questionController = TextEditingController();
    _finalAnswerController = TextEditingController();
    _subQuestionsControllers = [];

    _choicesControllers = [TextEditingController(), TextEditingController()];
    _choicesNotesControllers = [
      TextEditingController(),
      TextEditingController()
    ];

    _headlineController = [TextEditingController()];
    _headlineLevel = [1];

    _questionSourceController = TextEditingController();

    _questionLevel = 2;
    _image = null;
    _fromPicker = null;
    notifyListeners();
  }
}
