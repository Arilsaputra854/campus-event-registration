import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewmodel extends ChangeNotifier {
  bool _isLogged = false;
  bool get isLogged => _isLogged;

  

  void setLoggedStatus(bool status) {
    _isLogged = status;
    notifyListeners();
  }

  Future<void> _saveLoginInfo(int userId, String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setInt('user_id', userId);
    await prefs.setString('user_name', userName);
  }
}
