import 'package:flutter/material.dart';

class WebsiteProvider with ChangeNotifier {
  bool _loaded = false;
  List _subjects = [];

  bool get loaded => _loaded;
  List get subjects => _subjects;

  void setLoaded(bool load) {
    _loaded = load;
    notifyListeners();
  }

  void setSubjects(List subjects) {
    _subjects = subjects;
    notifyListeners();
  }
}
