import 'package:flutter/material.dart';

class CheckBoxNotifier extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  set isChecked(bool isChecked) {
    _isChecked = isChecked;
    notifyListeners();
  }
}

class DocsAddedNotifier extends ChangeNotifier {
  void docAdded() {
    notifyListeners();
  }
}

class PhysicalStoreClickNotifier extends ChangeNotifier {
  void radioButtonSelected() {
    notifyListeners();
  }
}
