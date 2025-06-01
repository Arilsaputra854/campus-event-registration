import 'package:flutter/material.dart';

class SplashViewmodel extends ChangeNotifier{
  bool _isLogged = false;
  bool get isLogged  => _isLogged;


  void setLoggedStatus(bool status){
    _isLogged = status;
    notifyListeners();
  }
}