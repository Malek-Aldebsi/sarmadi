import 'package:flutter/material.dart';

class WebsiteProvider with ChangeNotifier {
  bool _loaded = false;
  List _subjects = [];
  String _lastRoot = '/QuizSetting';

  bool get loaded => _loaded;
  List get subjects => _subjects;
  String get lastRoot => _lastRoot;

  void setLoaded(bool load) {
    _loaded = load;
    notifyListeners();
  }

  void setSubjects(List subjects) {
    _subjects = subjects;
    notifyListeners();
  }

  void setLastRoot(String lastRoot) {
    _lastRoot = lastRoot;
    notifyListeners();
  }
}
