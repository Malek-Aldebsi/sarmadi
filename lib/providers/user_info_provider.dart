import 'package:flutter/material.dart';
import '../utils/session.dart';
import '../utils/encrypt.dart';

class UserInfoProvider with ChangeNotifier {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _userPhone = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  TextEditingController _userPassword = TextEditingController();
  TextEditingController _userConfirmPassword = TextEditingController();

  TextEditingController get firstName => _firstName;
  TextEditingController get lastName => _lastName;
  TextEditingController get userPhone => _userPhone;
  TextEditingController get userEmail => _userEmail;
  TextEditingController get userPassword => _userPassword;
  TextEditingController get userConfirmPassword => _userConfirmPassword;

  void setUserFirstName(String firstName) {
    _firstName.text = firstName;
    notifyListeners();
  }

  void setUserLastName(String lastName) {
    _lastName.text = lastName;
    notifyListeners();
  }

  void setUserEmail([email]) {
    setSession('sessionKey0', email ?? _userEmail.text);
    notifyListeners();
  }

  void setUserPhone([phone]) {
    setSession('sessionKey1', phone ?? _userPhone.text);
    notifyListeners();
  }

  void setUserPassword([password]) {
    setSession('sessionValue', password ?? encrypt(_userPassword.text));
    notifyListeners();
  }

  void reset() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _userPhone = TextEditingController();
    _userEmail = TextEditingController();
    _userPassword = TextEditingController();
    _userConfirmPassword = TextEditingController();
    notifyListeners();
  }
}
