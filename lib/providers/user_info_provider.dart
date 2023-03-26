import 'package:flutter/material.dart';

import '../utils/session.dart';

// Provider.of<UserInfoProvider>(context, listen: false)
// .createReceipt()
//     .then((value) {
// });
// Provider.of<UserInfoProvider>(context, listen: true).userName
// Provider.of<UserInfoProvider>(context, listen: false).setUserName(result['user_name']);
class UserInfoProvider with ChangeNotifier {
  String _userName = '';
  String _userPhone = '';
  String _userEmail = '';
  String _userPassword = '';

  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;
  String get userPassword => _userPassword;

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  void setUserPhone(String phone) {
    setSession('sessionKey1', phone);
    _userPhone = phone;
    notifyListeners();
  }

  void setUserEmail(String email) {
    setSession('sessionKey0', email);
    _userEmail = email;
    notifyListeners();
  }

  void setUserPassword(String password) {
    setSession('sessionValue', password);
    _userPassword = password;
    notifyListeners();
  }
}
