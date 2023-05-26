import 'package:flutter/material.dart';
import '../utils/session.dart';

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

  void setUserPhone() {
    setSession('sessionKey1', _userPhone.text);
    notifyListeners();
  }

  void setUserEmail() {
    setSession('sessionKey0', _userEmail.text);
    notifyListeners();
  }

  void setUserPassword() {
    setSession('sessionValue', _userPassword.text);
    notifyListeners();
  }
}
