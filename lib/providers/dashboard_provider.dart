import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  String _todayDate = '00-00-0000';
  String _quote = '';
  List _advertisements = [];
  double _profileCompletionPercentage = 0;

  String get todayDate => _todayDate;
  String get quote => _quote;
  List get advertisements => _advertisements;
  double get profileCompletionPercentage => _profileCompletionPercentage;

  void setTodayDate(String todayDate) {
    _todayDate = todayDate;
    notifyListeners();
  }

  void setQuote(String quote) {
    _quote = quote;
    notifyListeners();
  }

  void setAdvertisement(List advertisements) {
    _advertisements = advertisements;
    notifyListeners();
  }

  void setProfileCompletionPercentage(double profileCompletionPercentage) {
    _profileCompletionPercentage = profileCompletionPercentage;
    notifyListeners();
  }
}
