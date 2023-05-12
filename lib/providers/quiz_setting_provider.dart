import 'package:flutter/material.dart';

class QuizSettingProvider with ChangeNotifier {
  List _headlineSet = [];
  List _moduleSet = [];

  List get headlineSet => _headlineSet;
  List get moduleSet => _moduleSet;


  void setModuleSet(List moduleSet) {
    _moduleSet = moduleSet;
    notifyListeners();
  }

  void setHeadlineSet(List headlineSet) {
    _headlineSet = headlineSet;
    notifyListeners();
  }

}
