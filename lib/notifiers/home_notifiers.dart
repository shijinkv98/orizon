import 'package:flutter/material.dart';

class HomeTabNotifier extends ChangeNotifier {
  int _currentIndex = 2;
  int get currentIndex => _currentIndex;
  set currentIndex(int currentIndex) {
    _currentIndex = currentIndex;
    notifyListeners();
  }
}
